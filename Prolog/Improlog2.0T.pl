%% Base de conocimiento %%

%integrante(Grupo, Integrante, Instrumento).
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
%integrante(vientosDelEste, flor, bateria). /* agregado */
integrante(jazzmin, santi, bateria).

%nivelQueTiene(Integrante, Instrumento, NivelDeImprovisacion).
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

%instrumento(Instrumento, Ritmo).
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).


/* Punto 1
Saber si un grupo tiene una buena base, que sucede si hay algún integrante de ese grupo que toque un instrumento rítmico y alguien más que toque un instrumento armónico.
*/

tieneBuenaBase(Grupo) :-
    integrante(Grupo, Integrante, InstrumentoRitmico),
    integrante(Grupo, OtroIntegrante, InstrumentoArmonico),
    Integrante \= OtroIntegrante,
    instrumento(InstrumentoRitmico, ritmico),
    instrumento(InstrumentoArmonico, armonico).


/* Punto 2
Saber si una persona se destaca en un grupo, que se cumple si el nivel con el que toca un instrumento en el grupo en cuestión es al menos dos puntos más del nivel con el que tocan sus instrumentos todos los demás integrantes.
Con los datos actuales, sophie se destacaría en sophieTrio y nadie en vientosDelEste.
 */

seDestaca(Integrante, Grupo) :-
    nivelDelMusico(Integrante, Grupo, NivelDeImprovisacion),
    forall((nivelDelMusico(OtroIntegrante, Grupo, OtroNivelDeImprovisacion), OtroIntegrante \= Integrante), NivelDeImprovisacion >= OtroNivelDeImprovisacion + 2).

nivelDelMusico(Integrante, Grupo, NivelDeImprovisacion) :-
    integrante(Grupo, Integrante, Instrumento),
    nivelQueTiene(Integrante, Instrumento, NivelDeImprovisacion).

/* Punto 3
Incorporar a la base de conocimientos la información sobre los distintos grupos que se están armando mediante un predicado grupo/2 que relacione a un grupo con el tipo de grupo en cuestión. En principio cada grupo puede ser una big band o requerir una formación particular (para las cuales se indicará a su vez cuáles son los instrumentos que requiere para estar completo).
El grupo vientosDelEste es una big band.
El grupo sophieTrio tiene una formación de contrabajo, guitarra y violín.
El grupo jazzmin también tiene una formación particular, en este caso de batería, bajo, trompeta, piano y guitarra.
*/

%grupo(NombreDeGrupo, TipoDeGrupo).
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).

/* Punto 4
Saber si hay cupo para un instrumento en un grupo.
En particular, para los grupos de tipo big band siempre hay cupo para los instrumentos melódicos de viento.
Por otro lado, independientemente del tipo de grupo del que se trate, normalmente se cumple que hay cupo para un instrumento si no hay alguien que ya toque ese mismo instrumento en el grupo, y además el instrumento sirve para el tipo de grupo en cuestión.

Respecto a qué instrumentos sirven:
> si se trata de una formación particular, sirve si es un instrumento de los que se buscaban para esa formación,

> para las big bands, además de los instrumentos de viento, sirven la batería, el bajo y el piano.

*/

hayCupo(Instrumento, Grupo) :-
    grupo(NombreDeGrupo, bigBand),
    esDeViento(Instrumento).

esDeViento(Instrumento) :-
    instrumento(Instrumento, melodico(viento)).

hayCupo(Instrumento, Grupo) :-
    instrumento(Instrumento, _),
    grupo(NombreDeGrupo, TipoDeGrupo),
    sirveInstrumento(TipoDeGrupo, Instrumento),
    not(integrante(Grupo, _ , Instrumento)).

sirveInstrumento(formacion(InstrumentosBuscados), Instrumento) :-
    member(Instrumento, InstrumentosBuscados).

sirveInstrumento(bigBand, bateria).
sirveInstrumento(bigBand, bajo).
sirveInstrumento(bigBand, piano).

/* Punto 5
Saber si una persona puede incorporarse a un grupo y con qué instrumento, que se verifique si la persona no forma parte ya de dicho grupo, además hay cupo para ese instrumento y el nivel que tiene la persona con ese instrumento es mayor o igual al mínimo esperado para el grupo. 

Si se trata de una big band el nivel mínimo es 1, y si se trata de una formación particular será 7 - la cantidad de instrumentos buscados para esa formación.
*/


