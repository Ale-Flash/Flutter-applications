# MasterMind

Progetto Flutter MasterMind

## Progetto

Il progetto è suddivisio nelle varie classi, una per la Logica del gioco e una per ciascuna pagina

Nella classe `Home` sono presenti le rotte per la schermata di `Settings`, `Tutorial` e `Gioco`

## Problemi

Per il popup di errore per indicare che l'utente non aveva inserito tutti i colori nella riga avevo pensato ad un `AlertDialog`, il problema consisteva nella barriera che si creava che fa perdere un click, che è molto fastidioso e l'altro problema è che quando imposto che scompaia dopo 2 secondi, ma l'utente preme prima esso scompare la schermata di gioco si chiude, perché viene eseguita la funzione `Navigator.pop(context)` in cui chiude il widget più sopra che chiuso il popup è la schermata di gioco, per rimediare a ciò ho creato un semplice container che viene reso visibile quando necessario

Quando l'utente esce dalla schermata di gioco la sua partita rimane salvata, ma se cambia le impostazioni come quante righe, colori o colonne ci sono il gioco viene resettato

Nel gioco è possibile selezionare un colore anche prendendolo dai colori precedentemente selezionati

Poteva essere stato implementato anche il punteggio e anche un timer che veniva salvato nella memoria locale grazie alla libreria `SharedPreferences`, tuttavia la funzione che utilizzava la libreria doveva essere `async`, ma impossibile da raggiungere ciò in quanto non può essere async la funzione perché la classe era estesa da un altra.