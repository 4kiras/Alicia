#!/bin/bash

echo "#   ▄▄▄       ██▓     ██▓ ▄████▄   ██▓ ▄▄▄      "
echo "#  ▒████▄    ▓██▒    ▓██▒▒██▀ ▀█  ▓██▒▒████▄    "
echo "#  ▒██  ▀█▄  ▒██░    ▒██▒▒▓█    ▄ ▒██▒▒██  ▀█▄  "
echo "#  ░██▄▄▄▄██ ▒██░    ░██░▒▓▓▄ ▄██▒░██░░██▄▄▄▄██ "
echo "#   ▓█   ▓██▒░██████▒░██░▒ ▓███▀ ░░██░ ▓█   ▓██▒"
echo "#   ▒▒   ▓▒█░░ ▒░▓  ░░▓  ░ ░▒ ▒  ░░▓   ▒▒   ▓▒█░"
echo "#    ▒   ▒▒ ░░ ░ ▒  ░ ▒ ░  ░  ▒    ▒ ░  ▒   ▒▒ ░"
echo "#    ░   ▒     ░ ░    ▒ ░░         ▒ ░  ░   ▒   "
echo "#        ░  ░    ░  ░ ░  ░ ░       ░        ░  ░"
echo "#                        ░                      "

# Explicación y confirmación
echo "Este script realizará las siguientes acciones:"
echo "1. Actualización del sistema"
echo "2. Instalación de Tor y Tor Browser Launcher"
echo "3. Instalación de TorGhost"
echo "4. Instalación de OnionSearch"
echo "5. Búsqueda en la red Tor con OnionSearch"
read -p "Presiona Enter para continuar..."

# Actualización
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y

# Instalación de Tor y Tor Browser Launcher
sudo apt install -y tor torbrowser-launcher

# Iniciar Tor Browser
torbrowser-launcher

# Esperar 5 minutos
echo "Esperando 5 minutos..."
sleep 300

# Función de construcción de TorGhost
build_torghost() {
    echo "Torghost installer v3.0"
    echo "Installing prerequisites "
    sudo apt-get install tor python3-pip -y 
    echo "Installing dependencies "
    sudo pip3 install -r requirements.txt 
    mkdir build
    cd build
    cython3 ../torghost.py --embed -o torghost.c --verbose
    if [ $? -eq 0 ]; then
        echo "[SUCCESS] Generated C code"
    else
        echo "[ERROR] Build failed. Unable to generate C code using cython3"
        exit 1
    fi
    gcc -Os -I /usr/include/python3.11 -o torghost torghost.c -lpython3.11 -lpthread -lm -lutil -ldl
    if [ $? -eq 0 ]; then
        echo "[SUCCESS] Compiled to static binary" 
    else
        echo "[ERROR] Build failed"
        exit 1
    fi
    sudo cp -r torghost /usr/bin/
    if [ $? -eq 0 ]; then
        echo "[SUCCESS] Copied binary to /usr/bin" 
    else
        echo "[ERROR] Unable to copy"
        exit 1
    fi
}

# Función principal de TorGhost
main_torghost() {
    python3 torghost.py
}

# Ejecutar construcción de TorGhost
build_torghost

# Ejecutar TorGhost
main_torghost

# Iniciar TorGhost
torghost -s

# Esperar 5 minutos
echo "Esperando 5 minutos..."
sleep 300

# Instalación de OnionSearch
pip3 install onionsearch

# Preguntar qué buscar
read -p "Ingresa lo que deseas buscar (separado por comas y con comillas, ej. "ecuador","drogas","armas"): " busqueda

# Ejecutar OnionSearch con los términos de búsqueda proporcionados
./onionsearch $busqueda