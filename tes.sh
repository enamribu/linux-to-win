#!/bin/bash

get_download_link() {
    local url="$1"
    local html; html=$(curl -sL "$url") || { printf "Gagal mengambil halaman.\n" >&2; return 1; }
    
    local download_link
    download_link=$(grep -oP '(?<=href=")https://download[^"]+' <<< "$html") || { printf "Gagal menemukan tautan unduhan.\n" >&2; return 1; }

    printf "%s\n" "$download_link"
}

main() {
    local mediafire_url="https://www.mediafire.com/file/r40eg52epdm6cj2/windows2019.gz/file"
    local link; link=$(get_download_link "$mediafire_url") || exit 1

    printf "Link unduhan: %s\n" "$link"
}

main
