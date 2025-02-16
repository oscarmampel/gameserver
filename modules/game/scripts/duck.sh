DOMAIN="${duck_dns_domain}"
TOKEN="${duck_dns_token}"

if [[ -n "$DOMAIN" && -n "$TOKEN" ]]; then
  echo url="https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=" | curl -k -o /home/ubuntu/${game_name}/duck.log -K -
else
  echo "DDNS not configured. Skipping..." > /home/ubuntu/${game_name}/duck.log
fi