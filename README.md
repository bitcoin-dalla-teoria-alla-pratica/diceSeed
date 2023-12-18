# Generatore di Seed con Dadi

L'obiettivo di questo repository è creare un seed utilizzando dei dadi per generare entropia.

Ci sono 24 round, e in ognuno di essi si tirano rispettivamente:

- 4 dadi
- 4 dadi
- 3 dadi

Se il dado restituisce un numero pari, sarà convertito nel binario 1, altrimenti in 0.

L'ultimo round, il 24, consiste nel lanciare solo 3 dadi.

Dopo aver eseguito tutti i round, lo script creerà alcuni file, tra cui:

- `dadoInChiaro.txt`: Contiene i risultati di tutti i round.
- `dadoBinario.txt`: Contiene i risultati dei round convertiti in binario.

Lo script si occuperà poi di effettuare il checksum dei binari ottenuti, appendendo il suo valore binario in coda ai binari ottenuti precedentemente.

Infine, ogni riga (precisamente 24 righe) sarà mappata sul dizionario inglese di Bitcoin (https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt), già scaricato nel file `dizionario.txt`.

Questo script non si assume alcuna responsabilità sulla sicurezza del seed fornito, ma può essere utilizzato offline (su Tails o su un Raspberry Air-Gap) come "riprova" del procedimento eseguito manualmente.

## File Generati

- `dadoInChiaro.txt`: Contiene i risultati di tutti i round.
- `dadoBinario.txt`: Contiene i risultati dei round convertiti in binario.
- `recap.txt`: Contiene un riepilogo di quanto eseguito, concatenando le informazioni da `dadoInChiaro.txt`, `dadoBinario.txt` e `debug.txt`.

## Riferimenti

Questo script si ispira alla guida [turtlecute.org/seed](https://turtlecute.org/seed).

## Simulazione

Per eseguire tiri di prova in modo randomico, è possibile utilizzare lo script `simulazione.sh`. Questo script simula i lanci di dadi senza richiedere input utente per ogni round.

```bash
# Eseguire lo script di simulazione
./simulazione.sh
```

–––––––––


# Dice Seed Generator

The goal of this repository is to create a seed using dice to generate entropy.

There are 24 rounds, and in each of them, the following dice rolls are performed:

- 4 dice
- 4 dice
- 3 dice

If the die returns an even number, it will be converted to the binary digit 1; otherwise, it will be 0.

The last round, the 24th, involves rolling only 3 dice.

After completing all the rounds, the script will create several files, including:

- `dadoInChiaro.txt`: Contains the results of all rounds.
- `dadoBinario.txt`: Contains the results of the rounds converted to binary.

The script will then calculate the checksum of the obtained binaries, appending its binary value to the previously obtained binaries.

Finally, each line (precisely 24 lines) will be mapped to the English Bitcoin dictionary (https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt), already downloaded in the `dizionario.txt` file.

This script assumes no responsibility for the security of the provided seed but can be used offline (on Tails or on an Air-Gap Raspberry Pi) as a "retry" of the manually executed procedure.

## Generated Files

- `dadoInChiaro.txt`: Contains the results of all rounds.
- `dadoBinario.txt`: Contains the results of the rounds converted to binary.
- `recap.txt`: Contains a summary of what was executed by concatenating information from `dadoInChiaro.txt`, `dadoBinario.txt`, and `debug.txt`.

## References

This script is inspired by the guide [turtlecute.org/seed](https://turtlecute.org/seed).

## Simulation

To perform random test rolls, you can use the `simulazione.sh` script. This script simulates dice rolls without requiring user input for each round.

```bash
# Run the simulation script
./simulazione.sh
```

