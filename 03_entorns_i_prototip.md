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

# 4. Bucle de joc funcional

En aquesta fase també s’ha incorporat un sistema inicial d’enemics que apareixen automàticament i es desplacen pel camí principal. Això permet que el prototip disposi ja d’un bucle de joc bàsic i identificable: el jugador pot col·locar defenses mentre els enemics avancen de forma contínua.

Aquest pas és important perquè valida que el projecte no només té una escena inicial, sinó una dinàmica mínima de joc amb moviment, interacció i actualització constant de l’estat del sistema.

# 5. Millores del prototip funcional

Per reforçar el prototip, s’ha implementat un atac automàtic bàsic de les defenses. Cada torre detecta els enemics dins del seu rang i els aplica dany de manera automàtica. Els enemics tenen vida i desapareixen quan aquesta arriba a zero.

Aquesta millora permet validar una part essencial del funcionament del tower defense, ja que ja existeix una relació directa entre la construcció de defenses i la gestió dels enemics dins del bucle de joc.

# 6. Estat actual del prototip

En el punt actual de desenvolupament, el prototip ja és executable i funcional. El projecte arrenca correctament amb LÖVE2D, mostra una escena de joc simple i permet una interacció directa amb l’usuari mitjançant la construcció de defenses.

A més, el joc disposa d’un sistema inicial d’enemics que apareixen automàticament, es desplacen pel camí i poden ser atacats per les torres. Les defenses tenen un rang d’acció i apliquen dany de manera automàtica quan detecten enemics propers. Això permet validar el nucli principal del bucle de joc.

Tot i que encara es tracta d’un prototip inicial, aquesta fase ja demostra que l’entorn està correctament configurat, que el joc pot executar-se sense errors crítics i que existeix una base funcional sobre la qual continuar desenvolupant la resta de mecàniques previstes.

# 7. Evidències visuals

Durant aquesta fase s’han capturat diverses imatges del procés de treball. Aquestes captures mostren Visual Studio Code en funcionament, l’estructura bàsica del projecte i el prototip executant-se correctament.

Les evidències visuals també permeten veure la construcció de defenses, el moviment dels enemics i la interacció bàsica ja implementada dins del joc.

# 8. Control de versions

Durant la fase 3 s’ha fet servir Git per registrar l’evolució del prototip de manera ordenada. Els commits s’han realitzat amb missatges descriptius que reflecteixen canvis concrets en el desenvolupament del projecte.

Els principals avenços registrats han estat:
- configuració inicial del projecte i arrencada bàsica amb LÖVE2D
- implementació dels punts de construcció i la col·locació de torres
- incorporació d’enemics en moviment per establir el bucle de joc
- implementació de l’atac automàtic de les torres i la vida dels enemics

Aquesta gestió del control de versions permet deixar constància del progrés real del projecte i facilita la continuïtat del desenvolupament en fases posteriors.