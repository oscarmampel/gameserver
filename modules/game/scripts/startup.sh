sudo apt-get update
sudo apt-get install -yq build-essential curl

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
groupadd docker
usermod -aG docker ubuntu
newgrp docker

mkdir -p /home/ubuntu/${game_name}
mkdir -p ${save_files_path}

gsutil cp -r gs://${bucket_name}/${game_name} /home/ubuntu/
gsutil cp -r gs://${bucket_name}/save_files/${game_name} ${save_files_path} 

chmod 700 /home/ubuntu/${game_name}/backups.sh
chmod 700 /home/ubuntu/${game_name}/duck.sh
sh /home/ubuntu/${game_name}/duck.sh

crontab /home/ubuntu/${game_name}/jobs.cron

docker compose -f /home/ubuntu/${game_name}/docker-compose.yml up -d

chmod +x /home/ubuntu/${game_name}/auto-shutdown.sh
chown ubuntu:ubuntu /home/ubuntu/${game_name}/auto-shutdown.sh

mv /home/ubuntu/${game_name}/auto-shutdown.service /etc/systemd/system/auto-shutdown.service
systemctl enable auto-shutdown
systemctl start auto-shutdown
