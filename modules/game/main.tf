# Instance Setup
resource "google_compute_network" "vpc_network" {
  name = "${var.game_name}-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.game_name}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_instance" "vm_instance" {
  name         = "${var.game_name}-instance"
  machine_type = var.instance_type
  tags         = ["ssh"]
  
  metadata_startup_script = templatefile("${path.module}/scripts/startup.sh", {
    game_name      = var.game_name
    bucket_name    = var.bucket_name
    save_files_path = var.save_files_path
  })

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size = var.boot_disk_size
      type = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.id
    access_config {
    }
  }

  service_account {
    email  = google_service_account.instance.email
    scopes = ["storage-rw"]
  }

  depends_on = [
    google_storage_bucket_object.autoshutdown,
    google_storage_bucket_object.autoshutdown_service,
    google_storage_bucket_object.cron,
    google_storage_bucket_object.duck_sh,
    google_storage_bucket_object.backups_sh
  ]
}

resource "google_service_account" "instance" {
  account_id   = "instance${var.game_name}"
  display_name = "Service account for the game instance"
  create_ignore_already_exists = true
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = var.bucket_name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.instance.email}"
}

resource "google_compute_firewall" "ssh" {
  name = "${var.game_name}-allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "game" {
  name    = "${var.game_name}-firewall"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = var.tcp_ports
  }
  allow {
    protocol = "udp"
    ports    = var.udp_ports
  }
  source_ranges = ["0.0.0.0/0"]
}

# Scripts Setup

resource "google_storage_bucket_object" "duck_sh" {
 name         = "${var.game_name}/duck.sh"
 content      = templatefile("${path.module}/scripts/duck.sh", {
   game_name = var.game_name
   duck_dns_domain = var.duck_dns_domain
   duck_dns_token  = var.duck_dns_token
 })
 content_type = "text/plain"
 bucket       = var.bucket_name
}

resource "google_storage_bucket_object" "backups_sh" {
 name         = "${var.game_name}/backups.sh"
 content      = templatefile("${path.module}/scripts/backups.sh", {
   game_name = var.game_name
   save_files_path = var.save_files_path
   bucket_name = var.bucket_name
 })
 content_type = "text/plain"
 bucket       = var.bucket_name
}

resource "google_storage_bucket_object" "cron" {
 name         = "${var.game_name}/jobs.cron"
 content      = templatefile("${path.module}/scripts/jobs.cron", {
   game_name = var.game_name
 })
 content_type = "text/plain"
 bucket       = var.bucket_name
}

resource "google_storage_bucket_object" "autoshutdown_service" {
 name         = "${var.game_name}/auto-shutdown.service"
 content      = templatefile("${path.module}/scripts/auto-shutdown.service", {
   game_name = var.game_name
 })
 content_type = "text/plain"
 bucket       = var.bucket_name
}

resource "google_storage_bucket_object" "autoshutdown" {
 name         = "${var.game_name}/auto-shutdown.sh"
 content      = local.shutdown_script
 content_type = "text/plain"
 bucket       = var.bucket_name
}

data "archive_file" "server_settings_tar" {
  type        = "tar.gz"
  output_path = "/tmp/${var.game_name}/server_settings.tar.gz"
  
  source_dir  = var.settings_path
}

resource "google_storage_bucket_object" "server_settings" {
 name         = "${var.game_name}/server_settings.tar.gz"
 source      = data.archive_file.server_settings_tar.output_path
 bucket       = var.bucket_name
}

# Startup Function Setup

data "archive_file" "code" {
  type        = "zip"
  output_path = "/tmp/code.zip"
  
  source_dir  = "${path.module}/functions/"
  excludes = [ "cmd" ]
}

resource "google_storage_bucket_object" "code" {
  name   = "functions/code.zip"
  bucket = var.bucket_name
  source = data.archive_file.code.output_path
}

resource "google_service_account" "cloud_function" {
  account_id   = "cloudfunction${var.game_name}"
  display_name = "Default service account for the cloud function"
  create_ignore_already_exists = true
}

resource "google_cloudfunctions2_function" "startup_function" {
  name        = "satrtup-function-${var.game_name}"
  location    = var.region

  build_config {
    runtime     = "go121"
    entry_point = "StartInstanceHTTP"
    source {
      storage_source {
        bucket = var.bucket_name
        object = google_storage_bucket_object.code.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "128Mi"
    timeout_seconds    = 60
    environment_variables = {
        INSTANCE_NAME = google_compute_instance.vm_instance.name
        ZONE         = var.zone
        PROJECT_ID   = var.project
        STATIC_INFO =  var.startup_url_extra_info
    }
    service_account_email = google_service_account.cloud_function.email
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  service  = google_cloudfunctions2_function.startup_function.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_compute_instance_iam_member" "instance_permissions" {
  instance_name = google_compute_instance.vm_instance.name

  role   = "roles/compute.instanceAdmin.v1"
  member = "serviceAccount:${google_service_account.cloud_function.email}"
}
