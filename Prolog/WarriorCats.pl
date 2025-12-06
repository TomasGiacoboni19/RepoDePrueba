/* 
Un grupo de escritoras de una saga de libros muy conocida nos contactó para que las ayudemos a armar un sistema que les permita tener conocimiento sobre los gatos y los sucesos que participan en sus libros. Y… ¿cómo podíamos decir que no? ¡Son gatitos! 😻
Si bien nos adelantamos un poquito y ya armamos una base de conocimientos, utilizá todo lo que sepas del paradigma lógico y Prolog para cumplir los requerimientos de las escritoras.
A continuación te dejamos una reducción de la base de conocimientos
*/

% Base de conocimientos
% pertenece(Gato, Clan)
pertenece(estrellaDeFuego, clanDelTrueno).
pertenece(estrellaAzul, clanDelTrueno).
pertenece(tormentaDeArena, clanDelTrueno).

% gato(Gato, EdadEnLunas, EnemigosALosQueVenció)
gato(estrellaDeFuego, 6, [estrellaRota, patasNegras, corazonDeRoble]).

% esDe(Clan, Zona)
esDe(clanDelTrueno, granSicomoro).
esDe(clanDelTrueno, rocasDeLasSerpientes).
esDe(clanDelTrueno, hondonadaArenosa).
esDe(clanDelViento, cuatroArboles).
esDe(clanDelRio, rocasSoleadas).
esDe(clanDeLaSombra, vertedero).

% patrulla(Gato, Zona)
patrulla(estrellaDeFuego, rocasSoleadas).
patrulla(tormentaDeArena, cuatroArboles).

% Posibles presas de los gatos:
% ave(TipoDeAve, AltitudDeVuelo)
% pez(OceanoDondeVive)
% rata(Nombre, Profesión, Altura)

% seEncuentra(Presa, Zona)
seEncuentra(ave(paloma, 5), cuatroArboles).
seEncuentra(ave(quetzal, 15), rocasDeLasSerpientes).
seEncuentra(pez(atlantico), granSicomoro).
seEncuentra(rata(ratatouille, cocinero, 15), cocinaParisina).
seEncuentra(rata(pinky, cientifico, 22), laboratorio).

% esTraidor/1: Un gato es un traidor si alguno de los gatos a los que se enfrentó es de su mismo clan.

esTraidor(Gato) :- 
    gato(Gato, _, Enemigos),
    pertenece(Gato, Clan),
    member(Enemigo, Enemigos),
    pertenece(Enemigo, Clan).

% sePuedenEnfrentar/2: Dos gatos se pueden enfrentar si son de distintos clanes y patrullan la misma zona.

sePuedenEnfrentar(Gato1, Gato2) :- 
    pertenece(Gato1, Clan1),
    pertenece(Gato2, Clan2),
    Clan1 \= Clan2,
    patrulla(Gato1, Zona),
    patrulla(Gato2, Zona).