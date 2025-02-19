variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "server_name" {
  type = string
}

variable "settings_path" {
  type = string
}