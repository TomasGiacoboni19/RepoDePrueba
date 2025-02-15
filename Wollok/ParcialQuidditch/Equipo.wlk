class Equipo{
    var jugadores = []

    method tieneJugadorEstrellaContra(unEquipo) = jugadores.any{jugador => jugador.esEstrellaContra(unEquipo)}

}