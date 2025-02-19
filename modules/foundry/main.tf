module "game" {
  source = "./../game"
  count = var.enabled ? 1 : 0

  game_name                   = "foundry"
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
  tcp_ports                   = []
  udp_ports                   = [3724, 27015]
  shutdown_port_on_no_players = 3724
  shutdown_protocol_on_no_players = "udp"
  duck_dns_domain = var.duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name = var.bucket_name
  save_files_path = "/home/ubuntu/foundry/server/data"
  settings_path = var.settings_path
  startup_url_extra_info = "Server Name: ${var.server_name}\n"

  depends_on = [google_storage_bucket_object.docker_compose]
}

resource "google_storage_bucket_object" "docker_compose" {
 count = var.enabled ? 1 : 0
 name         = "foundry/docker-compose.yml"
 content      = templatefile("${path.module}/docker/docker-compose.yml", {
   server_password = var.server_password
   server_name     = var.server_name
   public_server   = var.public_server ? "true" : "false"
 })
 content_type = "text/plain"
 bucket       = var.bucket_name
}
