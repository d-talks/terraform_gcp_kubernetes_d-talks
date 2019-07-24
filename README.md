# Traefik on Google Cloud Kubernetes Engine

## Requirements

- Google Cloud Account
- gcloud SDK installed
- GCP Project with Billing and Compute Engine Enabled

## Steps

### Setup CLI

```
gcloud init
gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

### Edit Files

As of RBAC Constraints on GKE, it's necessary to edit one file.

[permissions.yml](services/traefik/01_permissions.yml)

On line 12

```
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: <yourgcpaccountemail.com>
```

please enter your valid GCP account email.

### Create Cluster

```
terraform init
terraform apply
```

### Setup Kubectl

```
gcloud container clusters get-credentials $(terraform output cluster_name) --zone $(terraform output cluster_zone)
```

### Spawn Traefik as Ingress Controller

```
kubectl apply -f services/traefik
```

### Spawn Services

```
kubectl apply -f services/[SERVICE]
```

### Registry Secret

```
# create a GCP service account; format of account is email address
SA_EMAIL=$(gcloud iam service-accounts --format='value(email)' create k8s-gcr-auth-ro)
# create the json key file and associate it with the service account
gcloud iam service-accounts keys create k8s-gcr-auth-ro.json --iam-account=$SA_EMAIL
# get the project id
PROJECT=$(gcloud config list core/project --format='value(core.project)')
# add the IAM policy binding for the defined project and service account
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/storage.objectViewer

SECRETNAME=var-registry-secret

kubectl create secret docker-registry $SECRETNAME \
  --docker-server=https://gcr.io \
  --docker-username=_json_key \
  --docker-email=oh_cho@caredoc.kr \
  --docker-password="$(cat k8s-gcr-auth-ro.json)"
```
