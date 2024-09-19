object manic {
  var estrellas = 0
  var globos = 0

  method encontrarEstrellas() {
    estrellas += 8
  }

  method regalarEstrellas() {
    estrellas = 0.max(estrellas - 1)
  }

  method tieneTodoListo() { 
    return estrellas >= 4 
  }

  method globos() = globos

  method tieneSuficientesGlobos() = globos > 50 

  method comprarGlobos(unaCantidad) {
    globos += unaCantidad
  }
}

object chuy {
  var globos = 0

  method tieneTodoListo() = true 

  method tieneSuficientesGlobos() = globos > 50 

  method comprarGlobos(unaCantidad) {
    globos += unaCantidad
  }
}

object capy {
  var latas = 0
  var globos = 0

  method recolectarLatas() {
    latas += 1
  }

  method reciclarLatas() {
    latas = 0.max(latas - 5)
  }

  method tieneTodoListo() = latas.even()
  
  method tieneSuficientesGlobos() = globos > 50 

  method comprarGlobos(unaCantidad) {
    globos += unaCantidad
  } 
}

object fiesta {
  var property organizador = manic 

  method estaPreparada() {
    organizador.tieneTodoListo() && organizador.tieneSuficienteGlobos()
  }
}