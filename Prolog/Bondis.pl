%Recorridos en GBA:
%recorrido(linea, zona, calleQueAtraviesa).
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).

% Recorridos en CABA:
%recorrido(linea, zona, calleQueAtraviesa).
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).

% Punto 1
/* Saber si dos líneas pueden combinarse, que se cumple cuando su recorrido pasa por una misma calle dentro de la misma zona.
*/
puedenCombinarse(Linea, OtraLinea):-
    recorrido(Linea, Zona, Calle),
    recorrido(OtraLinea, Zona, Calle),
    Linea \= OtraLinea.

% Punto 2
/* Conocer cuál es la jurisdicción de una línea, que puede ser o bien nacional, que se cumple cuando la misma cruza la General Paz,  o bien provincial, cuando no la cruza. Cuando la jurisdicción es provincial nos interesa conocer de qué provincia se trata, si es de buenosAires (cualquier parte de GBA se considera de esta provincia) o si es de caba.
Se considera que una línea cruza la General Paz cuando parte de su recorrido pasa por una calle de CABA y otra parte por una calle del Gran Buenos Aires (sin importar de qué zona se trate).*/

jurisdiccion(Linea, nacional):-
    cruzaGeneralPaz(Linea).

jurisdiccion(Linea, provincial(Provincia)):-
    recorrido(Linea, Zona, _),
    perteneceA(Zona, Provincia),
    not(cruzaGeneralPaz(Linea)).

cruzaGeneralPaz(Linea):-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_), _).

perteneceA(caba, caba).
perteneceA(gba(_), buenosAires).

% Punto 3 %
/* Saber cuál es la calle más transitada de una zona, que es por la que pasen mayor cantidad de líneas.
*/

calleMasTransitada(Calle, Zona) :-
    cantidadDeLineasQuePasan(Calle, Zona, Cantidad),
    forall((recorrido(_, Zona, OtraCalle), Calle \= OtraCalle), (cantidadDeLineasQuePasan(OtraCalle, Zona, CantidadMenor), Cantidad > CantidadMenor)).

cantidadDeLineasQuePasan(Calle, Zona, Cantidad) :- 
    recorrido(_, Zona, Calle),
    findall(Calle, recorrido(_, Zona, Calle), Calles),
    length(Calles, Cantidad).

% -- A Partir de aca lo copie de la reso
%% Punto 4

calleDeTrasbordo(CalleTrasbordo, Zona):-
    recorrido(_, Zona, CalleTrasbordo),
    forall(recorrido(Linea, Zona, CalleTrasbordo), jurisdiccion(Linea, nacional)),
    cuantasLineasPasan(CalleTrasbordo, Zona, CantidadLineasCalleTrasbordo),
    CantidadLineasCalleTrasbordo >= 3.

%% Punto 5

pasaPorDistintasZonas(Linea):-
    recorrido(Linea, gba(Zona), _),
    recorrido(Linea, gba(OtraZona), _),
    Zona \= OtraZona.

plus(Linea, 50):-
    pasaPorDistintasZonas(Linea).
plus(Linea, 0):-
    not(pasaPorDistintasZonas(Linea)).

valorNormal(Linea, 500):-
    jurisdiccion(Linea, nacional).
valorNormal(Linea, 350):-
    jurisdiccion(Linea, provincial(caba)).
valorNormal(Linea, Valor):-
    jurisdiccion(Linea, provincial(buenosAires)),
    findall(Calle, recorrido(Linea, Calle, _), Calles),
    length(Calles, CantidadCalles),
    plus(Linea, Plus),
    Valor is (25*CantidadCalles) + Plus.

beneficiario(pepito, personalCasaParticular(gba(oeste))).
beneficiario(juanita, estudiantil).
beneficiario(marta, jubilado).
beneficiario(marta, personalCasaParticular(caba)).
beneficiario(marta, personalCasaParticular(gba(sur))).

beneficio(estudiantil, _, 50).
beneficio(personalCasaParticular(Zona), Linea, 0):-
    recorrido(Linea, Zona, _).
beneficio(jubilado, Linea, ValorConBeneficio):-
    valorNormal(Linea, ValorNormal),
    ValorConBeneficio is ValorNormal // 2.

posiblesBeneficios(Persona, Linea, ValorConBeneficio):-
    beneficiario(Persona, Beneficio),
    beneficio(Beneficio, Linea, ValorConBeneficio).

costo(Persona, Linea, CostoFinal):-
    beneficiario(Persona, _),
    recorrido(Linea, _, _),
    posiblesBeneficios(Persona, Linea, CostoFinal),
    forall((posiblesBeneficios(Persona, Linea, OtroValorBeneficiado), OtroValorBeneficiado \= CostoFinal), CostoFinal < OtroValorBeneficiado).

costo(Persona, Linea, ValorNormal):-
   persona(Persona),
   valorNormal(Linea, ValorNormal),
   not(beneficiario(Persona, _)).
   
persona(pepito).
persona(juanita).
persona(tito).
persona(marta).

%% Punto 5 c)

/*Si quisiéramos agregar otro beneficio, sea cual sea, seria fácil de implementar gracias al polimorfismo, debido a que sólo deberíamos agregarlo junto con sus condiciones en el predicado beneficio/1, lo cual no nos genera mucha dificultad, por lo tanto, el agregado de estos no nos cambiaria la solución.
*/