#!/bin/bash

# Abilita la modalità "non-stop" in caso di errore
set -e

# Funzione per installare i pacchetti ufficiali
install_official_packages() {
    echo "--- Installazione dei pacchetti ufficiali da pacchetti_espliciti.txt ---"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm $(cat pacchetti_espliciti.txt)
}

# Funzione per installare yay, se non è già installato
install_yay() {
    if ! command -v yay &> /dev/null
    then
        echo "--- yay non trovato. Installazione in corso... ---"
        sudo pacman -S --noconfirm --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    else
        echo "--- yay è già installato. Procedo. ---"
    fi
}

# Funzione per installare i pacchetti da AUR
install_aur_packages() {
    echo "--- Installazione dei pacchetti da AUR da pacchetti_aur.txt ---"
    
    # Estrae solo i nomi dei pacchetti dal file pacchetti_aur.txt
    aur_packages=$(awk '{print $1}' pacchetti_aur.txt)
    
    if [ -n "$aur_packages" ]; then
        yay -S --needed --noconfirm $aur_packages
    else
        echo "--- Nessun pacchetto AUR trovato nel file. Salto l'installazione. ---"
    fi
}

# Esecuzione delle funzioni in sequenza
install_official_packages
install_yay
install_aur_packages

echo "--- Script di installazione completato! ---"