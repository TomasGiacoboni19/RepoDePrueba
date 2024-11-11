import src.salas.*

class Escapista {
  var maestria
  var salasQueSalio = []
  var saldo

  method saldo() = saldo
 
  method puedePagar(cantidad) {
      return saldo >= cantidad
  }

  method descontarSaldo(cantidad) {
    saldo -= cantidad
  }

  method agregarSala(sala) {
    salasQueSalio.add(sala)
  }

  method puedeSalir(sala){
    const esDificil = sala.esSalaDificil()
    const hizoMuchasSalas = self.cantidadSalasQueSalio() >= 6
    return maestria.puedeSalir(esDificil, hizoMuchasSalas)
  } 

  method subirNivelMaestria(){
    if(self.cantidadSalasQueSalio() > 5) {
      maestria = maestria.siguienteNivel()
    }  
  }


  method cantidadSalasQueSalio() {
    return salasQueSalio.size()
  }

  method nombreDeSalasQueEscapo() {
    return salasQueSalio.map {salas => salasQueSalio.nombre()}.asSet()
  }
}

object amateur {
  const siguienteNivel = profesional
  method siguienteNivel() = siguienteNivel
  method puedeSalir(esDificil, hizoMuchasSalas) {
    return !esDificil && hizoMuchasSalas
  }  
}

object profesional {
  const siguienteNivel = self
  method siguienteNivel() = siguienteNivel
  method puedeSalir(esDificil, hizoMuchasSalas) = true  
}

const escapistaAmateur = new Escapista(maestria = amateur, saldo = 20000)
const escapistaProfesional = new Escapista(maestria = profesional, saldo = 30000)