# MasterMind

Progetto Flutter MasterMind

## Progetto

Il progetto è suddivisio nelle varie classi, una per la Logica del gioco e una per ciascuna pagina
La classe del gioco è suddivisa inoltre in altre classi per: la matrice centrale (`Board`), la riga laterale per selezionare i colori (`SideBar`), i pulsanti (`TryButton`) e i container colorati (`ColoredContainer`)

Nella classe `Home` sono presenti le rotte per la schermata di `Settings`, `Tutorial` e `Gioco`

## Problemi

Per il popup di errore per indicare che l'utente non aveva inserito tutti i colori nella riga avevo pensato ad un `AlertDialog`, il problema consisteva nella barriera che si creava che fa perdere un click, che è molto fastidioso e l'altro problema è che quando imposto che scompaia dopo 2 secondi, ma l'utente preme prima esso scompare la schermata di gioco si chiude, perché viene eseguita la funzione `Navigator.pop(context)` in cui chiude il widget più sopra che chiuso il popup è la schermata di gioco, per rimediare a ciò ho creato un semplice container che viene reso visibile quando necessario

Quando l'utente esce dalla schermata di gioco la sua partita rimane salvata, ma se cambia le impostazioni come quante righe, colori o colonne ci sono il gioco viene resettato, viene inoltre resettato il gioco se in precedenza poteva contenere duplicati nella sequenza del computer.

### Edge cases

Quando il giocatore non inserisce una sequenza completa, ma preme il pulsante per provare la sequenza, compare una schermata in alto che ricorda all'utente di inserire tutti i colori, tuttavia questa schermata viene rimossa dopo 2 secondi con la funzione che permette di aggiornare lo stato `setState`, ma se l'utente esce dalla schermata di gioco nel momento in cui il popup è visibile, dopo poco viene chiamata la funzione `setState` su una schermata non presente, risultando quindi in un errore. Per ovviare a ciò ho messo la funzione dentro un try-catch.

## Features

Nel gioco è possibile selezionare un colore anche prendendolo dai colori precedentemente selezionati

## Possibili aggiunte

Poteva essere stato implementato anche il punteggio e anche un timer che veniva salvato nella memoria locale grazie alla libreria `SharedPreferences`, tuttavia la funzione che utilizzava la libreria doveva essere `async`, ma impossibile da raggiungere ciò in quanto non può essere async la funzione perché la classe era estesa da un altra.