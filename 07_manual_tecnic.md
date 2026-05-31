# Manual tècnic — Forest Guardians

---

# 1. Organització del projecte

```
TOWER_DEFENSE_ENTORNS/
│
├── main.lua              ← Lògica completa del joc
├── conf.lua              ← Configuració de la finestra (LÖVE2D)
│
├── src/
│   ├── entities/
│   │   ├── enemy.lua     ← Fitxer antic (no s'utilitza en la versió actual)
│   │   └── tower.lua     ← Fitxer antic (no s'utilitza en la versió actual)
│
├── 01_idea_i_abast.md
├── 02_model_del_joc.md
├── 03_entorns_i_prototip.md
├── 04_proves_i_depuracio.md
├── 05_millores.md
├── 06_manual_usuari.md
└── 07_manual_tecnic.md
```

Tot el codi funcional de la versió final es troba exclusivament a `main.lua`. Els fitxers `enemy.lua` i `tower.lua` pertanyen al prototip inicial i no s'utilitzen.

---

# 2. Fitxer conf.lua

Configura la finestra del motor LÖVE2D abans de carregar el joc.

```lua
function love.conf(t)
    t.window.title  = "Forest Guardians"
    t.window.width  = 960
    t.window.height = 540
end
```

Defineix una resolució fixa de **960 × 540 píxels** i el títol de la finestra.

---

# 3. Estructura interna de main.lua

El fitxer es divideix en nou seccions clarament delimitades per comentaris:

| Secció | Contingut |
|--------|-----------|
| Constants de layout | Dimensions del HUD i del camí |
| Dades del mapa | Camí, enemics i decoracions |
| Definicions de torres | Estadístiques i colors per tipus i nivell |
| Estat del joc | Variables globals de la partida |
| Reset i càrrega | `resetGame()` i `love.load()` |
| Gestió d'onades | `buildSpawnQueue()` |
| Helpers | `dist()`, `popupRect()`, `upgradeTower()`, `sellTower()` |
| Update | `love.update(dt)` |
| Draw | Totes les funcions de dibuix |
| Input | `love.mousepressed()` i `love.keypressed()` |

---

# 4. Constants principals

```lua
local PATH_WIDTH  = 52     -- amplada visual del camí en píxels
local TOTAL_WAVES = 10     -- total d'onades de la partida
local BASE_HP_MAX = 20     -- punts de vida inicials de la base
local WAVE_GAP    = 6      -- segons d'espera entre onades
local HUD_TOP     = 68     -- altura de la barra HUD superior
local HUD_BOT_Y   = 472    -- coordenada y d'inici de la barra inferior
local HUD_BOT_H   = 68     -- altura de la barra HUD inferior
```

L'àrea de joc activa queda entre `y = 68` i `y = 472`, és a dir, 404 píxels d'alçada. El camí ocupa la zona `y = 120` a `y = 440`, amb marge suficient per no solapar cap barra HUD.

---

# 5. Taula PATH — Definició del camí

```lua
local PATH = {
    {x=-20,  y=120},   -- punt d'entrada (fora de pantalla)
    {x=110,  y=120},
    {x=110,  y=440},
    {x=340,  y=440},
    {x=340,  y=180},
    {x=570,  y=180},
    {x=570,  y=440},
    {x=760,  y=440},
    {x=760,  y=270},
    {x=990,  y=270},   -- punt de sortida / base (fora de pantalla)
}
```

Cada element és una coordenada `{x, y}` que els enemics han d'assolir en ordre. Quan un enemic assoleix un punt (distància < 4 px), incrementa el seu `waypointIndex` i es dirigeix al punt següent. Quan `waypointIndex > #PATH`, l'enemic ha arribat a la base i li fa dany.

---

# 6. Taula ENEMY_DEFS — Tipus d'enemics

```lua
local ENEMY_DEFS = {
    normal = {radius=15, speed=80,  health=4,  reward=10, baseDmg=1, color={...}},
    fast   = {radius=11, speed=150, health=2,  reward=15, baseDmg=1, color={...}},
    tank   = {radius=20, speed=40,  health=14, reward=30, baseDmg=2, color={...}},
}
```

