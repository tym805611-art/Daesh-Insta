#!/bin/bash
# 🔥 Daesh Insta One-Click Install - Taym Allah 🔥

echo -e "\n🔥 ${GREEN}Installing Daesh Insta by Taym Allah...${NC}\n"

# Detect platform
if [[ "$OSTYPE" == "linux-android"* ]]; then
    echo "📱 Termux detected"
    pkg update -y && pkg upgrade -y
    pkg install curl php git jq python -y
    pip install requests folium geopy pyngrok
else
    echo "🖥️  Linux detected"
    sudo apt update && sudo apt install -y curl php-cli php git jq python3 python3-pip
    pip3 install requests folium geopy pyngrok
fi

# Clone if not exists
if [ ! -d "Daesh-Insta" ]; then
    git clone https://github.com/YOURUSERNAME/Daesh-Insta.git
    cd Daesh-Insta
else
    cd Daesh-Insta
    git pull
fi

chmod +x *.sh *.py

cat << EOF

🎉 ${GREEN}Daesh Insta Installed Successfully!${NC} 🎉

🚀 ${YELLOW}Quick Start:${NC}
./daesh_insta.sh @targetuser

📋 ${BLUE}Commands:${NC}
./daesh_insta.sh monitor     # Live logs
./daesh_insta.sh geo 8.8.8.8 # Geolocate
./daesh_insta.sh map         # Heatmap

👤 ${PURPLE}Created by Taym Allah${NC}
EOF
