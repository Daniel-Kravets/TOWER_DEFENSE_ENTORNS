# 1. Títol provisional del joc
Forest Guardians

# 2. Tipus de microvideojoc escollit
Microvideojoc tower defense de fantasia en 2D, amb vista superior i en un mapa molt reduït.

# 3. Objectiu del joc
L’objectiu del joc és defensar un camí o una zona concreta impedint que els enemics arribin al final del recorregut. Per fer-ho, el jugador ha de col·locar defenses de fantasia, com torres, estructures màgiques o criatures defensives, i millorar-les amb els recursos obtinguts durant la partida. La finalitat és superar totes les onades previstes abans que la base perdi tota la seva vida.

# 4. Rol del jugador
El jugador actua com a defensor estratègic d’un petit territori de fantasia. No controla directament un personatge, sinó que gestiona la defensa del mapa col·locant torres o estructures en punts determinats del camí per aturar els enemics.

Durant la partida, el jugador obté recursos en derrotar enemics i els pot invertir en construir noves defenses o millorar les ja existents. El seu paper consisteix a decidir on col·locar cada defensa, quan convé millorar-la i com repartir els recursos disponibles per resistir les diferents onades.

# 5. Regles bàsiques
El joc es desenvolupa en un mapa petit amb un únic camí per on avancen els enemics fins al punt final. El jugador disposa d’una quantitat inicial limitada de recursos per construir defenses en punts concrets del mapa. Aquestes defenses poden ser torres, estructures màgiques o unitats defensives pròpies d’un entorn de fantasia.

Cada defensa ataca automàticament els enemics que entren dins del seu rang. Quan un enemic és derrotat, el jugador rep recursos que pot utilitzar per construir noves defenses o millorar les existents. Les millores augmenten alguna característica bàsica, com ara el dany, la velocitat d’atac o l’abast.

Els enemics apareixen en onades. Si un enemic arriba al final del camí, la base o zona defensada perd vida. La partida continua fins que el jugador supera totes les onades previstes o fins que la vida de la base arriba a zero.

# 6. Condicions de victòria i derrota
La victòria s’aconsegueix quan el jugador supera totes les onades d’enemics previstes sense que la base sigui destruïda.

La derrota es produeix quan la vida de la base arriba a zero perquè massa enemics han aconseguit travessar la defensa i arribar al final del recorregut.

# 7. Bucle principal del joc
El bucle principal del joc consisteix en observar l’arribada de cada onada, col·locar defenses en els punts disponibles, esperar que aquestes ataquin automàticament els enemics, obtenir recursos en derrotar-los i decidir si és millor construir una nova defensa o millorar-ne una d’existent. Aquest procés es repeteix durant tota la partida amb l’objectiu de resistir totes les onades.

# 8. Repte principal i dificultat
El repte principal del joc és gestionar bé els recursos i prendre decisions eficients sobre la col·locació i la millora de les defenses. El jugador haurà de trobar l’equilibri entre expandir la seva defensa i reforçar les estructures ja construïdes per resistir enemics cada vegada més perillosos.

La dificultat prevista serà baixa o mitjana. Ha de ser prou accessible per poder desenvolupar el joc dins del temps disponible, però també prou exigent perquè el jugador hagi de pensar l’estratègia i corregir errors de planificació.

# 9. Limitacions explícites
Per mantenir l’abast del projecte dins del límit aproximat de 10 hores, el joc no inclourà un sistema complex de construcció ni una gran varietat de continguts. De manera explícita, no inclourà:

- diversos mapes o nivells grans
- més de dos tipus de defenses
- més de dos nivells de millora per defensa
- més de dos tipus d’enemics
- heroi controlable directament
- encanteris actius o habilitats especials del jugador
- arbre de millores complex
- història desenvolupada o cinemàtiques
- sistema de guardat de partida
- menús avançats o opcions gràfiques complexes

Aquestes limitacions s’estableixen per garantir que el joc sigui realista, acabable i coherent amb el temps disponible.

# 10. Riscos tècnics
1. **Implementació correcta del camí dels enemics**  
   Un dels riscos principals és aconseguir que els enemics segueixin de manera estable i correcta el recorregut previst, sense errors de moviment ni bloquejos.

2. **Sistema de selecció, construcció i millora de defenses**  
   Pot resultar complicat implementar una interacció clara perquè el jugador pugui col·locar defenses i millorar-les sense problemes d’usabilitat o errors de control.

3. **Equilibri bàsic de la partida**  
   Tot i ser un joc petit, pot ser difícil ajustar correctament el cost de les defenses, la quantitat de recursos i la força de les onades perquè la partida no sigui ni massa fàcil ni impossible.

# 11. Exploració amb IA

## Prompt 1
**Prompt utilitzat:**  
"Proposa 3 idees de microvideojoc de tipus tower defense ambientades en fantasia medieval que es puguin desenvolupar en aproximadament 10 hores. Cada idea ha de tenir un bucle de joc simple, pocs sistemes i un abast molt limitat."

**Resposta resumida:**  
La IA va proposar diverses opcions de tower defense reduïts, com defensar un portal màgic, protegir una zona del bosc amb torres bàsiques i resistir onades d’enemics en un únic camí. La conclusió principal va ser que la idea més viable era un joc amb una sola pantalla, un camí fix, poques defenses i onades curtes.

**Què m’ha aportat:**  
Aquest prompt ha servit per confirmar que el gènere tower defense es podia adaptar a un format micro si es reduïa molt l’abast i s’eliminaven mecàniques complexes.

