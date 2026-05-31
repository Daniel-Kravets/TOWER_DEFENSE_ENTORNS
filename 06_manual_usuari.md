# Manual d'usuari — Forest Guardians

---

# 1. Què és Forest Guardians?

Forest Guardians és un joc de tipus tower defense en 2D. El teu objectiu és defensar una base construint torres al llarg d'un camí en serpentina per impedir que els enemics hi arribin. El joc es desenvolupa en onades progressives: cada onada porta enemics més ràpids i resistents. Si aconsegueixes superar les deu onades sense que la base perdi tots els seus punts de vida, guanyes la partida.

---

# 2. Com s'executa el joc

**Requisit:** Cal tenir instal·lat LÖVE2D (versió 11 o superior). Es pot descarregar gratuïtament des de [https://love2d.org](https://love2d.org).

**Per executar el joc:**

1. Obre una terminal o línia de comandes.
2. Navega fins a la carpeta del projecte (`TOWER_DEFENSE_ENTORNS`).
3. Executa la comanda:

```
love .
```

També pots arrossegar la carpeta del projecte directament sobre l'executable de LÖVE2D.

La finestra del joc s'obrirà amb una resolució de 960 × 540 píxels amb el títol **Forest Guardians**.

---

# 3. Què veus quan comences

Quan el joc arrenca, veus directament el mapa de joc amb tots els elements actius:

```
┌──────────────────────────────────────────────────────────────┐
│  [Barra superior: ONADA · ENEMICS · OR · VIDA BASE]          │  ← HUD superior
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ►══════════╗                          [ ]  [ ]             │  ← camí i slots
│             ║    [ ]    [ ]                                  │
│             ╚══════════════════╗                            │
│                                ║   [ ]   [ ]                 │
│                      ╔═════════╝                            │
│                      ║              ╔═══════════[ BASE ]     │
│                      ╚══════════════╝                        │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│  [TIENDA: Torre Bàsica · Torre Arquera · Torre Màgica]       │  ← HUD inferior
└──────────────────────────────────────────────────────────────┘
```

- Els **quadrats grocs** amb un símbol `+` són els **slots de construcció** (punts on pots construir torres).
- El **camí de terra** és la ruta que seguiran els enemics fins a la base.
- La **base** és el castell que veus a la dreta del camí: és el que has de defensar.
- La **fletxa** a l'esquerra indica el punt d'entrada dels enemics.

Durant els primers **4 segons** el joc mostra un compte enrere abans de la primera onada. Aprofita aquest temps per construir les primeres torres.

---

# 4. Controls

El joc es controla exclusivament amb el **ratolí** i dues tecles de teclat.

| Acció | Com fer-la |
|-------|-----------|
| Seleccionar tipus de torre | Clic esquerre sobre un botó de la **barra inferior** |
| Construir una torre | Clic esquerre sobre un **slot groc** del mapa |
| Seleccionar una torre existent | Clic esquerre sobre una **torre ja construïda** |
| Millorar la torre seleccionada | Clic al botó **MEJORAR** del panell emergent |
| Vendre la torre seleccionada | Clic al botó **VENDER** del panell emergent |
| Deseleccionar la torre | Clic fora de la torre o tecla `Escape` |
| Reiniciar la partida (Game Over / Victòria) | Tecla `R` |

---

# 5. Tipus de torres

A la barra inferior hi ha la botiga amb tres tipus de torre. Fes clic al botó del tipus que vols construir i després fes clic sobre un slot groc del mapa.

### Torre Bàsica — 30 d'or
La torre més equilibrada i assequible. Ideal per cobrir zones sense gastar massa or.

| Nivell | Dany | Abast | Vel. atac | Cost millora |
|--------|------|-------|-----------|-------------|
| 1      | 1    | 140   | 0.80 s    | —           |
| 2      | 2    | 155   | 0.70 s    | 25 or       |
| 3      | 3    | 175   | 0.60 s    | 40 or       |
| 4 MAX  | 5    | 195   | 0.50 s    | 65 or       |

### Torre Arquera — 50 d'or
Torre de gran abast, ideal per cobrir trams llargs del camí. Especialment efectiva contra enemics ràpids.

| Nivell | Dany | Abast | Vel. atac | Cost millora |
|--------|------|-------|-----------|-------------|
| 1      | 2    | 200   | 1.00 s    | —           |
| 2      | 3    | 220   | 0.85 s    | 35 or       |
| 3      | 5    | 245   | 0.70 s    | 55 or       |
| 4 MAX  | 8    | 270   | 0.55 s    | 90 or       |

### Torre Màgica — 80 d'or
La torre més cara, però la que fa més dany per atac. Molt eficaç contra enemics de tipus tanc.

| Nivell | Dany | Abast | Vel. atac | Cost millora |
|--------|------|-------|-----------|-------------|
| 1      | 4    | 120   | 1.80 s    | —           |
| 2      | 6    | 135   | 1.50 s    | 50 or       |
| 3      | 9    | 150   | 1.20 s    | 80 or       |
| 4 MAX  | 14   | 170   | 1.00 s    | 120 or      |

> **Nota:** Si no tens prou or per construir un tipus de torre, el slot del mapa es mostrarà en gris en lloc de groc.

---

# 6. Tipus d'enemics

Els enemics segueixen el camí automàticament i ataquen la base quan hi arriben.

| Tipus  | Color    | Vida | Velocitat | Dany a base | Recompensa |
|--------|----------|------|-----------|-------------|------------|
| Normal | Vermell  | 4    | Mitjana   | 1           | 10 or      |
| Ràpid  | Taronja  | 2    | Alta      | 1           | 15 or      |
| Tanc   | Blau     | 14   | Baixa     | 2           | 30 or      |

Cada enemic porta una **barra de vida** visible sobre seu:
- **Verda**: vida alta
- **Groga**: vida mitjana
- **Vermella**: vida baixa

---

# 7. La barra superior (HUD)

La barra fosca a la part superior de la pantalla mostra l'estat de la partida en tot moment:

```
[Castell] FOREST  |  ONADA 3 / 10  [●●●○○○○○○○]  |  [Calavera] 5  |  [Moneda] 240  |  [Cor] Base 14/20 [████████░░]
```

- **ONADA N/10**: onada actual i total. Els punts de color blau indiquen onades completades.
- **Enemics**: quants enemics queden per eliminar en l'onada actual.
- **Or**: l'or disponible per construir i millorar torres.
- **Base**: punts de vida que li queden a la base. La barra canvia de verd a vermell a mesura que la base perd vida.

Quan estàs entre onades, veuràs el compte enrere fins a la pròxima: *"Siguiente en 5s"*.

---

# 8. Millorar i vendre torres

### Millorar una torre

1. Fes clic sobre una torre construïda al mapa. Apareixerà un **panell emergent**.
2. El panell mostra el nom, el nivell actual (punts de color), les estadístiques i dos botons.
3. Fes clic a **MEJORAR** per pujar un nivell. El botó es mostra en verd si pots pagar i en gris si no tens prou or.
4. Al nivell màxim (4), el botó indica **NIVEL MAX** i no es pot fer clic.

### Vendre una torre

1. Selecciona la torre fent-hi clic.
2. Fes clic a **VENDER**. Recuperaràs el **50% del total invertit** (cost inicial + totes les millores).
3. El slot quedarà lliure i podràs construir-hi una altra torre.

> **Exemple:** Si has construït una Torre Bàsica (30 or) i l'has millorat fins al nivell 3 (30 + 25 + 40 = 95 or totals), en vendre-la recuperes 47 or.

---

# 9. Com guanyar i com perdre

### Victòria
Supera les **10 onades** sense que la base arribi a 0 punts de vida. Apareixerà una pantalla daurada amb el missatge **VICTORIA!** i el total d'or acumulat.

### Derrota
Si la base perd tots els seus **20 punts de vida**, apareixerà una pantalla vermella amb el missatge **GAME OVER** i l'onada en la qual ha caigut.

En ambdós casos, prem **R** per reiniciar la partida des del principi.

---

# 10. Sistema d'or

- Comences la partida amb **150 or**.
- Cada enemic eliminat per les teves torres dona una recompensa.
- En acabar cada onada, reps un **bonus**: `20 + onada × 10` d'or.
  - Onada 1: +30 or
  - Onada 5: +70 or
  - Onada 10: +120 or
- Vendre torres retorna el **50% del total invertit**.

---

# 11. Consells per jugar millor

1. **Construeix les primeres torres abans que arribin els enemics.** Tens 4 segons de compte enrere al principi. Aprofita'ls per col·locar almenys una o dues torres als primers slots.

2. **Prioritza els slots que cobreixen dues parts del camí.** El camí fa diverses corbes, i alguns slots permeten que una torre dispari sobre enemics en dos trams alhora.

3. **Millora una torre existent en lloc de construir-ne una de nova quan sigui més eficient.** Una torre de nivell 3 és molt més eficaç que dues de nivell 1.

4. **Reserva or per a les onades tardanes.** Les onades 7, 8, 9 i 10 porten enemics molt resistents. Si gastes tot l'or a les primeres onades, no podràs fer front a les darreres.

5. **Usa Torres Màgiques per als tancs.** Els enemics de tipus tanc tenen molta vida i el dany per atac de la Torre Màgica és molt superior al de la Torre Bàsica.

6. **Si una torre no és útil en la seva posició, ven-la i reconstrueix-la en un millor lloc.** Perds la meitat del que has invertit, però una torre ben posicionada val molt més que una torre mal posicionada.

7. **Vigila la barra de vida de la base.** Si veus que la base ja ha perdut la meitat de la vida, centra't en reforçar les torres prop del final del camí.
