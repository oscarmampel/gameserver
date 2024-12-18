
output "game_ip" {
  description = "ip address of the satisfactory game server"
  value       = one(module.game[*].game_ip)
}
