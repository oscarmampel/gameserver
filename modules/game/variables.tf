variable "game_name" {
  type    = string
}

variable "boot_disk_size" {
  type    = number
  default = 15 
}

variable "instance_type" {
  type    = string
  default = "n2d-standard-2"
}

variable "tcp_ports" {
  type    = list(number)
}

variable "udp_ports" {
  type    = list(number)
}

variable "project" {
  type    = string
}

variable "region" {
  type    = string
}

variable "zone" {
  type    = string
}

variable "shutdown_port_on_no_players" {
  type    = number
  default = 0
}

variable "shutdown_protocol_on_no_players" {
  type    = string
  default = "tcp"
}

variable "duck_dns_domain" {
  type    = string
  default = ""
}

variable "duck_dns_token" {
  type    = string
  default = ""
}

variable "bucket_name" {
  type    = string
}

variable "save_files_path" {
  type    = string
}

variable "startup_url_extra_info" {
  type    = string
  default = ""
}

variable "settings_path" {
  type    = string
}

variable "shutdown_script" {
  type    = string
  default = ""
}

locals {
  default_shutdown_script = templatefile("${path.module}/scripts/auto-shutdown.sh", {
   shutdown_port_on_no_players = var.shutdown_port_on_no_players
   shutdown_protocol_on_no_players = var.shutdown_protocol_on_no_players
   game_name = var.game_name
 })
 shutdown_script = var.shutdown_script != "" ? var.shutdown_script : local.default_shutdown_script
}