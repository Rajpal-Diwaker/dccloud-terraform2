locals {
  project_id = "custom-valve-332208"
}

resource "google_project_service" "project" {
  project = local.project_id
  service = "iam.googleapis.com"
  disable_dependent_services = true
}

resource "google_service_account" "sa-name" {
  account_id = "devtest"
  display_name = "Service Account"
}

resource "google_project_iam_member" "iam" {
  project = local.project_id
  #role    = ["roles/storage.admin","roles/compute.networkAdmin"]
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.sa-name.email}"
}