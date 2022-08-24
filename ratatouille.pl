:- discontiguous cocinaBien/2.
:- discontiguous caloriasSegunTipo/2.
:- discontiguous criticaPositivaSegunCritico/2.


% Base de conocimiento

viveEn(remy, gusteaus).
viveEn(emile, barMalabar).
viveEn(django, pizzeriaJeSuis).

sabeCocinar(linguini, ratatouille, 3).
sabeCocinar(linguini, sopa, 5).
sabeCocinar(colette, salmonAsado, 9).
sabeCocinar(horst, ensaladaRusa, 8).

trabajaEn(linguini, gusteaus).
trabajaEn(colette, gusteaus).
trabajaEn(horst, gusteaus).
trabajaEn(amelie, cafeDes2Moulins).

% Punto 1.

restaurante(UnRestaurante) :-
  trabajaEn(_, UnRestaurante).

inspeccionSatisfactoria(UnRestaurante) :-
  restaurante(UnRestaurante),
  not(viveEn(_, UnRestaurante)).

% Punto 2.

chef(UnEmpleado, UnRestaurante) :-
  trabajaEn(UnEmpleado, UnRestaurante),
  sabeCocinar(UnEmpleado, _, _).

% Punto 3.

chefcito(UnaRata) :-
  viveEn(UnaRata, UnRestaurante),
  trabajaEn(linguini, UnRestaurante).

% Punto 4.

cocinaBien(UnaPersona, UnPlato) :-
  sabeCocinar(UnaPersona, UnPlato, UnaExperiencia),
  UnaExperiencia > 7.

plato(UnPlato) :-
  sabeCocinar(_, UnPlato, _).

cocinaBien(remy, UnPlato) :-
  plato(UnPlato).

% Punto 5.

encargadoDe(UnEncargado, UnPlato, UnRestaurante) :-
  cocinaEn(UnEncargado, UnPlato, UnRestaurante),
  forall(cocinaEn(OtraPersona, UnPlato, UnRestaurante), cocinaMejor(UnEncargado, OtraPersona, UnPlato)).

cocinaMejor(UnEncargado, OtraPersona, UnPlato) :-
  sabeCocinar(UnEncargado, UnPlato, UnaExperiencia),
  sabeCocinar(OtraPersona, UnPlato, OtraExperiencia),
  UnaExperiencia >= OtraExperiencia.

% Predicado del enunciado

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

% Punto 6.

saludable(UnPlato) :-
  plato(UnPlato, TipoDePlato),
  caloriasSegunTipo(TipoDePlato, UnasCalorias),
  UnasCalorias < 75.

caloriasSegunTipo(entrada(Ingredientes), UnasCalorias) :-
  length(Ingredientes, CantidadDeIngredientes),
  UnasCalorias is CantidadDeIngredientes * 15.

caloriasSegunTipo(principal(UnaGuarnicion, UnosMinutosDeCoccion), UnasCalorias) :-
  caloriasSegunGuarnicion(UnaGuarnicion, CaloriasGuarnicion),
  UnasCalorias is UnosMinutosDeCoccion * 5 + CaloriasGuarnicion.

caloriasSegunGuarnicion(papasFritas, 50).
caloriasSegunGuarnicion(pure, 20).
caloriasSegunGuarnicion(ensalada, 0).

caloriasSegunTipo(postre(UnasCalorias), UnasCalorias).

% Punto 7.

criticaPositiva(UnRestaurante, UnCritico) :-
  inspeccionSatisfactoria(UnRestaurante),
  criticaPositivaSegunCritico(UnRestaurante, UnCritico).

criticaPositivaSegunCritico(UnRestaurante, antonEgo) :-
  esEspecialistaEn(UnRestaurante, ratatouille).

esEspecialistaEn(UnRestaurante, UnPlato) :-
  forall(chef(UnChef, UnRestaurante), cocinaBien(UnChef, UnPlato)).

criticaPositivaSegunCritico(UnRestaurante, christophe) :-
  findall(UnChef, chef(UnChef, UnRestaurante), UnosChefs),
  length(UnosChefs, CantidadDeChefs),
  CantidadDeChefs > 3.

criticaPositivaSegunCritico(UnRestaurante, cormillot) :-
  todosPlatosSaludables(UnRestaurante),
  todasLasEntradasTienenZanahoria(UnRestaurante).

todosPlatosSaludables(UnRestaurante) :-
  forall(seCocinaEn(UnPlato, UnRestaurante), saludable(UnPlato)).

seCocinaEn(UnPlato, UnRestaurante) :-
  cocinaEn(_, UnPlato, UnRestaurante).

cocinaEn(UnEmpleado, UnPlato, UnRestaurante) :-
  trabajaEn(UnEmpleado, UnRestaurante),
  sabeCocinar(UnEmpleado, UnPlato, _).

todasLasEntradasTienenZanahoria(UnRestaurante) :-
  forall(entradaCocinadaEn(UnaEntrada, UnRestaurante), tieneZanahoria(UnaEntrada)).

entradaCocinadaEn(UnaEntrada, UnRestaurante):-
  seCocinaEn(UnaEntrada, UnRestaurante),
  plato(UnaEntrada, entrada(_)).

tieneZanahoria(UnaEntrada) :-
  plato(UnaEntrada, entrada(Ingredientes)),
  member(zanahoria, Ingredientes).

%criticaSegunRamsey(UnRestaurante, ramsey) :-
  