Cada entrada defineix les estadístiques base d'un tipus d'enemic. Aquests valors s'escalen dinàmicament per número d'onada a `buildSpawnQueue()`.

---

# 7. Taula TOWER_DEFS — Definicions de torres

```lua
local TOWER_DEFS = {
    basic = {
        name = "Torre Basica", cost = 30,
        cols = { -- {outer, mid, gem} per a cada nivell (1 a 4)
            {{0.15,0.22,0.65},{0.28,0.45,0.92},{0.55,0.72,1.00}},
            ...
        },
        ups = { -- estadístiques per nivell; cost = or per assolir-lo
            {damage=1, range=140, atkSpeed=0.80, cost=0},
            {damage=2, range=155, atkSpeed=0.70, cost=25},
            {damage=3, range=175, atkSpeed=0.60, cost=40},
            {damage=5, range=195, atkSpeed=0.50, cost=65},
        },
    },
    -- archer i magic amb la mateixa estructura
}
```

Cada torre té:
- `name`: nom visible
- `cost`: or necessari per construir-la
- `cols`: tres colors (exterior, anell intermedi, gema) per a cada un dels quatre nivells
- `ups`: array de quatre nivells amb estadístiques i cost de millora

---

# 8. Variables d'estat de la partida

```lua
local slots           = {}   -- punts de construcció disponibles
local towers          = {}   -- torres construïdes
local enemies         = {}   -- enemics actius al mapa
local spawnQueue      = {}   -- enemics pendents de generar en l'onada actual
local selectedTower   = nil  -- torre seleccionada pel jugador
local selectedTType   = "basic"

local currentWave       = 0
local waveState         = "countdown"  -- estat de la màquina d'onades
local countdownTimer    = 0
local spawnTimer        = 0
local spawnInterval     = 1.0
local baseHP            = BASE_HP_MAX
local gold              = 150
local waveBonus         = 0
local bonusTimer        = 0
local waveAnnounceTimer = 0
local waveAnnounceText  = ""
```

### Estructura d'un slot
```lua
{x, y, size, occupied}
-- occupied: false quan lliure, true quan hi ha una torre construïda
```

### Estructura d'una torre
```lua
{
    x, y,
    towerType,    -- "basic" | "archer" | "magic"
    level,        -- 1 a 4
    damage,
    range,
    attackSpeed,
    cooldown,
    totalCost,    -- or total invertit (construcció + millores)
    slot,         -- referència directa a l'objecte slot (per alliberar-lo en vendre)
}
```

### Estructura d'un enemic
```lua
{
    x, y,
    radius, speed, health, maxHealth,
    color,         -- {r, g, b}
    reward,        -- or que dóna en morir
    baseDmg,       -- dany que fa a la base si hi arriba
    waypointIndex, -- índex del pròxim punt del PATH a assolir
}
```

---

# 9. Màquina d'estats d'onades

El `waveState` controla el flux principal de la partida:

```
                    ┌─────────────────────────────────────────┐
                    │                                         │
  inici ──► countdown ──► spawning ──► fighting ──► countdown  (× 10 vegades)
                                           │
                                           └──► victory
              (baseHP = 0)
                    │
                 gameover
```

| Estat | Descripció |
|-------|-----------|
| `countdown` | Espera entre onades. El temporitzador `countdownTimer` decreix. Quan arriba a 0, s'incrementa `currentWave` i es genera la cua d'enemics. |
| `spawning` | Es generen enemics de `spawnQueue` un per un cada `spawnInterval` segons. Quan la cua és buida, passa a `fighting`. |
| `fighting` | Tots els enemics han estat generats. Quan `#enemies == 0`, l'onada és completada. |
| `victory` | `currentWave >= TOTAL_WAVES` i cap enemic actiu. |
| `gameover` | `baseHP <= 0`. |

Durant `countdown`, `love.update()` retorna immediatament sense processar enemics ni torres (no n'hi ha d'actius).

---

# 10. Funció buildSpawnQueue

