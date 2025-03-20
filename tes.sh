#!/bin/bash

get_download_link() {
    local url="$1"
    local user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"
    
    local html
    html=$(curl -sL -A "$user_agent" "$url") || { printf "Gagal mengambil halaman.\n" >&2; return 1; }

    local download_link
    download_link=$(grep -oP '(?<=href=")https://download[^"]+' <<< "$html") || { printf "Gagal menemukan tautan unduhan.\n" >&2; return 1; }

    printf "%s\n" "$download_link"
}

main() {
    local mediafire_url="https://www.mediafire.com/file/r40eg52epdm6cj2/windows2019.gz/file"
    local link
    link=$(get_download_link "$mediafire_url") || exit 1

    printf "Link unduhan: %s\n" "$link"
}

main
