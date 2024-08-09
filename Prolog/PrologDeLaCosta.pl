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

% Punto 2
/* 
Saber el estado de bienestar de un visitante.
> Si su hambre y aburrimiento son 0, siente felicidad plena.
> Si suman entre 1 y 50, podría estar mejor.
> Si suman entre 51 y 99, necesita entretenerse.
> Si suma 100 o más, se quiere ir a casa.

Hay una excepción para los visitantes que vienen solos al parque: nunca pueden sentir felicidad plena, sino que podrían estar mejor también cuando su hambre y aburrimiento suman 0.
*/
estadoDeBienestar(Visitante, Bienestar) :-
    sentimiento(Visitante, Hambre, Aburrimiento),
    Suma is Hambre + Aburrimiento,
    estadoDeBienestarSegun(Suma, Bienestar).

estadoDeBienestarSegun(0, felicidadPlena) :-
     estaAcompaniado(visitante).
estadoDeBienestarSegun(0, felicidadPlena) :-
    not(estaAcompaniado(visitante)).
estadoDeBienestarSegun(Suma, podriaEstarMejor) :-
    between(Suma, 1, 50).
estadoDeBienestarSegun(Suma, necesitaEntretenerse) :-
    between(Suma, 51, 99).
estadoDeBienestarSegun(Suma, seQuierenIrACasa) :-
    suma >= 100.

estaAcompaniado(Visitante) :-
    visitante(Visitante, _, _, Grupo),
    visitante(OtroVisitante, _, _, Grupo),
    Visitante \= OtroVisitante.


  
    