```lua
local function buildSpawnQueue(waveNum)
    local count    = 5 + waveNum * 2         -- enemics per onada
    local hpMult   = 1 + (waveNum-1) * 0.45  -- multiplicador de vida
    local spdMult  = 1 + (waveNum-1) * 0.06  -- multiplicador de velocitat
    local interval = math.max(0.35, 1.1 - (waveNum-1) * 0.08)  -- interval de spawn
    ...
end
```

| Onada | Enemics | Mult. vida | Mult. vel. | Interval |
|-------|---------|------------|-----------|---------|
| 1     | 7       | × 1.00     | × 1.00    | 1.10 s  |
| 3     | 11      | × 1.90     | × 1.12    | 0.94 s  |
| 5     | 15      | × 2.80     | × 1.24    | 0.78 s  |
| 10    | 25      | × 5.05     | × 1.54    | 0.38 s  |

Els tipus d'enemics s'introdueixen progressivament:
- Onada 1: només normals
- Onada 2+: cada 4t enemic és ràpid
- Onada 3+: cada 5è enemic és tanc

---

# 11. Sistema d'atac de les torres

A cada fotograma, si el `cooldown` d'una torre és ≤ 0, es recorre la llista d'enemics en ordre invers (de l'últim al primer, és a dir, del més avançat pel camí al menys avançat). Quan es troba un enemic dins del `range`, se li aplica el `damage` i es reinicia el `cooldown` a `attackSpeed`. Si la vida de l'enemic arriba a 0, s'elimina de la llista i el jugador rep la recompensa en or.

```lua
for _, tower in ipairs(towers) do
    tower.cooldown = tower.cooldown - dt
    if tower.cooldown <= 0 then
        for i = #enemies, 1, -1 do
            local e = enemies[i]
            if dist(tower.x, tower.y, e.x, e.y) <= tower.range then
                e.health = e.health - tower.damage
                tower.cooldown = tower.attackSpeed
                if e.health <= 0 then
                    gold = gold + e.reward
                    table.remove(enemies, i)
                end
                break
            end
        end
    end
end
```

Iterar en ordre invers prioritza l'enemic que ha avançat més pel camí, cosa que és la política d'atac més eficient en un tower defense clàssic.

---

# 12. Funció popupRect

Determina la posició del panell emergent de selecció de torre de manera que:
1. Apareix per sota de la torre si hi ha espai fins a la barra inferior.
2. Apareix per sobre si no hi ha espai per sota.
3. Es restringeix horitzontalment per no sortir de la pantalla.

```lua
local function popupRect(t)
    local r0 = 18 + (t.level-1) * 1.5
    local pw, ph = 228, 94
    local px = t.x - pw/2
    local py
    if t.y + r0 + 12 + ph < HUD_BOT_Y - 4 then py = t.y + r0 + 10
    else py = t.y - r0 - 12 - ph end
    px = math.max(5, math.min(955-pw, px))
    py = math.max(HUD_TOP+5, math.min(HUD_BOT_Y-ph-5, py))
    return px, py, pw, ph
end
```

Aquesta funció és cridada tant per `drawTowerPopup()` (per dibuixar) com per `love.mousepressed()` (per detectar clics als botons), garantint que les coordenades siguin sempre consistents.

---

# 13. Pipeline de dibuix

`love.draw()` crida les funcions de dibuix en aquest ordre, de menor a major prioritat visual:

```
1. drawPath()           -- camí de terra (capa base)
2. drawDecorations()    -- arbres, arbustos, pedres, flors
3. drawBase()           -- castell al final del camí
4. drawSlots()          -- punts de construcció disponibles
5. drawTowers()         -- torres construïdes amb indicadors
6. drawEnemies()        -- enemics amb barres de vida
7. drawTopBar()         -- HUD superior (sempre per sobre del joc)
8. drawBottomBar()      -- HUD inferior amb botiga
9. drawTowerPopup()     -- panell emergent de selecció (si n'hi ha)
10. drawWaveAnnounce()  -- banner animat d'inici d'onada
11. drawWaveBonus()     -- text flotant de bonus d'or
12. drawOverlay()       -- pantalla de Game Over o Victòria
```

Les funcions 7 a 12 s'executen sempre per sobre de tot el contingut del joc. Les funcions 9 a 12 poden retornar immediatament si la condició no és activa.

---

# 14. Gestió de l'entrada

`love.mousepressed()` processa els clics en ordre de prioritat:

1. Si el clic és a la barra inferior (`y >= HUD_BOT_Y`): comprova si és sobre un botó de la botiga i actualitza `selectedTType`.
2. Si el clic és a la barra superior (`y < HUD_TOP`): s'ignora.
3. Si hi ha una torre seleccionada i el clic és als botons del panell emergent: executa `upgradeTower()` o `sellTower()`.
4. Si el clic és sobre una torre existent: selecciona o deselecciona la torre.
5. Si el clic és sobre un slot buit: intenta construir una torre del tipus `selectedTType` si hi ha prou or.
6. Si el clic no coincideix amb cap element: deselecciona la torre actual.

---

# 15. Decisions tècniques rellevants

### Tot el codi en un sol fitxer
S'ha optat per mantenir tot el codi a `main.lua` per simplicitat i coherència amb l'abast d'un microvideojoc. Aquesta decisió facilita la lectura lineal del codi però reduiria l'escalabilitat en un projecte més gran.

### Referència directa al slot des de la torre
Cada torre emmagatzema una referència directa a l'objecte slot que ocupa (`tower.slot = slot`). Quan es ven la torre, es pot alliberar el slot directament amb `tower.slot.occupied = false` sense necessitat de buscar el slot per coordenades.

### popupRect compartida entre draw i input
La funció `popupRect()` és accessible tant per les funcions de dibuix com per les de gestió d'entrada. Això garanteix que les coordenades dels botons del panell siguin sempre idèntiques entre el que es veu i el que es detecta com a clic.

### Iteració inversa per als atacs
Les torres iteran la llista d'enemics en ordre invers (`for i = #enemies, 1, -1`) perquè els enemics s'insereixen a la llista en ordre de generació i, per tant, l'últim de la llista és el que ha avançat més pel camí. Atacar primer l'enemic més avançat és la política d'atac més eficient.

### Funcions locals per a icons
Les funcions `iconCoin`, `iconHeart`, `iconSkull` i `iconCastle` estan definides com a funcions locals dins del mateix fitxer i dibuixen icones amb primitives de LÖVE2D, sense necessitat de cap fitxer d'imatge extern.

---

# 16. Com ampliar o mantenir el projecte

### Afegir un nou tipus d'enemic
1. Afegir una entrada a `ENEMY_DEFS` amb els seus atributs.
2. Afegir la lògica de selecció a `buildSpawnQueue()` per determinar en quines onades apareix.
3. Opcionalment, afegir una forma visual diferenciada a `drawEnemies()`.

### Afegir un nou tipus de torre
1. Afegir una entrada a `TOWER_DEFS` amb `name`, `cost`, `cols` i `ups`.
2. Afegir un botó a `drawBottomBar()` i el seu posicionament al detector de clics de la barra inferior a `love.mousepressed()`.
3. La lògica d'atac, millora i venda funciona genèricament per a qualsevol entrada de `TOWER_DEFS` sense canvis addicionals.

### Afegir un nou mapa
1. Substituir la taula `PATH` per unes noves coordenades.
2. Reposicionar els `slots` verificant que no solapen el nou camí (±26 px de marge).
3. Reposicionar les `DECORATIONS` si escau.

### Separar el codi en mòduls
Per a un projecte més gran, es recomana separar el codi en fitxers independents:
- `src/map.lua`: PATH, DECORATIONS i funcions de dibuix del mapa
- `src/towers.lua`: TOWER_DEFS i lògica de torres
- `src/enemies.lua`: ENEMY_DEFS, buildSpawnQueue i lògica d'enemics
- `src/hud.lua`: totes les funcions de dibuix del HUD
- `src/state.lua`: variables globals i resetGame

Cada mòdul s'hauria de carregar amb `require()` des de `main.lua`.
