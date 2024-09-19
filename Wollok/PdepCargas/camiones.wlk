object verdurin {
  var cantidadDeCajones = 10
  const pesoCajon = 50
  var kilometraje  = 700000

  method cantidadDeCajones(unaCantidad) {
    cantidadDeCajones = unaCantidad
  }

  method pesoDeCarga() = cantidadDeCajones * pesoCajon

  method velocidadMaxima() = 80 - self.pesoDeCarga() / 500

  method recorrerRuta(distancia, velocidad) {
    kilometraje += distancia
  }
}

object scanion5000 {
  const capacidadCombustible = 5000
  var densidad = 1

  method densidad(unaDensidad) {
    densidad = unaDensidad
  }

  method velocidadMaxima() = 140

  method pesoDeCarga() {
    return capacidadCombustible * densidad
  }  

  method recorrerRuta(extension, velocidad){
		// no hace nada
	}
}

object cerealitas {
  var nivelDeterioro = 0
  var property pesoCarga = 0 //--- Se puede poner para no tener que generar su getter y setter
  /*var pesoDeCarga
  // se puede definir su 
  //getter
  method carga() {
    return pesoDeCarga
  } 
  //setter
  method carga(unaCarga) {
    pesoDeCarga = unaCarga
  }*/
  
  method velocidadMaxima() {
    if (nivelDeterioro < 10) {
      return 40
    } else {
      return 60 - nivelDeterioro
    }
  }

  method recorrerRuta(distancia, velocidad){
    nivelDeterioro += 0.max(velocidad - 45)
  }
}