sudo apt-get update
sudo apt-get install -yq build-essential curl

echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
groupadd docker
usermod -aG docker ubuntu
newgrp docker

echo "Creating working directories..."
mkdir -p /home/ubuntu/${game_name}
mkdir -p ${save_files_path}

echo "Downloading scripts..."
gsutil cp -r gs://${bucket_name}/${game_name} /home/ubuntu/

echo "Restoring Server Settings..."
tar -xzf "/home/ubuntu/${game_name}/server_settings.tar.gz" -C "/home/ubuntu/${game_name}"

echo "Restoring backup..."
BACKUP_GP_PATH=$(gsutil ls -l gs://${bucket_name}/save_files/${game_name}/* | head -n -1 | sort -k 2 | tail -n 1 | awk '{print $3}')
gsutil cp -r $BACKUP_GP_PATH /home/ubuntu/${game_name}
echo "Downloaded Backup: $BACKUP_GP_PATH"
tar -xzf "/home/ubuntu/${game_name}/$(basename $BACKUP_GP_PATH)" -C "${save_files_path}"

echo "Setting up scripts..."
chmod 700 /home/ubuntu/${game_name}/backups.sh

chmod 700 /home/ubuntu/${game_name}/duck.sh
sh /home/ubuntu/${game_name}/duck.sh

crontab /home/ubuntu/${game_name}/jobs.cron

docker compose -f /home/ubuntu/${game_name}/docker-compose.yml up -d

chmod +x /home/ubuntu/${game_name}/auto-shutdown.sh
chown ubuntu:ubuntu /home/ubuntu/${game_name}/auto-shutdown.sh


echo "Setting up auto-shutdown service..."
groupadd pcap
usermod -aG pcap ubuntu
chgrp pcap /usr/bin/tcpdump
chmod 750 /usr/bin/tcpdump
setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump

mv /home/ubuntu/${game_name}/auto-shutdown.service /etc/systemd/system/auto-shutdown.service
systemctl enable auto-shutdown
systemctl start auto-shutdown
