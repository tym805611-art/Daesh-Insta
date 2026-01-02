#!/bin/bash
# 🔥 Daesh Insta Geolocator - Created by Taym Allah 🔥
# 📍 Precise IP to Google Maps coordinates

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${RED}Usage: $0 IP_ADDRESS${NC}"
    echo -e "${YELLOW}Example: $0 8.8.8.8${NC}"
    exit 1
fi

IP="$1"
echo -e "${YELLOW}[📍] Geolocating $IP...${NC}"

# Multiple GeoIP APIs for accuracy
apis=(
    "http://ip-api.com/json/$IP?fields=status,message,country,regionName,city,lat,lon,isp"
    "http://ipinfo.io/$IP/json"
    "https://ipapi.co/$IP/json/"
)

for api in "${apis[@]}"; do
    geo=$(curl -s --max-time 5 "$api" 2>/dev/null)
    status=$(echo "$geo" | jq -r '.status // .success // empty' 2>/dev/null)
    
    if [[ "$status" == "success" || "$status" == "true" ]]; then
        lat=$(echo "$geo" | jq -r '.lat // .latitude // empty')
        lon=$(echo "$geo" | jq -r '.lon // .longitude // .lon // empty')
        
        if [[ -n "$lat" && -n "$lon" ]]; then
            city=$(echo "$geo" | jq -r '.city // .city // "Unknown"' 2>/dev/null)
            country=$(echo "$geo" | jq -r '.country // .country_name // "Unknown"' 2>/dev/null)
            
            echo -e "${GREEN}🎯 Daesh Insta LOCATION LOCKED!${NC}"
            echo -e "🏙️  $city, $country"
            echo -e "📍 $lat, $lon"
            echo -e "${BLUE}🗺️  https://maps.google.com/maps?q=$lat,$lon${NC}"
            echo "$IP|$city|$country|$lat|$lon" >> ip_locations.txt
            exit 0
        fi
    fi
done

echo -e "${RED}❌ Location not found${NC}"
