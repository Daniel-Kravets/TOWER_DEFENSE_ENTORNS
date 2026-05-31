# 1. Introducció

Després de tenir una primera versió funcional del prototip, el projecte ha passat per quatre fases de millora substancial. Cada fase ha resolt problemes concrets detectats durant les proves i ha afegit funcionalitat que ha fet el joc progressivament més complet, estable i jugable.

Aquest document recull les millores aplicades, explica quin problema resolia cada una i descriu quin efecte ha tingut en el projecte.

---

# 2. Millora 1: Redisseny del mapa i sistema de camins

## Problema o limitació anterior

El prototip inicial tenia un camí completament recte en línia horitzontal fixat a la coordenada `y = 270`. Els enemics simplement incrementaven la seva coordenada `x` cada fotograma, sense cap lògica de navegació. El mapa tenia tres slots de construcció fixos i estava buit visualment: fons de color uniforme, cap decoració, cap indicació de base ni de punt d'entrada.

```lua
-- Versió inicial: moviment en línia recta
enemy.x = enemy.x + enemy.speed * dt

-- Camp completament buit
love.graphics.setColor(0.55, 0.45, 0.3)
love.graphics.rectangle("fill", 0, 230, 960, 80)
```

## Millora aplicada

S'ha substituït el camí recte per un recorregut en serpentina definit com una taula de deu coordenades (`PATH`). Els enemics ara segueixen els punts del camí en ordre, calculant la direcció cap al proper waypoint en cada fotograma. El mapa s'ha omplert amb decoracions (arbres, arbustos, pedres i flors), un camí amb textura de terra i una base visual al final del recorregut.

```lua
-- Versió millorada: sistema de waypoints
local PATH = {
    {x=-20, y=120}, {x=110, y=120}, {x=110, y=440},
    {x=340, y=440}, {x=340, y=180}, {x=570, y=180},
    {x=570, y=440}, {x=760, y=440}, {x=760, y=270},
    {x=990, y=270},
}

-- Moviment per waypoints
local t  = PATH[e.waypointIndex]
local dx = t.x - e.x
local dy = t.y - e.y
local d  = math.sqrt(dx*dx + dy*dy)
if d < 4 then e.waypointIndex = e.waypointIndex + 1
else
    e.x = e.x + (dx/d) * e.speed * dt
    e.y = e.y + (dy/d) * e.speed * dt
end
```

Els vuit punts de construcció s'han verificat manualment perquè cap no solapi cap segment del camí (±26 píxels de marge per cada banda del centre del camí).

## Efecte en el projecte

El mapa ha passat de ser un rectangle buit a un entorn visualment ric i llegible. El camí en serpentina fa el joc estratègicament més interessant perquè les torres poden cobrir múltiples segments alhora. El moviment dels enemics és ara fluït i no té errors en les cantonades.

## Com s'ha comprovat

S'ha executat el joc i s'ha observat que els enemics seguien el recorregut complet sense quedar-se encallats ni saltar entre punts. Es va verificar que cap slot de construcció solapava el camí comprovant les àrees d'ocupació de cada segment.

---

# 3. Millora 2: Sistema d'onades i dificultat progressiva

## Problema o limitació anterior

El prototip inicial generava enemics de manera infinita cada dos segons, tots iguals, sense cap estructura d'onades ni condicions de fi de partida. La base no tenia vida i els enemics que arribaven al final simplement desapareixien del mapa sense cap penalització. El jugador no podia guanyar ni perdre.

```lua
-- Versió inicial: generació infinita sense onades
if enemySpawnTimer >= 2 then
    spawnEnemy()
    enemySpawnTimer = 0
end

-- Enemics que surten del mapa sense efecte
if enemy.x > 990 then
    table.remove(enemies, i)
end
```

## Millora aplicada

S'ha implementat una màquina d'estats amb quatre fases: `countdown`, `spawning`, `fighting` i `victory` o `gameover`. Cada onada es construeix dinàmicament a partir d'una funció `buildSpawnQueue` que escala la quantitat, la vida i la velocitat dels enemics en funció del número d'onada.

S'han afegit tres tipus d'enemics amb característiques diferenciades:

| Tipus   | Radi | Velocitat | Vida base | Recompensa | Dany a base |
|---------|------|-----------|-----------|------------|-------------|
| Normal  | 15   | 80        | 4         | 10 or      | 1           |
| Ràpid   | 11   | 150       | 2         | 15 or      | 1           |
| Tanc    | 20   | 40        | 14        | 30 or      | 2           |

La dificultat escala cada onada: la vida dels enemics es multiplica per `1 + (N-1) × 0.45` i la velocitat per `1 + (N-1) × 0.06`. La base comença amb 20 punts de vida i el joc acaba quan arriba a zero o quan el jugador supera les 10 onades.

## Efecte en el projecte

El joc ara té un principi, un desenvolupament i un final reals. La dificultat augmenta de manera notable entre onades, de manera que les primeres onades serveixen per establir defenses i les darreres exigeixen una estratègia ben planificada.

## Com s'ha comprovat

S'han executat partides completes verificant que: els enemics apareixien en el nombre esperat, la dificultat augmentava visiblement a partir de l'onada 3, la base perdia vida quan un enemic passava i la pantalla de Game Over o Victòria apareixia correctament.

