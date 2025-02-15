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
}

variable "shutdown_protocol_on_no_players" {
  type    = string
}

variable "duck_dns_domain" {
  type    = string
}

variable "duck_dns_token" {
  type    = string
}

variable "bucket_name" {
  type    = string
}

variable "save_files_path" {
  type    = string
}