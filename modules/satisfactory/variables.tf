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

variable "duck_dns_domain" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "settings_path" {
  type = string
}
