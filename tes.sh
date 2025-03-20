#!/bin/bash

# URL MediaFire
url="https://www.mediafire.com/file/r40eg52epdm6cj2/windows2019.gz/file"

# User-Agent
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"

# Mengambil konten HTML dari URL
html_content=$(curl -s -A "$user_agent" "$url")

# Mengekstrak link unduhan dari HTML
download_link=$(echo "$html_content" | grep -oP 'https?://[^"]+?\.gz(?=")')

# Menampilkan link unduhan di terminal
if [ -n "$download_link" ]; then
    echo "Link unduhan: $download_link"
else
    echo "Tidak dapat menemukan link unduhan."
fi
