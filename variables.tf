variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "duck_dns_token" {
  type = string
}

variable "satisfactory_duck_dns_domain" {
  type = string
}

variable "satisfactory_enabled" {
  type    = bool
  default = false
}

variable "foundry_duck_dns_domain" {
  type = string
}

variable "foundry_enabled" {
  type    = bool
  default = false
}

variable "foundry_server_password" {
  type = string
}

variable "foundry_server_name" {
  type = string
}

variable "vrising_enabled" {
  type    = bool
  default = false
}

variable "vrising_server_name" {
  type = string
}

variable "spaceengineers_duck_dns_domain" {
  type = string
}

variable "spaceengineers_enabled" {
  type    = bool
  default = false
}

variable "spaceengineers_server_name" {
  type = string
}

variable "moria_duck_dns_domain" {
  type = string
}

variable "moria_enabled" {
  type    = bool
  default = false
}
