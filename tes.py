import requests
from bs4 import BeautifulSoup
import subprocess

# Daftar pilihan link
links = {
    "1": {
        "name": "Windows 2012",
        "url": "https://www.mediafire.com/file/h325rmxp4cpb4op/windows2012.gz/file"
    },
    "2": {
        "name": "Windows 2016",
        "url": "https://www.mediafire.com/file/cpmux8l3xqwzu5m/windows2016.gz/file"
    },
    "3": {
        "name": "Windows 2019",
        "url": "https://www.mediafire.com/file/r40eg52epdm6cj2/windows2019.gz/file"
    },
    "4": {
        "name": "Windows 2022",
        "url": "https://www.mediafire.com/file/i6xfr0if59toyba/windows2022.gz/file"
    },
    "5": {
        "name": "Windows 10",
        "url": "https://www.mediafire.com/file/0y5p92e008e3cma/windows10.gz/file"
    }
}

# Tampilkan pilihan link
print("Pilih salah satu link di bawah ini:")
for key, value in links.items():
    print(f"{key}. {value['name']}")

# Minta input dari pengguna
choice = input("Masukkan nomor pilihan Anda: ")

# Validasi pilihan
if choice not in links:
    print("Pilihan tidak valid. Silakan jalankan script kembali.")
    exit()

# Ambil link yang dipilih
selected_link = links[choice]["url"]

# Tanyakan apakah ingin menambahkan port
add_port = input("Apakah Anda ingin menambahkan port? (y/n): ").strip().lower()
port = "3389"  # Port default

if add_port == "y":
    port = input("Masukkan port yang ingin digunakan (default 3389): ").strip() or port

# Fungsi untuk mengambil link download dari halaman MediaFire
def get_download_link(url):
    try:
        # Header untuk mensimulasikan request dari browser
        headers = {
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"
        }

        # Kirim request ke halaman MediaFire dengan header
        response = requests.get(url, headers=headers)
        response.raise_for_status()  # Cek apakah request berhasil

        # Parse HTML menggunakan BeautifulSoup
        soup = BeautifulSoup(response.text, 'html.parser')

        # Cari elemen tombol download (sesuaikan dengan struktur halaman MediaFire)
        # Di MediaFire, link download biasanya ada di elemen dengan class 'input' atau 'downloadButton'
        download_button = soup.find('a', {'class': 'input'}) or soup.find('a', {'id': 'downloadButton'})
        if download_button and 'href' in download_button.attrs:
            return download_button['href']
        else:
            raise ValueError("Tombol download tidak ditemukan atau tidak memiliki link.")
    except Exception as e:
        print(f"Gagal mengambil link download: {e}")
        return None

# Ambil link download
download_link = get_download_link(selected_link)
if not download_link:
    print("Tidak dapat melanjutkan karena link download tidak ditemukan.")
    exit()

# Tampilkan hasil salinan link di terminal
print("Link download yang disalin:", download_link)

# Eksekusi perintah curl
curl_command = f"curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh dd --img {download_link} --rdp-port {port}"
print("Menjalankan perintah:", curl_command)

# Jalankan perintah curl menggunakan subprocess
try:
    subprocess.run(curl_command, shell=True, check=True)
except subprocess.CalledProcessError as e:
    print(f"Gagal menjalankan perintah curl: {e}")
