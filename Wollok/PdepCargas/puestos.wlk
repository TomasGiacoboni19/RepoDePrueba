import pdepCargas.*
import camiones.*
object rutatlantica {
  method dejarPasar(unCamion) {
    pdepCargas.pagar(self.tarifa(unCamion))
    unCamion.recorrerRuta(400, self.velocidadQuePasa(unCamion))
  }
  /*  metodos para que haya mas declaratividad */
  method tarifa(unCamion) = 7000 + 100 * unCamion.pesoDeCarga() / 1000

  method velocidadQuePasa(unCamion) {
    return unCamion.velocidadMaxima().min(75)
  } 
}