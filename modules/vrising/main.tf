module "game" {
  source = "./../game"
  count = var.enabled ? 1 : 0

  game_name                   = "vrising"
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
  tcp_ports                   = []
  udp_ports                   = [9876, 9877]
  shutdown_port_on_no_players = 9876
  shutdown_protocol_on_no_players = "udp"
  bucket_name = var.bucket_name
  save_files_path = "/home/ubuntu/vrising/vrising-server/persistentdata"
  startup_url_extra_info = "Server Name: ${var.server_name}\n"
  settings_path = var.settings_path

  depends_on = [google_storage_bucket_object.docker_compose]
}

resource "google_storage_bucket_object" "docker_compose" {
 count = var.enabled ? 1 : 0
 name         = "vrising/docker-compose.yml"
 content      = templatefile("${path.module}/docker/docker-compose.yml", {
   server_name     = var.server_name
 })
 content_type = "text/plain"
 bucket       = var.bucket_name
}
