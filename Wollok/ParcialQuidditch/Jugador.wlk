import Escoba.*
import MercadoEscobas.*
class Jugador{
    var peso
    var skills
    var escoba
    var punteria
    var fuerza
    var vision
    var reflejos
    var equipo

    method nivelManejoEscoba() = skills / peso 

    method velocidad() = self.nivelManejoEscoba() * escoba.velocidad()

    method habilidad() = self.velocidad() + skills + self.habilidadPosicion()

    method habilidadPosicion() 

    method lePasaElTrap(jugador) = jugador.habilidad() * 2 < self.habilidad()

    method esGroso() = self.esMuyHabilidoso() and self.esMuyVeloz()  

    method esMuyHabilidoso() = self.habilidad() > equipo.habilidadPromedio()

    method esMuyVeloz() = self.velocidad() > mercadoEscobas.valor() 
}

class Cazador inherits Jugador{
    override method habilidadPosicion() = punteria * fuerza
}

class Guardian inherits Jugador{
    override method habilidadPosicion() = reflejos + fuerza
}

class Golpeador inherits Jugador{
    override method habilidadPosicion() = punteria + fuerza
}

class Buscador inherits Jugador{
    override method habilidadPosicion() = reflejos * vision
}






/* una opción más - Punto 1C - Composición - (si jugador cambiase de posición)
dentro clase jugador: 
var posicion
method habilidad() = self.velocidad() + skills + posicion.habilidadPosicion(self)

class Cazador {
     method habilidadPosicion(jugador) = jugador.punteria() * jugador.fuerza()
}

class Guardian {
     method habilidadPosicion(jugador) = jugador.reflejos() + jugador.fuerza()
}

class Golpeador {
     method habilidadPosicion(jugador) = jugador.punteria() + jugador.fuerza()
}

class Buscador {
     method habilidadPosicion(jugador) = jugador.reflejos() * jugador.vision()
}


*/
/*otra opcion - Punto 1C

dentro clase jugador: method habilidad() = self.velocidad() + skills 
class Cazador inherits Jugador{
    override method habilidad() = super() + punteria * fuerza
}

class Guardian inherits Jugador{
    override method habilidad() = super() + reflejos + fuerza
}

class Golpeador inherits Jugador{
    override method habilidad() = super() + punteria + fuerza
}

class Buscador inherits Jugador{
    override method habilidad() = super() + reflejos * vision
}*/