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

    method lePasaElTrapo(unJugador) = unJugador.habilidad() * 2 < self.habilidad()

    method esGroso() = self.esMuyHabilidoso() and self.esMuyVeloz()  

    method esMuyHabilidoso() = self.habilidad() > equipo.habilidadPromedio()

    method esMuyVeloz() = self.velocidad() > mercadoEscobas.valor() 

    method esEstrellaContra(unEquipo) = unEquipo.lePasaElTrapo(self) 

    method aumentarSkills(unaCantidad) {
      skills += unaCantidad
    }

    method disminuirSkills(unaCantidad) {
      skills -= unaCantidad
    }

    method esCazador() = false 

    method bloquearA(unJugador) {
        unJugador.disminuirSkills(2)
        self.aumentarSkills(10)
    }

    method esGolpeadoPorUnaBludgerDe(_unEquipo) {
      self.disminuirSkills(2)
      escoba.recibirGolpe()
    } 
}

class Cazador inherits Jugador{
    //solo porque la quaffle la tiene siempre el cazador
    var tieneLaQuaffle = false
    
    method tieneLaQuaffle() = tieneLaQuaffle 

    override method habilidadPosicion() = punteria * fuerza

    override method esCazador() = true 

    method jugarContra(unEquipo) {
        if(tieneLaQuaffle){
            self.intentarMeterGol(unEquipo)
        }
    }
    method intentarMeterGol(unEquipo) {
        if(unEquipo.puedeBloquearA(self)){
            unEquipo.bloquearA(self)
        } else{
            self.meterGol()
        }
        self.perderLaQuaffleContra(unEquipo)
    } 

    method meterGol(){
        equipo.ganarPuntos(10)
        self.aumentarSkills(5)
    }

    method perderLaQuaffleContra(unEquipo) {
        tieneLaQuaffle = false
        unEquipo.agarrarLaQuaffle()        
    }

    method agarrarLaQuaffle() {
      tieneLaQuaffle = true
    }

    method puedeBloquearA(unCazador) = self.lePasaElTrapo(unCazador) 

    method esBlancoUtil() = tieneLaQuaffle 

    override method esGolpeadoPorUnaBludgerDe(unEquipo) {
      super(unEquipo)
      self.perderLaQuaffleContra(unEquipo)
    }
}

class Guardian inherits Jugador{
    override method habilidadPosicion() = reflejos + fuerza

    method jugarContra(unEquipo) {
        //No hace nada
    } 

    method puedeBloquearA(unCazador) = (1..3).anyOne() == 3

    method esBlancoUtil() = not equipo.tieneLaQuaffle()
}

class Golpeador inherits Jugador{
    override method habilidadPosicion() = punteria + fuerza

    method jugarContra(unEquipo) {
        const blanco = unEquipo.blancoUtil() 
        if(self.puedeGolpear(blanco)){
            blanco.esGolpeadoPorUnaBludgerDe(equipo)
        }
    }
    method puedeGolpear(unJugador) = punteria > unJugador.reflejos() or (1..10).anyone() >= 8

    method puedeBloquearA(_unCazador) = self.esGroso()

    method esBlancoUtil() = false
}

class Buscador inherits Jugador{
    var estadoDeJuego = new BuscandoLaSnitch()
    
    override method habilidadPosicion() = reflejos * vision

    method jugarContra(unEquipo) {
        estadoDeJuego.hacerQueJuegue(self)
    }

    method perseguirSnitch() {
      estadoDeJuego = new PerseguirSnitch()
    }

    method buscarSnitch() {
      estadoDeJuego = new BuscandoLaSnitch()
    }

    method agarrarSnitch() {
        self.aumentarSkills(10)
        self.aumentarSkills(150)
    }

    method puedeBloquearA(_unCazador) = false

    method esBlancoUtil() = estadoDeJuego.esBlancoUtil()

    override method esGolpeadoPorUnaBludgerDe(unEquipo) {
      //bonus - Punto 5
      if(self.esGroso()){
        self.aturdirse()
      }else {
      self.buscarSnitch()
      }
    }
    method aturdirse(){
        estadoDeJuego = new Aturdido(estadoActual = estadoDeJuego)
    }
}

class BuscandoLaSnitch{
    var turnos = 0

    method hacerQueJuegue(unJugador) {
      turnos ++
      if(self.encontroLaSnitch(unJugador)){
        unJugador.perseguirSnitch()
      }
    }

    method encontroLaSnitch(unJugador) = (1..1000).anyOne() < unJugador.habilidad() + turnos 

    method esBlancoUtil() = true
}

class PerseguirSnitch{
    var kilometrosRecorridos = 0

    method hacerQueJuegue(unJugador) {
        self.recorrerKilometros(unJugador)
        if(kilometrosRecorridos >= 5000){
            unJugador.agarrarSnitch( )
        }
    }
    method recorrerKilometros(unJugador) {
      kilometrosRecorridos += unJugador.velocidad() / 1.6
    }

    method esBlancoUtil() = kilometrosRecorridos > 4000
}

class Aturdido{
    const estadoActual
    var pasoUnTurnoAturdido = false

    method hacerQueJuegue(unJugador){
        if(pasoUnTurnoAturdido){
            unJugador.estadoDeJuego(estadoActual) //poner property en el estadoDeJuego del buscador
        }
        pasoUnTurnoAturdido = true
    }
    method esBlancoUtil() = estadoActual.esBlancoUtil() 
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