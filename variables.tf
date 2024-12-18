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