#!/bin/bash

echo "Benvenuto"

# Inizializza la variabile per il file di destinazione
file_di_destinazione="dadoBinario.txt"

# Funzione per scrivere nel file dadoBinario.txt
scrivi_su_file_binario() {
    echo "$1" >> "$file_di_destinazione"
}

# Funzione per scrivere nel file dadoInChiaro.txt
scrivi_su_file_chiaro() {
    echo "$1" >> dadoInChiaro.txt
}

# Rimuovi dadoBinario.txt e dadoInChiaro.txt se esistono e ricreali
if [ -e "$file_di_destinazione" ]; then
    rm "$file_di_destinazione"
fi

if [ -e dadoInChiaro.txt ]; then
    rm dadoInChiaro.txt
fi

if [ -e > seed.txt ]; then
    rm seed.txt
fi

if [ -e > debug.txt ]; then
    rm debug.txt
fi

for round in {1..23}; do
    echo "Round $round"

    codice_binario=""
    cifre_chiaro=""

    # Lancio di 4 dadi
    while true; do
        read -p "Lancia 4 dadi. Inserisci le 4 cifre che sono apparse (1-6, senza spazi): " input

        if [[ $input =~ ^[1-6]{4}$ ]]; then
            for ((i = 0; i < 4; i++)); do
                codice_binario="${codice_binario}$(((${input:i:1} % 2)))"
                cifre_chiaro="${cifre_chiaro}${input:i:1}"
            done
            break
        else
            echo "Input non valido. Riprova."
        fi
    done

    # Lancio di 4 dadi
    while true; do
        read -p "Lancia 4 dadi. Inserisci le 4 cifre che sono apparse (1-6, senza spazi): " input

        if [[ $input =~ ^[1-6]{4}$ ]]; then
            for ((i = 0; i < 4; i++)); do
                codice_binario="${codice_binario}$(((${input:i:1} % 2)))"
                cifre_chiaro="${cifre_chiaro}${input:i:1}"
            done
            break
        else
            echo "Input non valido. Riprova."
        fi
    done

    # Lancio di 3 dadi
    while true; do
        read -p "Lancia 3 dadi. Inserisci le 3 cifre che sono apparse (1-6, senza spazi): " input

        if [[ $input =~ ^[1-6]{3}$ ]]; then
            for ((i = 0; i < 3; i++)); do
                codice_binario="${codice_binario}$(((${input:i:1} % 2)))"
                cifre_chiaro="${cifre_chiaro}${input:i:1}"
            done
            break
        else
            echo "Input non valido. Riprova."
        fi
    done

    scrivi_su_file_binario "$codice_binario"
    scrivi_su_file_chiaro "$cifre_chiaro"
done

# Aggiungi l'ultimo round con un solo tiro di 3 dadi
echo "Round 24"
codice_binario=""
cifre_chiaro=""

while true; do
    read -p "Lancia 3 dadi. Inserisci le 3 cifre che sono apparse (1-6, senza spazi): " input

    if [[ $input =~ ^[1-6]{3}$ ]]; then
        for ((i = 0; i < 3; i++)); do
            codice_binario="${codice_binario}$(((${input:i:1} % 2)))"
            cifre_chiaro="${cifre_chiaro}${input:i:1}"
        done
        break
    else
        echo "Input non valido. Riprova."
    fi
done
scrivi_su_file_binario "$codice_binario"
scrivi_su_file_chiaro "$cifre_chiaro"

# Concatena tutti i binari senza spazi
binariNoSpazio=$(cat "$file_di_destinazione" | tr -d ' ' | tr -d '[:space:]')

# Calcola il checksum SHA-256
checksum=$(echo -n "$binariNoSpazio" | shasum -a 256 -0 | head -c 2)
BASE2=$(echo "ibase=16; obase=2; $(echo $checksum | tr '[:lower:]' '[:upper:]') " | bc  | sed 's/\\//g' | tr -d '\n'| awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}')
#echo "$BASE2" >> "$file_di_destinazione"

# Aggiungi l'esadecimale in fondo
sed -i -e "\$s/$/$BASE2/" "$file_di_destinazione"

# Verifica se il file esiste
if [ ! -f "$file_di_destinazione" ]; then
    echo "Errore: Il file $file_di_destinazione non esiste."
    exit 1
fi

# Verifica se il file ha 24 righe e che ogni riga ha 11 elementi binari
# Controlla il numero di righe nel file
numero_di_righe=$(wc -l < "$file_di_destinazione")

if [ "$numero_di_righe" -ne 24 ]; then
    echo "Errore: Il file $file_di_destinazione deve contenere esattamente 24 righe."
    exit 1
fi

# Controlla la lunghezza di ogni riga
while IFS= read -r riga; do
    lunghezza_riga=${#riga}
    if [ "$lunghezza_riga" -ne 11 ] || [[ ! "$riga" =~ ^[01]+$ ]]; then
        echo "Errore: Ogni riga nel file $file_di_destinazione deve contenere esattamente 11 caratteri binari (0 e 1)."
        exit 1
    fi
done < "$file_di_destinazione"

# Controlla la lunghezza di ogni riga
while IFS= read -r riga; do
    lunghezza_riga=${#riga}
    if [ "$lunghezza_riga" -ne 11 ]; then
        echo "Errore: Ogni riga nel file $file_di_destinazione deve contenere esattamente 11 caratteri binari."
        exit 1
    fi
done < "$file_di_destinazione"

printf "\n\n \e[45m Mappo i bytes al dizionario inglese \e[0m\n\n"
last_line=$(wc -l < "$file_di_destinazione")
current_line=0

# Converti da BASE2 a BASE10 e mappa al dizionario inglese
while IFS= read -r line; do
    BASE10=$(echo "ibase=2; $line" | bc)
    BASE10FIX=$(expr $BASE10 + 1)
    WORD=$(sed ''$BASE10FIX'!d' dizionario.txt)    
    echo -n "$WORD " >> "seed.txt"
    echo "ID: $BASE10FIX – $WORD"      
    echo "ID: $BASE10FIX – $WORD" >> debug.txt

done < "$file_di_destinazione"

cat seed.txt

# Verifica se i file esistono
if [ ! -f dadoInChiaro.txt ] || [ ! -f dadoBinario.txt ] || [ ! -f debug.txt ]; then
    echo "Errore: I file necessari non esistono."
    exit 1
fi

# Crea il file recap.txt
paste -d ' ' dadoInChiaro.txt dadoBinario.txt debug.txt > recap.txt

echo -e "\n\n Il Tuo seed è stato creato."

