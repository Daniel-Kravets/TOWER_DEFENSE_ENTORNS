# 1. Introducció

En aquesta fase s’han realitzat proves funcionals del prototip per comprovar que les mecàniques bàsiques implementades funcionen correctament. Les proves s’han centrat en l’arrencada del joc, la interacció amb l’usuari, la generació d’enemics i el sistema bàsic d’atac de les torres.

També s’han detectat incidències reals durant l’execució i s’han aplicat ajustos o solucions per millorar l’estabilitat del prototip.

# 2. Casos de prova

## Prova 1
- **Objectiu:** Comprovar que el joc arrenca correctament.
- **Entrada:** Executar el projecte amb LÖVE2D.
- **Resultat esperat:** S’obre la finestra del joc sense errors crítics i es mostra l’escena inicial.
- **Resultat obtingut:** El joc s’ha executat correctament amb LÖVE2D. La finestra s’ha obert sense errors crítics i s’ha mostrat l’escena inicial del prototip.

## Prova 2
- **Objectiu:** Comprovar que es pot construir una torre en un punt de construcció lliure.
- **Entrada:** Fer clic amb el ratolí sobre un slot buit.
- **Resultat esperat:** Es crea una torre en la posició indicada i el slot queda ocupat.
- **Resultat obtingut:** La prova s’ha executat correctament. En fer clic sobre un punt de construcció lliure, s’ha creat una torre en la posició indicada i a la consola ha aparegut el missatge `Torre construida en: 220 180`. També s’ha pogut repetir l’acció en un altre punt de construcció, amb el missatge `Torre construida en: 420 320`.

## Prova 3
- **Objectiu:** Comprovar que no es poden construir dues torres al mateix slot.
- **Entrada:** Fer dos clics seguits sobre el mateix slot.
- **Resultat esperat:** Només es construeix una torre i no es duplica la construcció.
- **Resultat obtingut:** La prova s’ha executat correctament. En fer un segon clic sobre el mateix slot, no s’ha creat cap torre nova ni s’ha eliminat la torre existent. A més, a la consola no ha aparegut un segon missatge de construcció per al mateix punt.

## Prova 4
- **Objectiu:** Comprovar la generació i el moviment dels enemics.
- **Entrada:** Deixar el joc en execució durant uns segons.
- **Resultat esperat:** Els enemics apareixen automàticament i avancen pel camí.
- **Resultat obtingut:** La prova s’ha executat correctament. Els enemics s’han generat automàticament durant la partida i s’han desplaçat en línia recta pel camí principal. A la consola han aparegut missatges com `Enemigo generado`, i també s’ha pogut observar que alguns enemics perdien vida si entraven dins del rang d’una torre, mentre que altres sortien del mapa quan arribaven al final del recorregut.

## Prova 5
- **Objectiu:** Comprovar l’atac automàtic de les torres.
- **Entrada:** Construir una torre prop del camí i esperar que un enemic entri dins del seu rang.
- **Resultat esperat:** La torre detecta l’enemic, li resta vida i l’elimina quan la vida arriba a zero.
- **Resultat obtingut:** La prova s’ha executat correctament. La torre ha atacat automàticament els enemics que han entrat dins del seu rang. A la consola han aparegut missatges com `Enemigo atacado. Vida restante: ...` i `Enemigo eliminado`, confirmant que els enemics perdien vida progressivament fins a desaparèixer.

# 3. Resultats generals de les proves

Les proves executades han permès verificar que el prototip és funcional i que el nucli principal del bucle de joc ja està implementat. El joc arrenca correctament, permet construir torres, genera enemics en moviment i executa atacs automàtics dins del rang establert.

Els resultats obtinguts han estat coherents amb el comportament esperat en la majoria de casos. També s’ha observat, a través de la consola, que la lògica interna del joc s’executa correctament: els enemics es generen, les torres es construeixen, els enemics reben dany i s’eliminen quan la seva vida arriba a zero.

Tot i això, durant les proves també s’han detectat alguns comportaments millorables propis d’un prototip inicial, especialment relacionats amb el fet que alguns enemics arriben al final del recorregut i simplement surten del mapa, i amb la manca de límits en la generació continuada d’enemics.

# 4. Incidències detectades

## Incidència 1
- **Descripció:** Durant les proves s’ha observat que alguns enemics arriben al final del recorregut i simplement desapareixen del mapa.
- **Causa probable:** El prototip actual elimina els enemics quan surten per la part dreta de la pantalla, però encara no s’ha implementat un sistema de vida de base o penalització quan un enemic arriba al final del camí.
- **Solució aplicada:** S’ha identificat aquest comportament com una limitació tècnica del prototip actual i s’ha documentat com a millora necessària per a fases posteriors. De moment, s’ha mantingut la traça `Enemigo salido del mapa` per detectar clarament quan passa aquesta situació.

## Incidència 2
- **Descripció:** Durant les proves s’ha observat que els enemics es continuen generant de manera indefinida mentre la partida està en execució.
- **Causa probable:** El prototip actual utilitza un temporitzador que genera enemics cada cert temps, però encara no existeix un sistema d’onades amb límit, pausa o condició de finalització.
- **Solució aplicada:** S’ha mantingut aquesta generació contínua per poder provar millor el moviment i l’atac automàtic de les torres, però s’ha identificat com un comportament provisional. Aquesta incidència s’ha documentat per substituir-la més endavant per un sistema d’onades controlat.

# 5. Evidència de depuració

Durant la fase de depuració s’han utilitzat missatges de consola amb `print()` per comprovar el comportament intern del prototip en temps real. Aquesta tècnica ha permès verificar que les accions principals del joc s’executaven correctament i en l’ordre esperat.

Els missatges observats a la consola han servit per confirmar:
- la generació automàtica d’enemics
- la construcció de torres en punts vàlids
- l’aplicació de dany als enemics dins del rang de les torres
- l’eliminació d’enemics quan la seva vida arribava a zero
- la sortida d’enemics del mapa quan arribaven al final del recorregut

Alguns exemples de traces reals utilitzades durant la depuració han estat:
- `Enemigo generado`
- `Torre construida en: 220 180`
- `Enemigo atacado. Vida restante: 2`
- `Enemigo eliminado`
- `Enemigo salido del mapa`

Aquestes traces han estat útils per comprovar que la lògica bàsica del joc funcionava correctament i per detectar incidències reals durant les proves.