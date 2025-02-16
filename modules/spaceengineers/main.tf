module "game" {
  source = "./../game"
  count = var.enabled ? 1 : 0

  game_name                   = "spaceengineers"
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
  tcp_ports                   = []
  udp_ports                   = [27016]
  shutdown_port_on_no_players = 27016
  shutdown_protocol_on_no_players = "udp"
  duck_dns_domain = var.duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name = var.bucket_name
  save_files_path = "/home/ubuntu/spaceengineers/server/instances"
  boot_disk_size = 20
  instance_type = "n2d-standard-4"
  settings_path = var.settings_path
  startup_url_extra_info = "Server Name: ${var.server_name}\nServer Url: ${var.duck_dns_domain}.duckdns.org\n"

  depends_on = [google_storage_bucket_object.docker_compose]
}

resource "google_storage_bucket_object" "docker_compose" {
 count = var.enabled ? 1 : 0
 name         = "spaceengineers/docker-compose.yml"
 content      = templatefile("${path.module}/docker/docker-compose.yml", {
   server_name     = var.server_name
 })
 content_type = "text/plain"
 bucket       = var.bucket_name
}
