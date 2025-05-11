module "game" {
  source = "./../game"
  count = var.enabled ? 1 : 0

  game_name                   = "moria"
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
  tcp_ports                   = []
  udp_ports                   = [7777]
  shutdown_port_on_no_players = 7777
  shutdown_protocol_on_no_players = "udp"
  duck_dns_domain = var.duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name = var.bucket_name
  instance_type = "n2d-standard-4"
  save_files_path = "/home/ubuntu/moria/moria-server/server/Moria/Saved"
  settings_path = var.settings_path
  startup_url_extra_info = "Server Url: ${var.duck_dns_domain}.duckdns.org\n"

  depends_on = [google_storage_bucket_object.docker_compose]
}

resource "google_storage_bucket_object" "docker_compose" {
 count = var.enabled ? 1 : 0
 name         = "moria/docker-compose.yml"
 content      = file("${path.module}/docker/docker-compose.yml")
 content_type = "text/plain"
 bucket       = var.bucket_name
}
