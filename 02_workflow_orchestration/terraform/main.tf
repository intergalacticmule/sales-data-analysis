terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "6.17.0"
        }
    }
}

provider "google" {
    credentials = file(var.credentials)
    project     = var.project
    region      = var.region
}

resource "google_storage_bucket" "sales-data-bucket" {
    name          = var.gcs_bucket_name
    location      = var.location
    force_destroy = true

    lifecycle_rule {
        condition {
            age = 1
        }
        action {
            type = "AbortIncompleteMultipartUpload"
        }
    }
}

resource "google_bigquery_dataset" "sales-data-dataset" {
    dataset_id = "${var.bq_datasets[count.index]}"
    count = length("${var.bq_datasets}")
    location   = var.location
    delete_contents_on_destroy = true
}

