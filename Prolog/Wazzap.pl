/* Un grupo de docentes de PdeP quiere analizar su comunicación usando Whatsapp. Los mensajes que se envian pueden ser a otra persiba directamente o a un grupo al cual pertenecen. */

% Base de conocimiento
% grupo(nombreDelGrupo, participantes)
grupo(socrates, [alf, gus, ana, florr, fer, dani, nahue]).
grupo(regaloParaAlf, [ana, gus, dani, florr, fer, nahue, nico]).

% Los mensajes pueden ser fotos, de texto o de voz y están modelados con functores
% foto(nombreDelArchivo, epigrafe)
% texto(texto, emojis)
% voz(loQueDijo, longitud)

% mensaje(enviadoPor, conversacion, mensaje, momentoDeEnvio)
mensaje(gus, socrates, foto("fotoDeLosAyudantesMasSexiesEnTraje.jpg", "Alto casorio pegamos!"), fecha(29, 11, 2014, 20, 33)).
mensaje(nahue, entre(nahue,gus), texto("Hoy comemos en el roll?", []), fecha(10, 12, 2014, 12, 10)).
mensaje(nahue, socrates, voz("Essssa! Cuánta facha!!!!", 5), fecha(29, 11, 2014, 21, 20)).
mensaje(nahue, entre(nahue,gus), texto("", [smile]), fecha(10, 12, 2014, 12, 17)).
mensaje(gus, entre(nahue,gus), texto("Seeeee", [like, like, like]), fecha(10, 12, 2014, 12, 15)).

conexion(nahue, fecha(10, 12, 2014, 12, 10)).
conexion(gus, fecha(10, 12, 2014, 12, 15)).
conexion(nahue, fecha(10, 12, 2014, 12, 16)).

% Además de los predicados anteriores se cuenta con un predicado no inversible posterior/2 que relaciona dos functores fecha/5 siendo la primera posterior a la segunda. 

% Se cumple cuando la primera fecha es posterior a la segunda
posterior(FechaPosterior, FechaAnterior):-
    timestamp(FechaPosterior, TPosterior),
    timestamp(FechaAnterior, TAnterior),
    TPosterior >= TAnterior.
% timestamp es un predicado auxiliar, no hay que usarlo en el parcial:
timestamp(fecha(Dia,Mes,Anio,Hora,Minuto), Timestamp):-
    Timestamp is Minuto + Hora * 100 + Dia * 10000 + Mes * 1000000 + Anio * 100000000.

% Desarrollar los siguientes predicados de modo que sean totalmente inversibles.

/* 1) Saber si una persona recibió un mensaje de otra persona, lo cual se cumple si se lo mandaron directamente (porque era una conversación entre él y el que lo envió) o a un grupo del cual forma parte, si no fue quien lo envió.

?- recibio(nahue, Mensaje)
Mensaje = foto("fotoDeLosAyudantesMasSexiesEnTraje.jpg", "Alto casorio pegamos!");
Mensaje = texto("Seeeee", [like, like, like]);
No.
*/
recibio(Persona, Mensaje) :-
    mensaje(_, entre(Persona, _), Mensaje, _).

recibio(Persona, Mensaje) :-
    mensaje(_, entre(_, Persona), Mensaje, _).

recibio(Persona, Mensaje) :-
    mensaje(_, Grupo, Mensaje, _),
    grupo(Grupo, Participantes),
    member(Persona, Participantes).
/*
2) Saber si una persona vió un mensaje, que es cierto si lo recibió y se conectó luego del momento en el que se mandó ese mensaje.

?- vio(alf, voz("Essssa! Cuánta facha!!!!", 5)).
No
?- vio(nahue, texto("Seeeee", [like, like, like])).
Yes
*/
vio(Persona, Mensaje) :-
    mensaje(_, _, Mensaje, FechaMensaje),
    recibio(Persona, Mensaje),
    conexion(Persona, FechaConexion),
    posterior(FechaConexion, FechaMensaje).

/*
3) Saber si alguien fue dejado afuera de un grupo. Esto sucede cuando no es miembro de ese grupo y existe otro grupo en el que si está con todos los otros integrantes del que fue excibido.

?- fueDejadoAfuera(Persona, Grupo)
Persona = alf    Grupo = regaloParaAlf.
*/
/*fueDejadoAfuera(Persona, Grupo) :-
    loDejaronAfuera(Grupo, Participantes),
    not(member(Persona, OtrosParticipantes)),
    forall((member(Persona, Participantes), member(Persona, OtrosParticipantes))).

loDejaronAfuera(Grupo, Participantes) :-
    grupo(Grupo, Participantes),
    grupo(OtroGrupo, Participantes),
    Grupo \= OtroGrupo.
*/
fueDejadoAfuera(Persona, Grupo):-
    grupo(Grupo, Participantes),
    grupo(OtroGrupo, OtrosParticipantes),
    OtroGrupo \= Grupo,
    not(member(Persona, OtrosParticipantes)),
    forall(member(Persona, Participantes), member(Persona, OtrosParticipantes)).

/*
4) Saber si alguien es vago. Los vagos sólo mandan mensajes fáciles de mandar, ya sea:

> fotos sin epigrafe,
> mensajes de texto de menos de 25 caracteres,
> mensajes de texto que sólo tienen emojis y nada de texto,
> mensajes de voz con longitud menor a 10 segundos.

?- vago(Persona)
Persona = nahue
*/

vago(Persona):-
    mensaje(Persona, _, _, _),
    forall(mensaje(Persona, _, Mensaje, _), mensajeFacil(Mensaje)).

mensajeFacil(foto(_, "")).
mensajeFacil(texto(Texto, _)):- 
    string_length(Texto, Longitud), 
    Longitud < 25.
mensajeFacil(texto("", Emojis)) :- 
    Emojis \= [].
mensajeFacil(voz(_, Longitud)) :- 
    Longitud < 10.

/*
5) Saber cuántos bytes pesa una conversación, que puede ser entre dos personas o de un grupo, lo cual se calcula como la sumatorio de lo que pesan sus mensajes.
El texto solo pesa 1 byte por caracter. Los mensajes de texto pesan lo que corresponda por el texto en cuestión más 8 bytes por cada emoticón que se incluya en el mismo, las fotos pesan 10000 bytes más el peso del epigrafe y los mensajes de voz 200 bytes por cada segundo de grabación.

?- pesoDeConversacion(Conversacion, Peso).
Conversacion = entre(nahue, gus)     Peso = 264;
Conversacion = socrates              Peso = 11168;
*/

pesoDeConversacion(Conversacion, Peso):-
    mensaje(_, Conversacion, _, _),
    findall(PesoMensaje, (mensaje(_, Conversacion, Mensaje, _), pesoDeMensaje(Mensaje, PesoMensaje)), Pesos),
    sumlist(Pesos, Peso).

pesoDeMensaje(foto(_, Epigrafe), Peso):-
    string_length(Epigrafe, Longitud),
    Peso is 10000 + Longitud.

pesoDeMensaje(texto(Texto, Emojis), Peso):-
    string_length(Texto, Longitud),
    length(Emojis, CantidadEmojis),
    Peso is Longitud + 8 * CantidadEmojis.

pesoDeMensaje(voz(_, Longitud), Peso):-
    Peso is 200 * Longitud.
