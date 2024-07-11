#!/bin/bash

# Default values
SERVICE_NAME="JMusicBot.service"
DOWNLOAD_PATH=$(pwd)
DELAY=3 # Number of seconds to wait before checking the service status

# Function to display help message
function show_help {
  echo "Usage: ./JMusicBot-Updater.sh [-v version] [-l link] [-p path] [-s service] [-h]"
  echo ""
  echo "Options:"
  echo "  -v version    Specify the version number (e.g., 1.2.3)"
  echo "  -l link       Specify the direct download link"
  echo "  -p path       Specify the directory path to save JMusicBot.jar (default is current directory)"
  echo "  -s service    Specify the systemd service name (default is JMusicBot.service)"
  echo "  -h            Show this help message"
}

# Parse command-line arguments
while getopts ":v:l:p:s:h" opt; do
  case ${opt} in
    v )
      if [ -n "$LINK" ]; then
        echo "Error: Cannot specify both -v and -l" 1>&2
        show_help
        exit 1
      fi
      VERSION=$OPTARG
      ;;
    l )
      if [ -n "$VERSION" ]; then
        echo "Error: Cannot specify both -v and -l" 1>&2
        show_help
        exit 1
      fi
      LINK=$OPTARG
      ;;
    p )
      DOWNLOAD_PATH=$OPTARG
      ;;
    s )
      SERVICE_NAME=$OPTARG
      ;;
    h )
      show_help
      exit 0
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      show_help
      exit 1
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument" 1>&2
      show_help
      exit 1
      ;;
  esac
done

# Check if at least one of -v or -l is provided
if [ -z "$VERSION" ] && [ -z "$LINK" ]; then
  echo "Error: You must specify either -v or -l" 1>&2
  show_help
  exit 1
fi

# Stop the service
echo "Stopping the $SERVICE_NAME..."
sudo systemctl stop $SERVICE_NAME

# Determine the download URL
if [ -n "$VERSION" ]; then
  URL="https://github.com/jagrosh/MusicBot/releases/download/$VERSION/JMusicBot-$VERSION.jar"
else
  URL=$LINK
fi

# Download the new version
echo "Downloading from $URL..."
wget -O /tmp/JMusicBot.jar $URL

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Download failed. Please check the URL or version number and try again."
  exit 1
fi

# Move the new file to the desired location
echo "Replacing the old JMusicBot.jar with the new version..."
sudo mv /tmp/JMusicBot.jar "$DOWNLOAD_PATH/JMusicBot.jar"

# Reload the systemd daemon and restart the service
echo "Reloading systemd daemon and restarting the $SERVICE_NAME..."
sudo systemctl daemon-reload
sudo systemctl start $SERVICE_NAME

# Wait for a few seconds before checking the status
sleep $DELAY

# Check the status of the service without pausing
echo "Checking the status of $SERVICE_NAME..."
sudo systemctl status $SERVICE_NAME --no-pager 2>/dev/null

echo "Update completed."
