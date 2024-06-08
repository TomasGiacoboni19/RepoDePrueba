% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% --- Punto 1 ---
% Definir el predicado esUnAfano/2, que nos dice si al jugar el primero contra el segundo, la diferencia de
% rating entre el primero y el segundo es mayor a 500.

esUnAfano(Jugador1, Jugador2):-
    jugador(Jugador1, Rating1, _),
    jugador(Jugador2, Rating2, _),
    Diferencia is Rating1 - Rating2,
    Diferencia > 500.

% --- Punto 2 ---
% Definir el predicado esEfectivo/2, que relaciona dos unidades si la primera puede ganarle a la otra según
% su categoría, dado por el siguiente piedra, papel o tijeras:
% a) La caballería le gana a la arquería.
% b) La arquería le gana a la infantería.
% c) La infantería le gana a los piqueros.
% d) Los piqueros le ganan a la caballería.
% Por otro lado, los Samuráis son efectivos contra otras unidades únicas (incluidos los samurái).
% Los aldeanos nunca son efectivos contra otras unidades.

esEfectivo(Unidad1, Unidad2):-
    tiene(_, unidad(Tipo, Categoria))
