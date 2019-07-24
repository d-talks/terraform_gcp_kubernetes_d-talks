data "google_container_engine_versions" "default" {
  version_prefix = "1.12.8-gke.10"
  zone = "${var.zone}"
}
