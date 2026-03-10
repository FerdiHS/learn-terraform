terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}


variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-c"
}

variable "artifact_registry_repository_id" {
  description = "Artifact Registry repository name"
  type        = string
  default     = "learn-terraform"
}

variable "go_api_image" {
  description = "Full Artifact Registry image URL for the Go API"
  type        = string
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "run_api" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry_api" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  description   = "Docker images for learn-terraform"
  format        = "docker"

  depends_on = [google_project_service.artifact_registry_api]
}

resource "google_cloud_run_v2_service" "go_api" {
  name                = "go-api"
  location            = var.region
  deletion_protection = false

  template {
    containers {
      image = var.go_api_image

      ports {
        container_port = 8080
      }
    }
  }

  depends_on = [google_project_service.run_api]
}

resource "google_cloud_run_service_iam_binding" "go_api_public" {
  location = google_cloud_run_v2_service.go_api.location
  service  = google_cloud_run_v2_service.go_api.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

output "go_api_url" {
  value = google_cloud_run_v2_service.go_api.uri
}
