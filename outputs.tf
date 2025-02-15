
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
  description = "Ip of the satisfactory game server"
  value       = module.foundry.game_ip
}

output "foundry_startup_url" {
  description = "The URL to start the instance of satisfactory if is not running"
  value       = module.foundry.startup_url
}

output "foundry_url" {
  description = "The URL to access the satisfactory game server"
  value       = "${var.foundry_duck_dns_domain}.duckdns.org"
}
