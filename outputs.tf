
output "satisfactory_ip" {
  description = "Ip of the satisfactory game server"
  value       = module.satisfactory.game_ip
}

output "satisfactory_startup_url" {
  description = "The URL to start the instance of satisfactory if is not running"
  value       = module.satisfactory.startup_url
}

output "satisfactory_url" {
  description = "The URL to access the satisfactory game server"
  value       = "${var.satisfactory_duck_dns_domain}.duckdns.org"
}


output "foundry_ip" {
  description = "Ip of the foundry game server"
  value       = module.foundry.game_ip
}

output "foundry_startup_url" {
  description = "The URL to start the instance of foundry if is not running"
  value       = module.foundry.startup_url
}

output "foundry_url" {
  description = "The URL to access the foundry game server"
  value       = "${var.foundry_duck_dns_domain}.duckdns.org"
}

output "vrising_ip" {
  description = "Ip of the vrising game server"
  value       = module.vrising.game_ip
}

output "vrising_startup_url" {
  description = "The URL to start the instance of vrising if is not running"
  value       = module.vrising.startup_url
}

output "vrising_url" {
  description = "The URL to access the vrising game server"
  value       = "${var.vrising_duck_dns_domain}.duckdns.org"
}
