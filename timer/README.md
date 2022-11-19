# Progetto Timer

## Schermata iniziale

In questa schermata selezioniamo l'orario del timer

<img src="selector.png" width="300"/>

## Formato timer 1

<img src="format1.png" width="300"/>

## Formato timer 2

<img src="format2.png" width="300"/>

## Timer terminato

Una volta terminato il timer comparirà una notifica per avvertire l'utente, inoltre il timer inizia a lampeggiare nel primo formato accompagnato da una suoneria

<img src="notification.png" width="300"/>

## Temi

Presente il tema chiaro e il tema scuro

<img src="lighttheme.png" width="300"/>

<img src="darktheme.png" width="300"/>

## Logica del timer

Generiamo uno `Stream` che ad ogni secondo esegue la funzione `tick`, che essa aggiunge allo `StreamController` i secondi rimanenti


```dart
void tick(_) {
    if (counter <= 0) {
    streamController.close();
    return;
    }
    streamController.add(--counter);
}

void resume() {
    timer = Timer.periodic(const Duration(seconds: 1), tick);
}
```
