terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

variable "project_id" {
  description = "The ID of the project in which to create the resources."
  type        = string
}

provider "google" {
  project = var.project_id
  region  = "asia-southeast1"
  zone    = "asia-southeast1-c"
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = true
}
