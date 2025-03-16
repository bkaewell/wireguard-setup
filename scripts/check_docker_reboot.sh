#!/bin/bash

echo "Checking if Docker started at boot..."
sudo systemctl is-active --quiet docker && echo "✅ Docker is running" || echo "❌ Docker is NOT running"

echo -e "\nChecking if wg-easy restarted..."
docker ps --filter "name=wg-easy" --format "✅ wg-easy container is running: {{.Status}}" || echo "❌ wg-easy is NOT running"

echo -e "\nChecking last boot logs for Docker..."
journalctl -u docker --no-pager | grep "Started" | tail -5

