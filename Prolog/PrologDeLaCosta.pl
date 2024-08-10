% --- Punto 1 ----
% Diseñar la base de conocimiento. Incluir los puestos de comida, las atracciones y a los visitantes del grupo Viejitos.
% Base De Conocimiento
% Puestos de Comida
puestosDeComida(hamburguesas, 2000).
puestosDeComida(panchitoConPapas, 1500).
puestosDeComida(lomitoCompleto, 2500).
puestosDeComida(caramelos, 0).

% Atracciones
% Tranquilas
atraccion(autitosChocadores, tranquila(todaLaFamilia)).
atraccion(casaEmbrujada, tranquila(todaLaFamilia)).
atraccion(laberinto, tranquila(todaLaFamilia)).
atraccion(tobogan, tranquila(soloChicos)).
atraccion(calesita, tranquila(soloChicos)).

% Intensas
atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).

% Montañas Rusas
atraccion(abismoMortalRecargada, montaniaRusa(3, 2.14)).
atraccion(paseoPorElBosque, montaniaRusa(0, 0.45)).

% Acuáticas
atraccion(torpedoSalpicon, acuatica).
atraccion(esperoQueHayasTraidoUnaMudaDeRopa, acuatica).

% Visitantes
visitante(eusebio, 80, 3000, viejitos).
visitante(carmela, 80, 0, viejitos).
sentimiento(eusebio, 50, 0).
sentimiento(carmela, 0, 25).
% creados por mi
visitante(pepito, 21, 5000, solo).
sentimiento(pepito, 30, 60).
visitante(fulano, 18, 5000, viejitos).
sentimiento(fulano, 0, 0).
visitante(mengano, 23, 5000, nadie).
sentimiento(mengano, 0, 0).
% Punto 2
/* 
Saber el estado de bienestar de un visitante.
> Si su hambre y aburrimiento son 0, siente felicidad plena.
> Si suman entre 1 y 50, podría estar mejor.
> Si suman entre 51 y 99, necesita entretenerse.
> Si suma 100 o más, se quiere ir a casa.

Hay una excepción para los visitantes que vienen solos al parque: nunca pueden sentir felicidad plena, sino que podrían estar mejor también cuando su hambre y aburrimiento suman 0.
*/
/*estadoDeBienestar(Visitante, Bienestar) :-
    sentimiento(Visitante, Hambre, Aburrimiento),
    Suma is Hambre + Aburrimiento,
    estadoDeBienestarSegun(Suma, Bienestar).

estadoDeBienestarSegun(0, felicidadPlena) :-
     estaAcompaniado(Visitante).
estadoDeBienestarSegun(0, podriaEstarMejor) :-
    not(estaAcompaniado(Visitante)).
estadoDeBienestarSegun(Suma, podriaEstarMejor) :-
    between(1, 50, Suma).
estadoDeBienestarSegun(Suma, necesitaEntretenerse) :-
    between(51, 99, Suma).
estadoDeBienestarSegun(Suma, seQuierenIrACasa) :-
    Suma >= 100.

estaAcompaniado(Visitante) :-
    visitante(Visitante, _, _, Grupo),
    visitante(OtroVisitante, _, _, Grupo),
    Visitante \= OtroVisitante.
*/
estadoDeBienestar(Visitante, Bienestar) :-
    sentimiento(Visitante, Hambre, Aburrimiento),
    Suma is Hambre + Aburrimiento,
    bienestarSegunSuma(Suma, Visitante, Bienestar).

bienestarSegunSuma(0, Visitante, felicidadPlena) :-
    estaAcompaniado(Visitante).
bienestarSegunSuma(0, Visitante, podriaEstarMejor) :-
    not(estaAcompaniado(Visitante)).
bienestarSegunSuma(Suma, _, podriaEstarMejor) :-
    between(1, 50, Suma).
bienestarSegunSuma(Suma, _, necesitaEntretenerse) :-
    between(51, 99, Suma).
bienestarSegunSuma(Suma, _, seQuierenIrACasa) :-
    Suma >= 100.

estaAcompaniado(Visitante) :-
    visitante(Visitante, _, _, Grupo),
    visitante(OtroVisitante, _, _, Grupo),
    Visitante \= OtroVisitante.

% Punto 3
% Saber si un grupo familiar puede satisfacer su hambre con cierta comida. Para que esto ocurra, cada integrante del grupo debe tener dinero suficiente como para comprarse esa comida y esa comida, a la vez, debe poder quitarle el hambre a cada persona. La hamburguesa satisface a quienes tienen menos de 50 de hambre; el panchito con papas sólo le quita el hambre a los chicos; y el lomito completo llena siempre a todo el mundo. Los caramelos son un caso particular: sólo satisfacen a las personas que no tienen dinero suficiente para pagar ninguna otra comida.

puedeSatisfacer(Comida, Grupo) :- 
    grupo(Grupo),
    puestosDeComida(Comida, _),
    forall(visitante(Integrante, _, _, Grupo), puedeComprarYSatisfacer(Comida, Integrante)).

grupo(Grupo) :-
    visitante(Visitante, _, _ , Grupo).

puedeComprarYSatisfacer(Comida, Visitante) :-
    puedeComprar(Comida, Visitante),
    leQuitaHambre(Comida, Visitante).

puedeComprar(Comida, Visitante) :-
    visitante(Visitante, _, Dinero, _).
    puestosDeComida(Comida, Precio),
    Dinero >= Precio.

leQuitaHambre(hamburguesa, Visitante) :-
    sentimiento(Visitante, Hambre, _),
    Hambre < 50.

leQuitaHambre(panchitoConPapas, Visitante) :-
    chico(Visitante).

chico(Visitante):-
    visitante(Visitante, Edad, _, _),
    Edad =< 13.

leQuitaHambre(lomitoCompleto, _).

leQuitaHambre(caramelos, Visitante) :-
    not(puedePagarComida (Visitante)).

puedePagarComida(Visitante) :-
    puedeComprar(Comida, Visitante),
    Comida \= caramelos.

% Punto 4
/* Saber si puede producirse una lluvia de hamburguesas. Esto ocurre para un visitante que puede pagar una hamburguesa y elige una atracción que:
> Es intensa con un coeficiente de lanzamiento mayor a 10, o
> Es una montaña rusa peligrosa, o
> Es el tobogán

La peligrosidad de las montañas rusas depende de la edad del visitante. Para los adultos sólo es peligrosa la montaña rusa con mayor cantidad de giros invertidos en todo el parque, a menos que el visitante necesite entretenerse, en cuyo caso nada le parece peligroso. El criterio cambia para los chicos, donde independientemente de la cantidad de giros invertidos, los recorridos de más de un minuto de duración alcanzan para considerarla peligrosa. */

lluviaDeHamburguesas(Visitante, Atraccion):-



    




    