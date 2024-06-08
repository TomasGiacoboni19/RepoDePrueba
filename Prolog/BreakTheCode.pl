% Enunciado
% https://docs.google.com/document/d/1WDLJ-qRobQQueVYVads3D_5jkI7l4HNUabATo90z98Y/edit

%---- Punto 1 ----%
fichaValida(ficha(Numero, Color)) :-
    member(Numero, [0,1,2,3,4,6,7,8,9]),
    member(Color, [blanco, negro]).

fichaValida(ficha(5, verde)).   
fichaValida(ficha(5, verde)).

%---- Punto 2 ----%
%---- a ----%
jugador(pirulo, [ficha(8, negro), ficha(5, verde), ficha(0, blanco), ficha(2, negro), ficha(2, blanco)]).

%---- b ----%
conocerSuCodigo(Jugador, Codigo) :-
    jugador(Jugador, Fichas),
    msort(Fichas, Codigo).

%---- c ----%
codigoParaAdversario(Jugador, CodigoAdversario) :-
    ()