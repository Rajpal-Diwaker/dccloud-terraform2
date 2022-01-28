locals {
  project_id = "custom-valve-332208"
}

resource "google_project_service" "project" {
  project = local.project_id
  service = "iam.googleapis.com"
  disable_dependent_services = true
}

resource "google_service_account" "sa-name" {
  account_id = "sa-name"
  display_name = "SA"
}

resource "google_project_iam_member" "firestore_owner_binding" {
  project = local.project_id
  role    = "roles/datastore.owner"
  member  = "serviceAccount:${google_service_account.sa-name.email}"
}