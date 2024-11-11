class SalasEscape {
    const nombre
    const dificultad

    method nombre() = nombre 

    method precio() = 10000 + self.adicional()
    method adicional() 

    method esSalaDificil() {
      return dificultad > 7
    }
} 

class SalaAnime inherits SalasEscape {
    override method adicional() = 7000
}  

class SalaHistoria inherits SalasEscape {
    var basadaEnHechosReales

    override method adicional() = dificultad * 0.314

    override method esSalaDificil(){
      return super() && !basadaEnHechosReales
    } 
}

class SalaTerror inherits SalasEscape {
    var cantidadDeSustos

    override method adicional(){
      if(cantidadDeSustos > 5)
        return cantidadDeSustos * 0.2
        else return 0
      }
    
    override method esSalaDificil() {
      return super() || cantidadDeSustos > 5
    }
}

const salaAnime = new SalaAnime(nombre = "Naruto Escape", dificultad = 8)
const salaHistoria = new SalaHistoria(nombre = "Revolución Francesa", dificultad = 6, basadaEnHechosReales = true)
const salaTerror = new SalaTerror(nombre = "Noche de Sustos", dificultad = 9, cantidadDeSustos = 10)
