# 1. IDE utilitzat i configuració bàsica

Per a aquesta fase del projecte s’ha utilitzat Visual Studio Code com a entorn de desenvolupament principal. S’ha escollit perquè és un editor lleuger, còmode i adequat per treballar amb Lua i amb l’estructura de fitxers del projecte.

El motor utilitzat és LÖVE2D, ja que permet desenvolupar un prototip 2D de manera senzilla i directa. La configuració inicial del projecte s’ha basat en un arxiu `main.lua` com a punt d’entrada i un arxiu `conf.lua` per definir la finestra del joc i els seus paràmetres bàsics.

En aquesta fase també s’ha organitzat una estructura inicial de carpetes per separar els fitxers principals del joc, les entitats i els recursos.

# 2. Decisions inicials d’implementació

Per començar el prototip s’ha decidit implementar primer una base funcional mínima abans d’afegir més complexitat. La prioritat inicial ha estat aconseguir que el joc arranqui correctament, que existeixi un bucle de joc funcional i que hi hagi una primera interacció amb l’usuari.

També s’ha decidit treballar amb formes simples i lògica bàsica abans d’afegir recursos visuals més elaborats. Això permet validar la jugabilitat principal del tower defense sense dependre d’elements gràfics finals.

La primera versió del prototip se centrarà en tres elements bàsics: un camí simple, almenys un enemic en moviment i la possibilitat de construir una defensa en un punt determinat del mapa.

# 3. Primeres interaccions implementades

En aquesta part del prototip s’ha incorporat una primera interacció funcional amb l’usuari. El joc mostra un camí simple i diversos punts de construcció repartits pel mapa. Quan l’usuari fa clic sobre un punt disponible, es construeix una defensa bàsica en aquella posició.

Aquesta implementació permet validar que el joc ja no només arrenca, sinó que també admet una acció directa del jugador dins del bucle de joc. Encara es tracta d’una versió molt inicial, però ja representa una base funcional coherent amb el model previst.