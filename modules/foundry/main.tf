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

  depends_on = [google_storage_bucket_object.docker_compose]
}

resource "google_storage_bucket_object" "docker_compose" {
 name         = "foundry/docker-compose.yml"
 content      = template_file.foundry_compose.rendered
 content_type = "text/plain"
 bucket       = var.bucket_name
}

resource "template_file" "foundry_compose" {
  template = file("${path.module}/docker/docker-compose.yml")
  vars = {
    server_password = var.server_password
    server_name     = var.server_name
    public_server   = var.public_server ? "true" : "false"
  }
}
