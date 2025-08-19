#!/bin/bash

# Simple SpaceFn Restart Script
# Just click to restart SpaceFn service and check status

echo "🔄 Restarting SpaceFn Auto..."
sudo systemctl restart spacefn-auto

sleep 2

echo "📊 Checking status..."
sudo ./spacefn-auto.sh status

echo ""
echo "✅ Done! SpaceFn should now be running on all connected keyboards."
echo "💡 Test: Hold Space + H/J/K/L for arrow keys"
