# 1. Components principals del joc

Els components principals del joc són els següents:

- **Gestor de joc (GameManager):** coordina l’estat general de la partida, els recursos, la vida de la base i la lògica de victòria o derrota.
- **Gestor d’onades (WaveManager):** controla quan comença cada onada, quants enemics s’han de generar i quan s’ha acabat una onada.
- **Defenses o torres (Tower):** estructures que el jugador col·loca al mapa i que ataquen automàticament els enemics dins del seu rang.
- **Enemics (Enemy):** unitats que segueixen el camí fins a la base i que poden ser destruïdes per les torres.
- **Base:** element que cal protegir. Si perd tota la vida, la partida acaba en derrota.
- **Mapa o camí:** estructura fixa del nivell que defineix el recorregut dels enemics i els punts on es poden construir defenses.

Aquests components responen directament a la idea definida a la fase 1: un micro tower defense 2D, en vista superior, amb poques mecàniques i abast reduït.

# 2. Entitats identificades

Les entitats o mòduls principals del sistema són:

1. **GameManager**
2. **WaveManager**
3. **Tower**
4. **Enemy**
5. **Base**

Tot i que el joc no segueix orientació a objectes estricta com en altres motors, a LÖVE2D aquestes entitats es poden representar com a taules Lua o mòduls separats amb les seves dades i funcions.

# 3. Atributs clau de cada entitat

## GameManager
- `state`: estat actual del joc (`menu`, `playing`, `victory`, `defeat`)
- `gold`: recursos disponibles del jugador
- `currentWave`: número d’onada actual
- `baseLife`: vida actual de la base
- `buildPoints`: punts vàlids on es poden col·locar torres
- `towers`: llista de torres construïdes
- `enemies`: llista d’enemics actius

## WaveManager
- `waveNumber`: número de l’onada
- `enemiesToSpawn`: quantitat d’enemics pendents de generar
- `spawnTimer`: temps entre aparicions d’enemics
- `spawnInterval`: interval fix de generació
- `waveInProgress`: indica si hi ha una onada activa

## Tower
- `x`, `y`: posició de la torre al mapa
- `range`: abast d’atac
- `damage`: dany que fa cada atac
- `fireRate`: velocitat d’atac
- `level`: nivell de millora actual
- `cost`: cost de construcció
- `upgradeCost`: cost de millora

## Enemy
- `x`, `y`: posició actual
- `health`: vida de l’enemic
- `speed`: velocitat de moviment
- `reward`: or que dona quan és derrotat
- `pathIndex`: punt actual del camí que està seguint
- `alive`: indica si continua actiu

## Base
- `life`: vida actual
- `maxLife`: vida màxima
- `x`, `y`: posició del punt final del camí

# 4. Accions, mètodes o funcions principals

## GameManager
- `loadGame()`: inicialitza l’estat de la partida
- `update(dt)`: actualitza el bucle principal del joc
- `draw()`: dibuixa els elements principals
- `canBuild(cost)`: comprova si el jugador té prou or per construir
- `buildTower(point)`: construeix una torre en un punt vàlid
- `upgradeTower(tower)`: millora una torre existent
- `checkEndGame()`: comprova si hi ha victòria o derrota

## WaveManager
- `startWave()`: prepara una nova onada
- `update(dt)`: controla el temporitzador de generació
- `spawnEnemy()`: crea un enemic nou
- `isWaveFinished()`: comprova si no queden enemics per generar ni enemics actius

## Tower
- `update(dt, enemies)`: busca objectius dins del rang i controla el temps entre atacs
- `findTarget(enemies)`: selecciona un enemic per atacar
- `attack(target)`: aplica dany a un enemic
- `upgrade()`: augmenta el nivell i millora atributs

## Enemy
- `update(dt, path)`: mou l’enemic pel camí
- `takeDamage(amount)`: rep dany
- `isDead()`: comprova si la vida és zero o inferior
- `reachGoal()`: indica si ha arribat al final del recorregut

## Base
- `takeDamage(value)`: resta vida a la base
- `isDestroyed()`: comprova si la base ha arribat a zero

# 5. Explicació del diagrama de classes

El diagrama de classes representa l’estructura lògica del joc i la relació entre els seus elements principals. No és un model decoratiu, sinó una guia directa per repartir responsabilitats abans de començar a programar.

