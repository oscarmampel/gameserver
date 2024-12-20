module "game" {
  source = "./../game"
  count = var.enabled ? 1 : 0

  game_name                   = "satisfactory"
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
  tcp_ports                   = [7777]
  udp_ports                   = [7777]
  shutdown_port_on_no_players = 7777
  duck_dns_domain = var.duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name = var.bucket_name
  save_files_path = "/home/ubuntu/satisfactory/satisfactory-server/saved"

  depends_on = [google_storage_bucket_object.docker_compose, google_storage_bucket_object.dockerfile]
}

resource "google_storage_bucket_object" "docker_compose" {
 name         = "satisfactory/docker-compose.yml"
 content      = file("${path.module}/docker/docker-compose.yml")
 content_type = "text/plain"
 bucket       = var.bucket_name
}

resource "google_storage_bucket_object" "dockerfile" {
 name         = "satisfactory/dockerfile"
 content      = file("${path.module}/docker/dockerfile")
 content_type = "text/plain"
 bucket       = var.bucket_name
}
