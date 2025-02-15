
output "game_ip" {
  description = "ip address of the satisfactory game server"
  value       = one(module.game[*].game_ip)
}

output "startup_url" {
 description = "The URL to start the instance if is not running"
 value = one(module.game[*].startup_url)
}
