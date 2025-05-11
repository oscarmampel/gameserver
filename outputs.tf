
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
  value       = module.satisfactory.game_url
}


output "foundry_ip" {
  description = "Ip of the foundry game server"
  value       = module.foundry.game_ip
}

output "foundry_startup_url" {
  description = "The URL to start the instance of foundry if is not running"
  value       = module.foundry.startup_url
}

output "vrising_ip" {
  description = "Ip of the vrising game server"
  value       = module.vrising.game_ip
}

output "vrising_startup_url" {
  description = "The URL to start the instance of vrising if is not running"
  value       = module.vrising.startup_url
}

output "spaceengineers_ip" {
  description = "Ip of the spaceengineers game server"
  value       = module.spaceengineers.game_ip
}

output "spaceengineers_startup_url" {
  description = "The URL to start the instance of spaceengineers if is not running"
  value       = module.spaceengineers.startup_url
}

output "spaceengineers_url" {
  description = "The URL to access the spaceengineers game server"
  value       = module.spaceengineers.game_url
}


output "moria_ip" {
  description = "Ip of the moria game server"
  value       = module.moria.game_ip
}

output "moria_startup_url" {
  description = "The URL to start the instance of moria if is not running"
  value       = module.moria.startup_url
}

output "moria_url" {
  description = "The URL to access the moria game server"
  value       = module.moria.game_url
}
