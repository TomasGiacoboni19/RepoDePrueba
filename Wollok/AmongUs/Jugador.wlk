// https://www.utnianos.com.ar/foro/attachment.php?aid=20213

import Nave.*

class Jugador {
    var nivelDeSospecha =  40
    const mochila = []
    const tareas = []
    var proximoVotoEnBlanco = false
    var estaVivo = true

    
    method esSospechoso() = {
    return nivelDeSospecha > 50
   }
    method buscarItem(item){
        mochila.add(item)
    }

    method completoTodasLasTareas() 


    method aumentarNivelDeSospecha(cantidad){
        nivelDeSospecha += cantidad
    }

    method disminuirNivelDeSospecha(cantidad){
        nivelDeSospecha -= cantidad
    }
    
    method votarEnBlanco() {
		proximoVotoEnBlanco = true
	}

    method llamarReunionDeEmergencia() {
		nave.convocarVotacion()
	}
	
	method estaVivo() {
		return estaVivo
	}

    method expulsar() {
		estaVivo = false
	}

    method tieneMochilaVacia() {
		return mochila.isEmpty()
	}

}

class Tripulante inherits Jugador{
    
    override method completoTodasLasTareas(){
            return tareas.isEmpty()
    }

    override method hacerTarea() {
		const tarea = self.tareaRealizable()
		tarea.serRealizadaPor(self)
		tareas.remove(tarea)
		nave.tareaRealizada()
	}
	
	method tareaRealizable() {
		return tareas.find { tarea => tarea.puedeSerRealizadaPor(self) }
	}

    override method expulsar() {
		super()
		nave.tripulanteExpulsado()
	}
	
	method jugadorVotado() {
		if (proximoVotoEnBlanco) {
			proximoVotoEnBlanco = false
			return votoEnBlanco
		}
		return tipoJugador.jugadorVotado()
	}
}

class Impostor inherits Jugador{
       
    override method completoTodasLasTareas() {
        return True
    }
    override method hacerTarea() {
        // Los impostores no hacen tareas
    }   

    method sabotear(unSabotaje) {
		self.aumentarNivelDeSospecha(5)
		unSabotaje.realizarse()
	}
    override method expulsar() {
		super()
		nave.impostorExpulsado()
	}
	
	method jugadorVotado() {
		return nave.jugadorVivoCualquiera()
	}
	
	method nivelDeSospecha() {
		return nivelDeSospecha
	}
}