## Prompt 2
**Prompt utilitzat:**  
"Quines limitacions hauria de posar a un micro tower defense de fantasia perquè sigui viable per a un estudiant en unes 10 hores de desenvolupament? Indica també 3 riscos tècnics habituals."

**Resposta resumida:**  
La IA va recomanar limitar el projecte a un únic mapa, un camí fix, dos tipus de defenses, millores simples, pocs enemics i una interfície mínima. També va destacar com a riscos tècnics el seguiment del camí per part dels enemics, la lògica de selecció i millora de torres i l’equilibri entre recursos, enemics i defenses.

**Què m’ha aportat:**  
Aquest prompt ha estat útil per definir millor l’abast realista del projecte i per identificar riscos concrets abans de començar la fase de desenvolupament.

## Conclusió de l’exploració amb IA
L’exploració amb IA ha servit com a suport per reduir idees massa grans i convertir-les en una proposta concreta, assumible i coherent amb el límit de temps. No s’ha utilitzat per decidir-ho tot automàticament, sinó com a eina de suport per analitzar opcions, riscos i limitacions.

# 12. Proposta final escollida
La proposta final escollida és un microvideojoc tower defense de fantasia, desenvolupat en 2D i amb vista superior. El jugador haurà de defensar un camí utilitzant un nombre reduït de torres o estructures defensives. El joc tindrà un únic mapa petit, un sol recorregut per als enemics, dues defenses diferents com a màxim, millores simples i diverses onades curtes.

L’objectiu serà impedir que els enemics arribin al final del camí abans que la base perdi tota la seva vida.

# 13. Justificació de viabilitat
Aquesta proposta és viable perquè redueix el gènere tower defense a la seva essència: col·locar defenses, frenar enemics i gestionar recursos bàsics. El projecte compleix els requisits mínims perquè té un bucle de joc clar, diversos estats de joc identificables i una idea concreta.

Els estats principals del joc seran la vida de la base, els recursos del jugador, les defenses construïdes i el progrés de les onades. El bucle principal és fàcil d’identificar i es repeteix durant tota la partida: apareixen enemics, les defenses ataquen, el jugador guanya recursos i decideix si construeix o millora.

També és viable perquè s’han definit limitacions explícites que eviten que el projecte creixi massa. En comptes d’intentar fer un tower defense complet, es planteja un prototip funcional i reduït, ajustat al límit aproximat de 10 hores totals.

A més, l’elecció de LÖVE2D com a motor i Lua com a llenguatge ajuda a mantenir el projecte dins d’un entorn tècnic senzill, adequat per a un microvideojoc 2D en vista superior i coherent amb el límit de temps disponible.

# 14. Mini pla de treball

## Fase 1. Definició de la idea i l’abast
Redactar la idea del joc, acotar les mecàniques, definir les limitacions, identificar riscos i justificar la viabilitat del projecte.

## Fase 2. Preparació tècnica del prototip
Crear l’escena inicial, configurar el mapa petit, preparar els objectes bàsics del joc i establir l’estructura general del projecte.

## Fase 3. Implementació de la jugabilitat principal
Programar el moviment dels enemics pel camí, la col·locació de defenses, el sistema d’atac automàtic i la reducció de vida de la base.

## Fase 4. Recursos, millores i condicions de partida
Afegir el sistema de recursos, les millores bàsiques de defenses, les onades i les condicions de victòria i derrota.

## Fase 5. Ajust, proves i poliment mínim
Comprovar errors, ajustar la dificultat, revisar l’equilibri general i afegir petits elements visuals o d’interfície per fer el prototip més clar i jugable.

# 15. Eines previstes i justificació

- **Motor de joc: LÖVE2D**  
  Es farà servir com a motor principal perquè és una eina lleugera, senzilla i molt adequada per crear jocs 2D petits. Com que el projecte serà un microvideojoc en vista superior, LÖVE2D permet implementar la jugabilitat de manera més directa i amb menys complexitat tècnica que altres motors més grans.

- **Llenguatge de programació: Lua**  
  Es farà servir Lua perquè és el llenguatge propi de LÖVE2D i resulta relativament simple i fàcil d’aprendre per a projectes petits. Permet programar la lògica del joc, com el moviment dels enemics, la col·locació de defenses, els atacs automàtics, els recursos i les condicions de victòria o derrota.

- **Tipus de joc i perspectiva: 2D en vista superior**  
  El joc es desenvoluparà en 2D i amb una vista des de dalt, ja que aquest format facilita la lectura del mapa, la col·locació de defenses i el seguiment dels enemics. A més, redueix la dificultat tècnica i encaixa bé amb l’abast limitat del projecte.

- **Editor de codi: Visual Studio Code**  
  Es farà servir Visual Studio Code per escriure i organitzar el codi del projecte. És un editor lleuger, còmode i compatible amb Lua, i permet treballar de manera ordenada amb els fitxers del joc.

- **Markdown per a la documentació**  
  Es farà servir Markdown per redactar i entregar aquesta fase del projecte amb una estructura clara, ordenada i fàcil de revisar.

- **IA generativa com a eina de suport**  
  Es farà servir com a suport per explorar idees, identificar riscos tècnics, revisar decisions de disseny i orientar algunes parts del procés. Tot i això, les respostes s’analitzaran críticament i no s’aplicaran de manera automàtica.

- **Sistema bàsic de còpies de seguretat**  
  Encara que el projecte sigui petit, es guardaran còpies del treball per evitar pèrdues d’informació i mantenir una evolució ordenada del desenvolupament.