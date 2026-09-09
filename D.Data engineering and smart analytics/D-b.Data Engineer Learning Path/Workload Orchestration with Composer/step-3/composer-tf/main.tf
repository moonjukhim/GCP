resource "google_project_service" "composer_api" {
    project = var.project_id
    service = "composer.googleapis.com"
    disable_on_destroy = false
}

resource "google_service_account" "composer_account" {
    account_id   = "composer-account"
    display_name = "Custom SA for Cloud Composer Nodes"
}

resource "google_project_iam_member" "composer_account_bindings" {
    for_each = toset([
        "roles/composer.worker",
        "roles/storage.admin", // So Airflow can access GCS
        "roles/dataflow.admin",
        "roles/bigquery.admin",
    ])

    project  = var.project_id
    member   = "serviceAccount:${google_service_account.composer_account.email}"
    role     = each.value
}

resource "google_composer_environment" "lab_environment" {
    name    = "lab-environment"
    project = var.project_id
    region  = var.default_region

        config {
            software_config {
                image_version = "composer-3-airflow-2"
            }
            node_config {
                service_account = google_service_account.composer_account.email
            }

        environment_size = "ENVIRONMENT_SIZE_SMALL"
    } // ENVIRONMENT_SIZE_MEDIUM, ENVIRONMENT_SIZE_LARGE
}

```terraform
resource "google_bigquery_dataset" "logs" {
    dataset_id = "logs"  
    project    = var.project_id
    location   = var.default_region
}
```