El **GameManager** ocupa la posició central perquè coordina l’estat general de la partida, consulta la base, gestiona els recursos del jugador i actualitza la resta d’elements. El **WaveManager** depèn del GameManager i s’encarrega exclusivament de generar enemics i controlar el progrés de les onades.

La classe **Tower** representa les defenses del jugador. Necessita conèixer la llista d’enemics per poder seleccionar objectius i atacar-los. La classe **Enemy** concentra la lògica de moviment pel camí, la vida i la recompensa que dona quan és eliminat. Finalment, la **Base** només assumeix la responsabilitat de rebre dany i informar si ha estat destruïda.

Aquesta organització evita barrejar massa responsabilitats en un únic fitxer i facilita una implementació modular a Lua.

![Diagrama de classes](diagrames/diagrama_classes.png)

# 6. Explicació del diagrama de comportament

Per al diagrama de comportament s’ha escollit un **diagrama d’activitat**, perquè és el que millor reflecteix el flux principal del joc i el seu bucle repetitiu.

El diagrama mostra el procés des de l’inici de la partida fins als possibles finals. Primer s’inicialitzen la base, l’or, la primera onada i els punts de construcció. Després comença una onada i, durant aquesta, passen diversos processos en paral·lel o de manera intercalada dins del bucle principal: es generen enemics, el jugador construeix o millora defenses, les torres ataquen automàticament i els enemics avancen pel camí.

A mesura que avança la partida, el sistema comprova si algun enemic arriba al final i danya la base, o si és derrotat i dona or al jugador. Finalment, es comprova si la base ha estat destruïda o si l’onada ha acabat. Si encara queden onades, el flux torna a començar; si no, el joc acaba en victòria.

Aquest diagrama reflecteix clarament el bucle de joc definit a la fase 1.

![Diagrama de comportament](diagrames/diagrama_comportament.png)

# 7. Correspondència entre diagrames i codi futur

Els diagrames es traduiran al codi real mitjançant mòduls Lua separats. La correspondència prevista és la següent:

- **GameManager** → `src/managers/game_manager.lua`
- **WaveManager** → `src/managers/wave_manager.lua`
- **Tower** → `src/entities/tower.lua`
- **Enemy** → `src/entities/enemy.lua`
- **Base** → `src/entities/base.lua`

El fitxer `main.lua` actuarà com a punt d’entrada de LÖVE2D i delegarà lògica principal al GameManager. Aquest gestor farà la crida a `update(dt)` i `draw()` de la resta de mòduls.

A la pràctica, el diagrama de classes es convertirà en una separació de dades i responsabilitats. El diagrama d’activitat es convertirà en l’ordre real d’execució del bucle dins de `love.update(dt)` i en les condicions de canvi d’estat del joc.

# 8. Estructura inicial del repositori

L’estructura inicial prevista del repositori és la següent:

```text
forest-guardians/
├── README.md
├── main.lua
├── conf.lua
├── .gitignore
├── assets/
│   ├── sprites/
│   └── sounds/
├── diagrames/
│   ├── diagrama_classes.png
│   └── diagrama_comportament.png
└── src/
    ├── entities/
    │   ├── enemy.lua
    │   ├── tower.lua
    │   └── base.lua
    └── managers/
        ├── game_manager.lua
        └── wave_manager.lua
```

Aquesta estructura és coherent amb un projecte petit en LÖVE2D. Manté separats els recursos, les entitats del joc, els gestors de sistema i la documentació visual.

# 9. Primer commit i README inicial

El primer commit del repositori ha de servir per deixar constància formal de l’inici del projecte. El seu contingut mínim ha d’incloure:

- inicialització del repositori Git
- creació del `README.md`
- estructura inicial de carpetes i fitxers buits principals
- inclusió dels diagrames i de la documentació de la fase 2

El README inicial ha d’explicar de forma breu què és el projecte, quina tecnologia farà servir i com està organitzat. Un contingut inicial adequat seria:

- nom provisional del joc
- descripció curta del microvideojoc
- eines previstes: LÖVE2D, Lua i Visual Studio Code
- estructura bàsica del projecte
- objectiu general del prototip

Un missatge de commit adequat seria:

```bash
git commit -m "Initial project structure, README and phase 2 design"
```

En aquest entorn he deixat preparat un repositori local amb aquesta estructura i un primer commit local. La pujada final a GitHub s’haurà de fer des del teu equip amb les teves credencials.
