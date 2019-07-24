variable "gke_machine_type" {
  default = "n1-standard-2"
}

variable gcp_project_id {
  default = "terraform-k8s-gke-traefik-dtalks"
}

variable gcp_project_name {
  default = "D-talks"
}

variable "gcp_billing_accpint_name" {
  default = "kyle"
}

variable region {
  default = "asia-northeast1"
}

variable zone {
  default = "asia-northeast1-b"
}

variable network_name {
  default = "d-talks"
}
