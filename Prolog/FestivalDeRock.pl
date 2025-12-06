% https://docs.google.com/document/d/17rWNL8rdNc-eu7VTuCPgptLhSnRD6FyBZNhYNZ7Hekc/edit?tab=t.0#heading=h.49nyg2mvbd10

% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia], hipódromoSanIsidro).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipódromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).

% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival indicado.
% Los tipos de entrada pueden ser alguno de los siguientes: 
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipódromoSanIsidro, zona1, 1500).

% 1) Itinerante/1: Se cumple para los festivales que ocurren en más de un lugar, pero con el mismo nombre y las mismas bandas en el mismo orden.

itinerante(Festival) :-
    festival(Festival, Bandas, Lugar1),
    festival(Festival, Bandas, Lugar2),
    Lugar1 \= Lugar2.

% 2) careta/1: Decimos que un festival es careta si no tiene campo o si es el personalFest.

careta(Festival) :-
    festival(Festival, _, _),
    not(entradaVendida(Festival, campo)).

careta(personalFest).

% 3) nacAndPop/1: Un festival es nac&pop si no es careta y todas las bandas que tocan en él son de nacionalidad argentina y tienen popularidad mayor a 1000.

nacAndPop(Festival) :-
    festival(Festival, Bandas, _),
    forall(member(Banda, Bandas), (banda(Banda, argentina, Popularidad), Popularidad > 1000)),
    not(careta(Festival)).

banda(littoNebbia, argentina, 5000).
banda(laRenga, argentina, 15000).
banda(bernal, argentina, 800).
banda(pez, argentina, 1200).
    

% 4) sobrevendido/1: Se cumple para los festivales que vendieron más entradas que la capacidad del lugar donde se realizan.
sobrevendido(Festival) :- 
    festival(Festival, _, Lugar),
    lugar(Lugar, Capacidad, _),
    findall(Entrada, entradaVendida(Festival, Entrada), EntradasVendidas),
    length(EntradasVendidas, CantidadVendida),
    CantidadVendida > Capacidad.

% 5) recaudacionTotal/2: Relaciona un festival con el total recaudado con la venta de entradas.
% Cada tipo de entrada se vende a un precio diferente:
% - el precio del campo es el precio base del lugar donde se realiza el festival.
% - la platea general  es el precio base más el plus que se le aplica a la zona.
% - las plateas numeradas salen el triple del precio base para las filas de atrás (>10) y 6 veces para las 10 primeras.
% Nota: No hace falta contemplar si es un festival itinerante.
recaudacionTotal(Festival, RecaudadacionTotal) :-
    festival(Festival, _, Lugar),
    lugar(Lugar, _, PrecioBase),
    findall(Precio, (entradaVendida(Festival, Entrada), precio(Entrada, Lugar, Precio)), Precios),
    sumlist(Precios, RecaudadacionTotal).

precio(campo, Lugar, Precio) :-
    lugar(Lugar, _, Precio).

precio(plateaGeneral(Zona), Lugar, Precio) :-
    lugar(Lugar, _, PrecioBase),
    plusZona(Lugar, Zona, Recargo),
    Precio is PrecioBase + Recargo.

precio(plateaNumerada(Fila), Lugar, Precio) :-
    Fila =< 10,
    lugar(Lugar, _, PrecioBase),
    Precio is PrecioBase * 6.

precio(plateaNumerada(Fila), Lugar, Precio) :-
    Fila > 10,
    lugar(Lugar, _, PrecioBase),
    Precio is PrecioBase * 3.

% 6) delMismoPalo/2: 
% Relaciona dos bandas si tocaron juntas en algún recital o si alguna de ellas tocó con una banda del mismo palo que la otra, pero más popular.

delMismoPalo(UnaBanda, OtraBanda) :-
    tocoCon(UnaBanda, OtraBanda).

delMismoPalo(UnaBanda, OtraBanda) :-
    tocoCon(UnaBanda, TercerBanda),
    esMásPopular(TercerBanda, OtraBanda),
    delMismoPalo(TercerBanda, OtraBanda).

esMásPopular(TercerBanda, OtraBanda) :-
    banda(TercerBanda, _, PopularidadDeTercerBanda),
    banda(OtraBanda, _, PopularidadDeOtraBanda),
    PopularidadDeTercerBanda > PopularidadDeOtraBanda.

tocoCon(UnaBanda, OtraBanda) :-
    festival(_, Bandas, _),
    member(UnaBanda, Bandas),
    member(OtraBanda, Bandas),
    UnaBanda \= OtraBanda. 