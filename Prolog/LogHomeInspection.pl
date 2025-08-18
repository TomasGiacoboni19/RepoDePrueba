/* Prologpiedades

Queremos modelar las ofertas inmobiliarias para una empresa amiga, para lo cual nos piden implementar en el paradigma lógico los siguientes requerimientos:

Punto 1: Hablar con propiedad

Se pide que agregue a la base de conocimientos la siguiente información

> Juan vive en una casa de 120 metros cuadrados
> Nico vive en un 3 ambientes con 2 baños, al igual que Alf pero Alf tiene un baño solo
> Julián vive en un loft construido en el año 2000
> Vale vive en un 4 ambientes con 1 baño
> Fer vive en una casa de 110 metros cuadrados
> No sabemos dónde vive Felipe
> Rocio se quiere mudar a una casa de 90 metros cuadrados
> Alf, Juan, Nico, Julián viven en Almagro
> Vale y Fer viven en Flores
*/

viveEn(juan, casa(120)).
viveEn(nico, departamento(3,2)).
viveEn(julian, loft(2000)).
viveEn(vale, departamento(4,1)).
viveEn(fer, casa(110)).

vivenEnBarrio(alf, almagro).
vivenEnBarrio(juan, almagro).
vivenEnBarrio(nico, almagro).
vivenEnBarrio(julian, almagro).
vivenEnBarrio(vale, flores).
viveEnBarrio(fer, flores).

/*
Punto 2: Barrio copado, infierno chico

Queremos saber si en un barrio todas las personas viven en propiedades copadas, 

> Una casa de más de 100 metros cuadrados es copada
> Un departamento de más de 3 ambientes es copado
> Un departamento de más de 1 baño es copado
> Un loft construido después del 2015 es copado

El predicado debe ser inversible. Un barrio copado es Flores, porque Fer vive en una casa de 110 m²> 100 y Vale vive en un departamento de 4 ambientes > 3.
*/

barrioCopado(Barrio) :-
    vivenEnBarrio(_, Barrio),
    forall((vivenEnBarrio(Persona, Barrio), viveEn(Persona, Propiedad)), esCopada(Propiedad)).

esCopada(casa(Metros)) :-
    Metros > 100.

esCopada(departamento(Ambientes, _)) :-   
    Ambientes > 3.

esCopada(departamento(_, Banios)) :-
    Banios > 1.

esCopada(loft(Anio)) :-
    Anio > 2015.


/*
Punto 3: Barrio (caro) tal vez

Ahora necesitamos conocer si hay un barrio caro, en el que no hay una casa que sea barata.

> los loft construidos antes del 2005 son baratos
> las casas de menos de 90 metros son baratas
> los departamentos que tienen 1 ó 2 ambientes son baratos

El predicado debe ser inversible. En el ejemplo del punto 1, Flores es un barrio caro porque la casa donde vive Fer tiene más de 90 m² y el departamento de Vale tiene más de 2 ambientes.
*/

barrioCaro(Barrio) :-
    vivenEnBarrio(_, Barrio),
    forall((vivenEnBarrio(Persona, Barrio), viveEn(Persona, Propiedad)), not(esBarata(Propiedad))).

esBarata(loft(Anio)) :-
    Anio < 2005.

esBarata(casa(Metros)) :-
    Metros < 90.

esBarata(departamento(Ambiente, _)):-
    Ambiente =< 2.


/*
Punto 4: Tasa, tasa, tasación de la casa

Tenemos ahora las tasaciones de cada inmueble (eso no invalida el punto 3, la definición de cara no varía): la casa de Juan vale 150.000 u$s, la de Nico 80.000 u$s, la de Alf 75.000 u$s, la de Julián 140.000 u$s, la de Vale 95.000 u$s y la de Fer 60.000 u$s (no saben cómo está).

Queremos saber qué casas podríamos comprar con una determinada cantidad de plata, y cuánta plata nos quedaría. Queremos comprar siempre al menos una propiedad. El predicado debe asumir que la plata es un argumento no inversible (debe venir siempre). Algunos ejemplos: si tenemos 250.000 u$s, podríamos...

> comprar la casa de Juan y quedarnos con u$s 100.000
> comprar la casa de Juan y de Nico, y quedarnos con u$s 20.000
> comprar la casa de Juan y de Alf, y quedarnos con u$s 25.000
> comprar la casa de Nico, de Alf y de Fer, y quedarnos con u$s 35.000

etc.

Tip: se puede usar el predicado sublista

sublista([],[])

sublista([_|Cola], Sublista):-sublista(Cola, Sublista). sublista([Cabeza|Cola], [Cabeza|Sublista]):-sublista(Cola, Sublista).
*/

