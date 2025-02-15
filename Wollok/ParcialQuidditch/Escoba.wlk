class Nimbus{
    const anioDeFabricacion
    var porcentajeDeSalud

    method velocidad() = (80 - self.antiguedad()) * porcentajeDeSalud / 100

    method antiguedad() = self.anioActual() - anioDeFabricacion  

    method anioActual() = new Date().year()
     
    method recibirGolpe() {
        porcentajeDeSalud -= 10
    }
}

class SaetaDeFuego{
    method velocidad() = 100

    method recibirGolpe() {
      //No le pasa nada
    }
}