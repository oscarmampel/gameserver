#!/bin/bash

# Container name
CONTAINER_NAME="se-ds-docker"

# Time interval to check for players (in seconds)
CHECK_INTERVAL=600  # 10 minutes
WAIT_TIME=300        # 5 minutes

# Function to count connected players
count_players() {
    # Get recent logs
    LOGS=$(sudo -n docker container logs $CONTAINER_NAME 2>/dev/null)

    # Count active connections
    local connections=$(echo "$LOGS" | grep -c "World request received")
    local disconnections=$(echo "$LOGS" | grep -c "Disconnected")

    # Net number of connected players
    echo $((connections - disconnections))
}

# Infinite loop to check every 10 minutes
while true; do
    # Wait 10 minutes for the next check
    sleep $CHECK_INTERVAL

    PLAYERS=$(count_players)

    if [ "$PLAYERS" -le 0 ]; then
        echo "$(date): No players connected."

        # Wait 5 minutes and check again
        sleep $WAIT_TIME
        PLAYERS=$(count_players)
        if [ "$PLAYERS" -le 0 ]; then
            echo "$(date): No players for 5 minutes. Shutting down the server..."
            sudo -n shutdown -h now
        fi
    else
        echo "$(date): Players connected: $PLAYERS"
    fi
done
