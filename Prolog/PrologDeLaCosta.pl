% --- Punto 1 ----
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
estadoDeBienestar(Vistante, Estado) :-
    sentimiento(Visitante, Hambre, Aburrimiento),
    Bienestar is Hambre + Aburrimiento.
    
    