import Nave.*

class Tarea{
    const items


    // Se hace eso por repetición de lógica
    method esRealizablePor(jugador){
        return items.all {item => jugador.tieneItem(item)}
    }

    method serRealizadaPor(jugador){
        unJugador.sacarItems(items)
    }
}

object arreglarTableroElectrico inhetits Tarea(items = ["Llave Inglesa"]){

    override method serRealizadaPor(unJugador) { 
		super(unJugador)
		unJugador.aumentarNivelDeSospecha(10)
}
}
object sacarLaBasura inherits Tarea(items = ["Escoba", "Bolsa de consorcio"]){
    

    override method serRealizadaPor(unJugador) {  
		super(unJugador)
		unJugador.disminuirNivelDeSospecha(4)
}
}
object ventilarLaNave inherits Tarea(items = []){
    override method serRealizadaPor(unJugador) {  
		super(unJugador)
		nave.aumentarNivelDeOxigeno(5)
	}
}   