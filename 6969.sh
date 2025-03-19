#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Silakan jalankan script ini sebagai root."
  exit 1
fi

# Link download file Windows image
DOWNLOAD_LINK="https://download1654.mediafire.com/54dsryaxmfmgC9HdPW3NzK4XXgAiUUrOi6mYsWWq9ABoF8gr7HfsB1klnU_e6DSVdP3oVZ5ZzH0BfLOvzMwC7wxndx25ccfVvw6DaJl9Tb60JAXzjE16y6Nbnk8E2y69WAFtNn9wqLfexlT4k2Xobd6fMiU4-fAqIrre60qLN_UM3w/4phq67s1vovjnn1/windows2019.gz"  # Ganti dengan link download Anda

# Lokasi sementara untuk menyimpan file image
TEMP_IMAGE="/tmp/windows_image.gz"

# Temukan disk utama secara otomatis
TARGET_DISK=$(lsblk -dn -o NAME | head -n 1)
if [ -z "$TARGET_DISK" ]; then
  echo "Tidak dapat menemukan disk utama."
  exit 1
fi
TARGET_DISK="/dev/$TARGET_DISK"

# Beri peringatan bahwa semua data akan dihapus
echo "PERINGATAN: Semua data pada disk $TARGET_DISK akan dihapus!"
read -p "Apakah Anda yakin ingin melanjutkan? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
  echo "Proses dibatalkan."
  exit 1
fi

# Mulai proses
echo "Menggantikan OS Ubuntu dengan Windows..."

# Download file image Windows
echo "Mendownload image Windows dari $DOWNLOAD_LINK..."
if ! wget -O "$TEMP_IMAGE" "$DOWNLOAD_LINK"; then
  echo "Gagal mendownload file image."
  exit 1
fi

# Unmount semua partisi yang terpasang pada disk target
echo "Unmounting partisi..."
umount ${TARGET_DISK}* 2>/dev/null

# Tulis image ke disk target
echo "Menulis image Windows ke disk..."
if ! gunzip -c "$TEMP_IMAGE" | dd of="$TARGET_DISK" bs=4M status=progress; then
  echo "Gagal menulis image ke disk."
  exit 1
fi

# Install Bootloader Windows (jika diperlukan)
echo "Menginstal bootloader Windows..."
if command -v ms-sys >/dev/null 2>&1; then
  if ! ms-sys --mbr "$TARGET_DISK"; then
    echo "Gagal menginstal bootloader Windows."
  fi
else
  echo "ms-sys tidak ditemukan. Bootloader Windows mungkin perlu diinstal secara manual."
fi

# Bersihkan file sementara
echo "Membersihkan file sementara..."
rm -f "$TEMP_IMAGE"

# Selesai
echo "Proses selesai. Silakan reboot VPS Anda."
echo "Perintah reboot: sudo reboot"