---

# 4. Millora 3: HUD professional

## Problema o limitació anterior

La interfície del prototip consistia en una única línia de text amb `love.graphics.print()`. No hi havia informació sobre l'onada actual, l'or disponible ni la vida de la base. El jugador no rebia cap indicació visual de l'estat del joc.

```lua
-- Versió inicial: HUD mínim amb text pla
love.graphics.print("Forest Guardians - Prototip Fase 3", 20, 20)
love.graphics.print("Enemigos en mapa: " .. #enemies, 200, 11)
```

## Millora aplicada

S'ha dissenyat una barra superior de 68 píxels dividida en cinc seccions amb separadors visuals:

- **Títol**: icona de castell + nom del joc
- **Onada**: número actual, barra de deu punts de progrés (completats en blau, pròxim pulsant en verd)
- **Enemics**: icona de calavera + comptador amb color dinàmic
- **Or**: icona de moneda + quantitat
- **Base**: icona de cor + número + barra de color que canvia de verd a vermell

S'ha afegit una barra inferior de 68 píxels amb la botiga de torres i s'ha implementat un banner central animat d'anunci d'onada amb transicions d'aparició i desaparició.

Les pantalles de Game Over i Victòria s'han redissenyat com a targetes centrades amb colors diferenciats, resum de l'or final i indicació per reiniciar.

## Efecte en el projecte

El jugador pot llegir ràpidament l'estat de la partida en qualsevol moment sense necessitat d'endevinar res. La informació visual redueix la càrrega cognitiva i millora l'experiència de joc de manera significativa.

## Com s'ha comprovat

S'han executat partides verificant que totes les seccions del HUD mostraven valors correctes i actualitzats en temps real: l'or augmentava en matar enemics, la barra de vida de la base canviava de color en rebre danys i els punts de progrés d'onada s'actualitzaven correctament.

---

# 5. Millora 4: Torres amb tipus, millores i venda

## Problema o limitació anterior

El prototip tenia un únic tipus de torre, gratuïta, sense possibilitat de millora ni de venda. No hi havia economia real: el jugador construïa torres sense cost i no podia canviar de decisió un cop construïdes. La botiga mostrava botons de torres bloquejades que no feien res.

```lua
-- Versió anterior: torre única i gratuïta
table.insert(towers, {
    x=cx, y=cy,
    range=140, damage=1, attackSpeed=0.8, cooldown=0,
})
```

## Millora aplicada

S'han definit tres tipus de torre amb estadístiques i colors propis, cadascuna amb quatre nivells de millora:

| Torre    | Cost | Dany (lv1→4) | Abast (lv1→4) | Color      |
|----------|------|--------------|----------------|------------|
| Bàsica   | 30g  | 1 → 5        | 140 → 195      | Blau       |
| Arquera  | 50g  | 2 → 8        | 200 → 270      | Verd       |
| Màgica   | 80g  | 4 → 14       | 120 → 170      | Porpra     |

Cada nivell canvia visualment la torre: s'afegeixen anells, efectes de brillantor i, al nivell màxim, punts daurats giratoris.

S'ha implementat un sistema de selecció: fer clic sobre una torre mostra un panell contextual amb les estadístiques actuals, un botó de millora (que indica el cost i es mostra en gris si no hi ha prou or) i un botó de venda que retorna el 50% del total invertit.

```lua
-- Estructura de torre en la versió millorada
table.insert(towers, {
    x=cx, y=cy,
    towerType=selectedTType, level=1,
    damage=lv.damage, range=lv.range,
    attackSpeed=lv.atkSpeed, cooldown=0,
    totalCost=def.cost, slot=slot,
})
```

## Efecte en el projecte

El joc ara té una economia real que obliga el jugador a prendre decisions estratègiques: construir moltes torres bàsiques o invertir en torres més cares però més potents. La possibilitat de vendre i reposicionar torres dona flexibilitat estratègica i redueix la frustració d'errors de col·locació.

## Com s'ha comprovat

S'han verificat els casos següents:
- Construir una torre amb or suficient desconta el cost correctament.
- Intentar construir sense or suficient no fa cap acció.
- Millorar una torre actualitza els estadístics i el visual immediatament.
- Vendre una torre retorna exactament el 50% del total invertit i allibera el slot.
- El panell contextual mostra el cost de la pròxima millora o el missatge "NIVEL MAX".

---

# 6. Millores pendents per a futures versions

Si el projecte tingués més temps de desenvolupament, les millores prioritàries serien:

1. **Sistema de guarda de partida**: permetre desar i carregar l'estat per no haver de començar des de zero.
2. **Torres amb efectes especials**: torres amb dany en àrea, torres que alenteixen enemics o torres que disparen projectils visibles.
3. **Mapa amb múltiples rutes**: un camí amb bifurcacions que augmenti la complexitat estratègica.
4. **Menú principal**: pantalla d'inici amb opcions de dificultat i crèdits.
5. **Efectes de so i música**: sons d'atac, de construcció i música de fons per millorar la immersió.
6. **Suport per a ratolí i teclat complets**: tecles numèriques per seleccionar el tipus de torre sense necessitat de fer clic a la botiga.
7. **Estadístiques de partida**: mostrar el total d'enemics eliminats, l'or acumulat i la nota final a la pantalla de victòria.
