class Equipo{
    var jugadores = []
    var puntos = 0

    method tieneJugadorEstrellaContra(unEquipo) = jugadores.any{jugador => jugador.esEstrellaContra(unEquipo)}

    method lePasaElTrapo(unJugador) = jugadores.all{jugador => jugador.lePasaElTrapo(unJugador)} 

    method jugarContra(unEquipo) = jugadores.forEach{jugador => jugador.jugarContra(unEquipo)} 

    method ganarPuntos(unosPuntos) {
      puntos += unosPuntos
    }

    method bloquearA(unJugador) {
        const bloqueador = jugadores.find{jugador => jugador.puedeBloquearA(unJugador)}
        bloqueador.bloquearA(unJugador)
    }

    method agarrarLaQuaffle() {
      self.cazadorMasRapido().agarrarLaQuaffle()
    }

    method cazadorMasRapido() = self.cazadores().max{cazador => cazador.velocidad()}

    method cazadores() = jugadores.filter{jugador => jugador.esCazador()}

    method blancoUtil() = jugadores.findOrDefault{jugador => jugador.esBlancoUtil()} 

    method tieneLaQuaffle() = self.cazadores().any{cazador => cazador.tieneLaQuaffle()}
}   