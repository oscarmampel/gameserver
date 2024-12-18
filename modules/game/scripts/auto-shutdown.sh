#!/bin/sh

shutdownIdleMinutes=10
idleCheckFrequencySeconds=1

isIdle=0
while [ $isIdle -le 0 ]; do
	isIdle=1
	iterations=$((60 / $idleCheckFrequencySeconds * $shutdownIdleMinutes))
    while [ $iterations -gt 0 ]; do
        sleep $idleCheckFrequencySeconds
        connectionBytes=$(docker compose -f /home/ubuntu/${game_name}/docker-compose.yml exec ${game_name} ss -l | grep ${shutdown_port_on_no_players} | awk -F ' ' '{s+=$3} END {print s}')
        if [ ! -z $connectionBytes ] && [ $connectionBytes -gt 0 ]; then
            isIdle=0
        fi
        if [ $isIdle -le 0 ] && [ $(($iterations % 21)) -eq 0 ]; then
           echo "Activity detected, resetting shutdown timer to $shutdownIdleMinutes minutes."
           break
        fi
        iterations=$(($iterations-1))
    done
done

echo "No activity detected for $shutdownIdleMinutes minutes, shutting down."
sudo shutdown -h now