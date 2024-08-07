/*
"Agua, tierra, fuego, aire. Hace muchos años, las cuatro naciones vivían en armonía, pero todo cambió cuando la Nación del Fuego atacó. Solo el Avatar, maestro de los cuatro elementos, podía detenerlos. Pero cuando el mundo más lo necesitaba, desapareció. Después de cien años, mi hermano y yo encontramos al nuevo Avatar, un maestro aire llamado Aang. Aunque sus habilidades para controlar el aire eran grandiosas, tenía mucho que aprender antes de poder salvar al mundo. Y yo creo que Aang podrá salvarnos..."
Si te suenan estas palabras es porque probablemente hayas visto "Avatar: la Leyenda de Aang", pero si nunca viste este programa ¡no hay problema! Toda la información que necesites va a estar en el enunciado. Nos llamaron para programar un videojuego sobre esta popular serie y para ello contamos con una base de conocimiento de la cual hicimos una reducción:
*/

% esPersonaje/1 nos permite saber qué personajes tendrá el juego
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes
esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado
elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).

% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)
visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).

% A partir de estos hechos, nos pidieron lo siguiente:

% 1. saber qué personaje esElAvatar. El avatar es aquel personaje que controla todos los elementos básicos.

esElAvatar(Personaje):-
    esPersonaje(Personaje),
    forall(esElementoBasico(Elemento), controla(Personaje, Elemento)).


/*2. clasificar a los personajes en 3 grupos:
> un personaje noEsMaestro si no controla ningún elemento, ni básico ni avanzado;
> un personaje esMaestroPrincipiante si controla algún elemento básico pero ninguno avanzado; 
> un personaje esMaestroAvanzado si controla algún elemento avanzado. Es importante destacar que el avatar también es un maestro avanzado.*/
clasificacion(UnPersonaje, UnaClasificacion) :-
  esPersonaje(UnPersonaje),
  clasificacionPersonaje(UnPersonaje, UnaClasificacion).

clasificacionPersonaje(UnPersonaje, noEsMaestro) :-
  not(controla(UnPersonaje, _)).

clasificacionPersonaje(UnPersonaje, esMaestroPrincipiante) :-
  controla(UnPersonaje, _),
  not(controlaElementoAvanzado(UnPersonaje)).

controlaElementoAvanzado(UnPersonaje) :-
  controla(UnPersonaje, UnElemento),
  elementoAvanzadoDe(_, UnElemento).

clasificacionPersonaje(UnPersonaje, esMaestroAvanzado) :-
  controlaElementoAvanzado(UnPersonaje).

clasificacionPersonaje(UnPersonaje, esMaestroAvanzado) :-
  esElAvatar(UnPersonaje).


/*3. saber si un personaje sigueA otro. Diremos que esto sucede si el segundo visitó todos los lugares que visitó el primero. También sabemos que zuko sigue a aang. */
sigueA(Personaje, OtroPersonaje) :-
    esPersonaje(Personaje),
    esPersonaje(OtroPersonaje),
    Personaje \= OtroPersonaje,
    forall(visito(Personaje, Lugar), visito(OtroPersonaje, Lugar)).

sigueA(aang, zuko).


/*4. conocer si un lugar esDignoDeConocer, para lo que sabemos que:
> todos los templos aire son dignos de conocer;
> la tribu agua del norte es digna de conocer;
> ningún lugar de la nación del fuego es digno de ser conocido;
> un lugar del reino tierra es digno de conocer si no tiene muros en su estructura. */
esDignoDeConocer(Lugar) :-
  lugar(Lugar),
  esDignoDeConocerSegunTipo(Lugar).

lugar(Lugar) :-
  visito(_, Lugar).

esDignoDeConocerSegunTipo(temploAire(_)).
esDignoDeConocerSegunTipo(tribuAgua(norte)).
esDignoDeConocerSegunTipo(reinoTierra(_, Estructura)) :-
  not(member(muro, Estructura)).
/*5. definir si un lugar esPopular, lo cual sucede cuando fue visitado por más de 4 personajes. */
esPopular(Lugar):-
  lugar(Lugar),
  findall(Personaje, visito(Personaje, Lugar), PersonajesQueVisitaron),
  length(PersonajesQueVisitaron, Cantidad),
  Cantidad > 4.

/*6. Por último nos pidieron modelar la siguiente información en nuestra base de conocimientos sobre algunos personajes desbloqueables en el juego:
> bumi es un personaje que controla el elemento tierra y visitó Ba Sing Se en el reino Tierra;
> suki es un personaje que no controla ningún elemento y que visitó una prisión de máxima seguridad en la nación del fuego protegida por 200 soldados. 

Recordá que los predicados deben ser totalmente inversibles. */
esPersonaje(bumi).
controla(bumi, tierra).
visito(bumi, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).

esPersonaje(suki).
visito(suki, nacionDelFuego(prisionMaximaSeguridad, 200)).