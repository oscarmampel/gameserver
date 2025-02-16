terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_storage_bucket" "static_files" {
  name          = "game-save-files"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true

  uniform_bucket_level_access = true
}

module "satisfactory" {
  source          = "./modules/satisfactory"
  project         = var.project
  region          = var.region
  zone            = var.zone
  duck_dns_domain = var.satisfactory_duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name     = google_storage_bucket.static_files.name
  enabled         = var.satisfactory_enabled
  settings_path = "${path.module}/settings/satisfactory/"
}

module "foundry" {
  source          = "./modules/foundry"
  project         = var.project
  region          = var.region
  zone            = var.zone
  duck_dns_domain = var.foundry_duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name     = google_storage_bucket.static_files.name
  enabled         = var.foundry_enabled
  server_password = var.foundry_server_password
  server_name     = var.foundry_server_name
  settings_path = "${path.module}/settings/foundry/"
}

module "vrising" {
  source          = "./modules/vrising"
  project         = var.project
  region          = var.region
  zone            = var.zone
  bucket_name     = google_storage_bucket.static_files.name
  enabled         = var.vrising_enabled
  server_name     = var.vrising_server_name
  settings_path = "${path.module}/settings/vrising/"
}

module "spaceengineers" {
  source          = "./modules/spaceengineers"
  project         = var.project
  region          = var.region
  zone            = var.zone
  duck_dns_domain = var.spaceengineers_duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name     = google_storage_bucket.static_files.name
  enabled         = var.spaceengineers_enabled
  server_name     = var.spaceengineers_server_name
  settings_path = "${path.module}/settings/spaceengineers/"
}

