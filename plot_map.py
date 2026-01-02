#!/usr/bin/env python3
# 🔥 Daesh Insta Map Plotter - Created by Taym Allah 🔥
# 📍 Interactive heatmap of all tracked locations

import folium
import webbrowser
import os
from folium import plugins

print("🔥 Daesh Insta - Plotting tracking heatmap...")

# Create base map (centered on world)
m = folium.Map(location=[20, 0], zoom_start=2, tiles="OpenStreetMap")

# Load tracked locations
locations = []
if os.path.exists('ip_locations.txt'):
    with open('ip_locations.txt', 'r') as f:
        for line in f:
            parts = line.strip().split('|')
            if len(parts) >= 4:
                ip, city, country, lat, lon = parts[0], parts[1], parts[2], parts[3], parts[4]
                locations.append((float(lat), float(lon), f"{ip}\n{city}, {country}"))
else:
    print("ℹ️  No locations.txt found. Creating demo markers...")
    locations = [(25.2048, 55.2708, "Demo: Dubai"), (40.7128, -74.0060, "Demo: NYC")]

# Add markers
for lat, lon, popup in locations:
    folium.Marker(
        [lat, lon],
        popup=folium.Popup(popup, max_width=300),
        tooltip="Click for details",
        icon=folium.Icon(color="red", icon="cloud")
    ).add_to(m)

# Add heatmap layer
if len(locations) > 1:
    heat_data = [[lat, lon] for lat, lon, _ in locations]
    plugins.HeatMap(heat_data).add_to(m)

# Save and open
m.save('daesh_insta_map.html')
print("✅ Map saved: daesh_insta_map.html")
print("🌐 Opening in browser...")
webbrowser.open('file://' + os.path.realpath('daesh_insta_map.html'))
