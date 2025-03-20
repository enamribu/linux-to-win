from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
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

# Inisialisasi WebDriver (misalnya, menggunakan Chrome)
driver = webdriver.Chrome()

try:
    # Buka halaman MediaFire dari link yang dipilih
    driver.get(selected_link)
    
    # Tunggu hingga elemen tombol download muncul menggunakan WebDriverWait
    download_button = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.XPATH, '//*[@id="downloadButton"]'))
    )
    
    # Ambil nilai atribut 'href' dari elemen tersebut
    download_link = download_button.get_attribute("href")
    
    # Tampilkan hasil salinan link di terminal
    print("Link download yang disalin:", download_link)

    # Eksekusi perintah curl
    curl_command = f"curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh dd --img {download_link} --rdp-port {port}"
    print("Menjalankan perintah:", curl_command)
    
    # Jalankan perintah curl menggunakan subprocess
    subprocess.run(curl_command, shell=True, check=True)

finally:
    # Jangan tutup browser, biarkan tetap terbuka
    print("Script selesai dijalankan. Browser tetap terbuka.")
