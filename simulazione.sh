#!/bin/bash

echo "Simulazione del Gioco dei Dadi"

file_base10="Base10.txt"

# Funzione per generare casualmente un numero tra 1 e 6
genera_numero_casuale() {
    echo $((RANDOM % 6 + 1))
}

# Funzione per scrivere nel file dadoBinario.txt
scrivi_su_file_binario() {
    echo "$1" >> dadoBinario.txt
}

# Funzione per scrivere nel file dadoInChiaro.txt
scrivi_su_file_chiaro() {
    echo "$1" >> dadoInChiaro.txt
}

# Rimuovi dadoBinario.txt e dadoInChiaro.txt se esistono e ricreali
if [ -e dadoBinario.txt ]; then
    rm dadoBinario.txt
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
    echo -e "\nRound $round (Simulazione)"

    codice_binario=""
    cifre_chiaro=""

    # Lancio di 4 dadi
    for ((i = 0; i < 4; i++)); do
        risultato=$((RANDOM % 6 + 1))
        codice_binario="${codice_binario}$((risultato % 2))"
        cifre_chiaro="${cifre_chiaro}${risultato}"
    done

    # Lancio di 4 dadi
    for ((i = 0; i < 4; i++)); do
        risultato=$((RANDOM % 6 + 1))
        codice_binario="${codice_binario}$((risultato % 2))"
        cifre_chiaro="${cifre_chiaro}${risultato}"
    done

    # Lancio di 3 dadi
    for ((i = 0; i < 3; i++)); do
        risultato=$((RANDOM % 6 + 1))
        codice_binario="${codice_binario}$((risultato % 2))"
        cifre_chiaro="${cifre_chiaro}${risultato}"
    done
    
    echo "dadi in chiaro $cifre_chiaro"
    echo "dadi in binario $codice_binario"
    
    scrivi_su_file_binario "$codice_binario"
    scrivi_su_file_chiaro "$cifre_chiaro"

    
done

# Aggiungi l'ultimo round con un solo tiro di 3 dadi (simulazione)
echo -e "\nRound 24 (Simulazione)"
codice_binario=""
cifre_chiaro=""

# Lancio di 3 dadi
for ((i = 0; i < 3; i++)); do
    risultato=$((RANDOM % 6 + 1))
    codice_binario="${codice_binario}$((risultato % 2))"
    cifre_chiaro="${cifre_chiaro}${risultato}"
done

echo "dadi in chiaro $cifre_chiaro"
echo "dadi in binario $codice_binario"
scrivi_su_file_binario "$codice_binario"
scrivi_su_file_chiaro "$cifre_chiaro"

# Verifica se il file ha 24 righe e che ogni riga ha 11 elementi binari
# File di destinazione
file_di_destinazione="dadoBinario.txt"

# Verifica se il file esiste
if [ ! -f "$file_di_destinazione" ]; then
    echo "Errore: Il file $file_di_destinazione non esiste."
    exit 1
fi


# Concatena tutti i binari senza spazi
binariNoSpazio=$(tr -d '[:space:]' < "$file_di_destinazione")
# # Calcola il checksum SHA-256
checksum=$(echo -n "$binariNoSpazio" | shasum -a 256 -0 | head -c 2)
BASE2=$(echo "ibase=16; obase=2; $(echo $checksum | tr '[:lower:]' '[:upper:]') " | bc  | sed 's/\\//g' | tr -d '\n'| awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}')

# Aggiungi l'esadecimale in fondo
sed -i -e "\$s/$/$BASE2/" "$file_di_destinazione"

# # Controlla il numero di righe nel file
numero_di_righe=$(wc -l < "$file_di_destinazione")

cat $file_di_destinazione

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
