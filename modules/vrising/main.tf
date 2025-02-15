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
  duck_dns_domain = var.duck_dns_domain
  duck_dns_token  = var.duck_dns_token
  bucket_name = var.bucket_name
  save_files_path = "/home/ubuntu/vrising/vrising-server/persistentdata"

  depends_on = [google_storage_bucket_object.docker_compose]
}

resource "google_storage_bucket_object" "docker_compose" {
 count = var.enabled ? 1 : 0
 name         = "vrising/docker-compose.yml"
 content      = template_file.vrising_compose.rendered
 content_type = "text/plain"
 bucket       = var.bucket_name
}

resource "template_file" "vrising_compose" {
  template = file("${path.module}/docker/docker-compose.yml")
  vars = {
    server_name     = var.server_name
  }
}