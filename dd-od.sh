#!/bin/bash

# Pastikan script dijalankan dengan hak akses root
if [ "$(id -u)" -ne 0 ]; then
  echo "Script ini harus dijalankan dengan hak akses root!"
  exit 1
fi

# Tentukan lokasi file .gz yang berisi image Windows (IMG)
GZ_FILE="/root/windows.gz"
# Tentukan lokasi disk tujuan (misalnya USB /dev/sdX)
TARGET_DISK="/dev/vda"

# Mengecek apakah file .gz ada
if [ ! -f "$GZ_FILE" ]; then
  echo "File $GZ_FILE tidak ditemukan!"
  exit 1
fi

# Mengecek apakah disk target sudah benar
if [ ! -b "$TARGET_DISK" ]; then
  echo "Disk tujuan $TARGET_DISK tidak ditemukan!"
  exit 1
fi

# Membuat direktori untuk ekstraksi sementara
EXTRACT_DIR="/tmp/windows_extract"
mkdir -p $EXTRACT_DIR

# Mengekstrak file .gz untuk mendapatkan file .img
echo "Mengekstrak file $GZ_FILE menjadi file .img..."
tar -xzvf "$GZ_FILE" -C "$EXTRACT_DIR"

# Mencari file .img setelah ekstraksi
IMG_FILE=$(find "$EXTRACT_DIR" -name "*.img" -type f)

if [ -z "$IMG_FILE" ]; then
  echo "Tidak ada file .img ditemukan setelah ekstraksi!"
  exit 1
fi

echo "File .img ditemukan: $IMG_FILE"

# Memberi peringatan agar disk target tidak memiliki data penting
echo "Peringatan: Semua data di $TARGET_DISK akan terhapus. Pastikan Anda sudah melakukan backup!"

# Menulis file .img ke disk tujuan
echo "Menulis file .img ke disk $TARGET_DISK..."
dd if="$IMG_FILE" of="$TARGET_DISK" bs=4M status=progress

# Menunggu proses selesai
sync

echo "Proses selesai. Sistem Windows sekarang telah dipasang ke disk $TARGET_DISK."
echo "Silakan reboot dan boot dari disk untuk mengakses Windows."

# Menampilkan petunjuk untuk reboot dan install
echo "Reboot dan pastikan untuk booting dari disk tersebut untuk melanjutkan proses instalasi Windows."
