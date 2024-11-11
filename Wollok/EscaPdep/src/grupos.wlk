import src.escapistas.*
import src.salas.*

class Grupo{
    const team = []
    var sala


    method sala() = sala
    method sala(nuevaSala) {
      sala = nuevaSala
    } 

    method puedeSalir() {
      return team.any({integrante => integrante.puedeSalir(sala)})
    }

    method escapar() {
      self.pagar()
      self.registrarEnCadaIntegrante()
    }


    method pagar() {
      const precioDeSala = sala.precio()
      const cantidadPorIntegrante = precioDeSala / self.cantidadDeIntegrantes()
      if(self.puedenPagar(precioDeSala, cantidadPorIntegrante))
        team.forEach({integrante => integrante.descontarSaldo(cantidadPorIntegrante)})
        else
            throw new Exception(message = "El grupo no puede pagar la sala")
        }
    
    method cantidadDeIntegrantes() = team.size() 

    method registrarEnCadaIntegrante(){
        team.forEach({integrante => integrante.agregarSala(sala)})
    }
    
    method puedenPagar(cantidadTotal, cantidadIndividual) {
      return self.todosTienenSuficiente(cantidadIndividual) || self.saldoGrupoMayorA(cantidadTotal)
    } 

    method todosTienenSuficiente(cantidadIndividual) {
      return team.forEach({integrante => integrante.puedePagar(cantidadIndividual)})
    }

    method saldoGrupoMayorA(cantidadTotal) {
      const dineroTotal = team.sum({integrante => integrante.saldo()})
      return dineroTotal >= cantidadTotal
    }
}
