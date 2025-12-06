% https://docs.google.com/document/d/12zUNFV4K7Iofc47FN-b7O-gXjTrqgP4dQh47yJVlvw0/edit?tab=t.0

% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).

% Punto 1 --> Indicar si el predicado controla/2 es inversible


% controla(Controlador, Controlado)

/*
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- prisionero(Otro,_), not(controla(Otro, Guardia)).
*/
% No es inversible porque si consultamos controla(X, alex). No podemos saber todos los que controlan a alex, ya que el tercer caso depende de que no haya una relación previa de control entre el prisionero y el guardia.

% Para que sea inversible deberiamos:
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- 
    prisionero(Otro,_),
    guardia(Guardia), 
    not(controla(Otro, Guardia)).

% Punto 2 --> conflictoDeIntereses/2: relaciona a dos personas distintas (ya sean guardias o prisioneros) si no se controlan mutuamente y existe algún tercero al cual ambos controlan.

conflictoDeIntereses(Persona1, Persona2):-
    controla(Persona1, Tercero),
    controla(Persona2, Tercero),
    not(controla(Persona1, Persona2)),
    not(controla(Persona2, Persona1)),
    Persona1 \= Persona2.

% Punto 3 --> peligroso/1
% Se cumple para un preso que sólo cometió crimenes graves :
% Un robo nunca es grave
% Un homicidio es siempre grave
% Un delito de narcotráfico es grave si incluye al menos 5 drogas a la vez, o incluye metanfetaminas.

peligroso(Prisionero):-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), esGrave(Crimen)).

esGrave(homicidio(_)).
esGrave(narcotrafico(Drogas)):-
    length(Drogas, CantidadDrogas),
    CantidadDrogas >= 5.
esGrave(narcotrafico(Drogas)):-
    member(metanfetaminas, Drogas).


% Punto 4 --> ladronDeGuanteBlanco/1
% Aplica a un prisionero si solo cometió robos y todos fueron por mas de 100000.
ladronDeGuanteBlanco(Prisionero):-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), (monto(Crimen, Monto) , Monto > 100000)).
    

monto(robo(Monto), Monto).

% Punto 5 --> condena/2
% Relaciona a un prisionero con la cantidad total de años de condena que debe cumplir.
% - La cantidad de dinero robado dividido 10000
% - 7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
% - 2 años por cada droga que haya traficado.   

condena(Prisionero, Condena) :-
    prisionero(Prisionero, _),
    findall(Pena, (prisionero(Prisionero, Crimen), pena(Crimen, Pena)), Penas),
    sumlist(Penas, Condena).

pena(robo(Monto), Pena) :-
    Pena is Monto / 10000.

pena(homicidio(Victima), 9) :-   
    guardia(Victima).

pena(homicidio(Victima), 7) :-   
    not(guardia(Victima)).

pena(narcotrafico(Drogas), Pena) :-
    length(Drogas, CantidadDrogas),
    Pena is CantidadDrogas * 2.

% Punto 6 --> capo/1
% Se dice que un preso es el capo de todos los capos cuando nadie lo controla, pero todas las personas de la carcel (guardias y prisioneros) son controlados por él, o por alguien a quien él controla (directa o indirectamente).

capo(Capo) :-
    prisionero(Capo, _),
    not(controla(_, Capo)),
    forall((persona(Persona), Capo \= Persona), controlaDirectaOIndirectamente(Capo, Persona)).

controlaDirectaOIndirectamente(Capo, Otro) :-
    controla(Capo, Otro).

controlaDirectaOIndirectamente(Capo, Otro) :-
    controla(Capo, Intermedio),
    controlaDirectaOIndirectamente(Intermedio, Otro).

persona(Persona) :-
    prisionero(Persona, _).

persona(Persona) :-
    guardia(Persona).