# 🏰 Forest Guardians

> Microvideojoc tower defense de fantasia en 2D desenvolupat amb LÖVE2D i Lua.

---

## 📖 Descripció

**Forest Guardians** és un joc de tipus *tower defense* en 2D amb vista superior. El jugador ha de defensar una base construint torres al llarg d'un camí en serpentina per impedir que els enemics hi arribin.

El joc consta de **10 onades progressives** amb tres tipus d'enemics (normals, ràpids i tancs) i tres tipus de torres (bàsica, arquera i màgica), cadascuna amb fins a **4 nivells de millora**. Les torres es poden vendre per recuperar una part de l'or invertit. La partida acaba en victòria si el jugador supera totes les onades, o en derrota si la base perd els seus 20 punts de vida.

---

## 🖼️ Captura del joc

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  🏰 FOREST  │  OLEADA 3/10  ●●●○○○○○○○  │  💀 8  │  🪙 240  │  ❤️ 14/20 ████░  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ►══════════╗                                                               │
│  [Arbres]   ║     [Torre Bàsica]     [Torre Arquera]                        │
│             ╚══════════════════════╗                                        │
│                                   ║   [Torre Màgica]   [Torre Bàsica]       │
│                         ╔═════════╝                                         │
│                         ║                    ╔═══════════[ BASE 🏰 ]         │
│   [Enemics →]           ╚════════════════════╝                              │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  TIENDA: [ Torre Bàsica 30or ]  [ Torre Arquera 50or ]  [ Torre Màgica 80or ]│
└─────────────────────────────────────────────────────────────────────────────┘
```

*Per veure el joc en acció, consulta el vídeo de gameplay a l'apartat corresponent.*

---

## 🛠️ Tecnologies utilitzades

| Tecnologia | Versió | Ús |
|-----------|--------|----|
| [LÖVE2D](https://love2d.org) | 11.x | Motor de joc 2D |
| Lua | 5.1 (integrat a LÖVE) | Llenguatge de programació |
| Visual Studio Code | — | Editor de codi |
| Markdown | — | Documentació del projecte |

---

## ▶️ Instruccions per executar el projecte

### Requisit previ
Cal tenir instal·lat **LÖVE2D** (versió 11 o superior):  
🔗 [https://love2d.org](https://love2d.org)

### Opció 1 — Terminal
```bash
# Navega fins a la carpeta del projecte
cd TOWER_DEFENSE_ENTORNS

# Executa el joc
love .
```

### Opció 2 — Arrossegar i deixar anar
Arrossega la carpeta `TOWER_DEFENSE_ENTORNS` directament sobre l'executable de LÖVE2D.

### Opció 3 — Windows (si LÖVE2D és al PATH)
Fes doble clic sobre `main.lua` des de l'explorador de fitxers.

---

## 🎮 Instruccions bàsiques per jugar

| Acció | Control |
|-------|---------|
| Seleccionar tipus de torre | Clic esquerre al botó de la barra inferior |
| Construir una torre | Clic esquerre sobre un **slot groc** del mapa |
| Seleccionar una torre existent | Clic esquerre sobre la torre |
| Millorar la torre | Clic a **MEJORAR** al panell emergent |
| Vendre la torre | Clic a **VENDER** al panell emergent (recupera el 50% de l'or invertit) |
| Deseleccionar | Clic fora de la torre o tecla `Escape` |
| Reiniciar partida | Tecla `R` (després de Game Over o Victòria) |

**Consell ràpid:** comences amb **150 d'or**. Construeix una o dues torres als primers slots abans que arribi la primera onada (tens 4 segons).

---

## 📁 Estructura del repositori

```
TOWER_DEFENSE_ENTORNS/
│
├── main.lua                   ← Codi complet del joc (lògica, dibuix i input)
├── conf.lua                   ← Configuració de la finestra (960×540, títol)
│
├── src/
│   └── entities/
│       ├── enemy.lua          ← Prototip inicial (no s'utilitza en la versió final)
│       └── tower.lua          ← Prototip inicial (no s'utilitza en la versió final)
│
├── README.md                  ← Aquest fitxer
├── 01_idea_i_abast.md         ← Definició del projecte i viabilitat
├── 02_model_del_joc.md        ← Model de dades i diagrames
├── 03_entorns_i_prototip.md   ← Configuració de l'entorn i primer prototip
├── 04_proves_i_depuracio.md   ← Proves funcionals i incidències detectades
├── 05_millores.md             ← Millores aplicades sobre el prototip inicial
├── 06_manual_usuari.md        ← Manual d'ús per al jugador
└── 07_manual_tecnic.md        ← Manual tècnic intern del projecte
```

---

## 📊 Estat del projecte

**✅ Versió final entregada**

| Funcionalitat | Estat |
|--------------|-------|
| Camí en serpentina amb waypoints | ✅ Complet |
| 10 onades amb dificultat progressiva | ✅ Complet |
| 3 tipus d'enemics (normal, ràpid, tanc) | ✅ Complet |
| 3 tipus de torres (bàsica, arquera, màgica) | ✅ Complet |
| Sistema de millores fins a nivell 4 | ✅ Complet |
| Sistema de venda de torres (50% reembors) | ✅ Complet |
| HUD professional (barres, icones, animacions) | ✅ Complet |
| Panell emergent de selecció de torre | ✅ Complet |
| Condicions de victòria i derrota | ✅ Complet |
| Decoracions i base visual | ✅ Complet |

---

## 🎥 Vídeo de gameplay comentat

🔗 [Enllaç al vídeo de gameplay](https://drive.google.com/file/d/1gys77CiKSLrfhxCCEpeQJrAIxeaCZe00/view?usp=sharing)


---

## 👤 Autor

**Daniel Kravets**  
Projecte desenvolupat com a microvideojoc de pràctiques amb LÖVE2D i Lua.

---

## 💭 Reflexió: què he après

Aquest projecte m'ha permès entendre com es construeix un joc complet des de zero, no només a nivell tècnic sinó també de disseny i planificació.

Tècnicament, he après a gestionar un bucle de joc amb `love.update` i `love.draw`, a implementar una màquina d'estats per controlar les fases de la partida, i a dissenyar estructures de dades netes que permetin escalar el joc sense haver de reescriure tot el codi. El sistema de waypoints per moure enemics, la lògica de selecció i millora de torres, i la gestió de l'economia del joc han estat els reptes tècnics més interessants.

A nivell de procés, he comprovat que és molt millor definir bé l'abast al principi que intentar afegir funcionalitats a mida que avança el projecte. Cada vegada que vaig intentar afegir una cosa sense planificar-la, van aparèixer problemes que obligaven a retocar parts que ja funcionaven.

Si tornés a fer el projecte, separaria el codi en mòduls des del principi en lloc de tenir tot en un sol fitxer, i afegiria suport per a so des de l'inici, ja que és molt difícil afegir-lo sense interrupcions un cop el joc ja és funcional.
