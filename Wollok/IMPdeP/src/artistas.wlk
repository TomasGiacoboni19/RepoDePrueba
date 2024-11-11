/*De cada artista se conoce su experiencia, la cantidad de películas en las que actuó, sus ahorros y lo siguiente:

Su sueldo se calcula en base a su experiencia:
Si es amateur, siempre será USD 10.000.
Si su experiencia ya está establecida, dependerá del nivel de fama (el cual es la mitad de películas que tiene filmadas): 
USD 15.000 si es menor a 15.
USD 5.000 por su nivel de fama, en caso de que sea mayor o igual a 15.
Si ya es una estrella, será USD 30.000 por cada película en la que haya actuado.
Debe poder recategorizar su experiencia en el caso de que sea posible:
Si es amateur, podemos decir que se estableció cuando ya tenga más de 10 películas actuadas.
Si ya se estableció, sólo podrá hacerlo si su nivel de fama es mayor a 10 y podremos decir que estamos ante una estrella.
Una estrella nunca debe poder recategorizarse y en el caso de intentar hacerlo, se deberá lanzar un error.
Cuando actúa debe aumentar en uno su cantidad de películas actuadas e incrementar sus ahorros según el sueldo que cobre.
IMPdeP

Nuestra aplicación está llena de novedades y debe permitirnos saber:

Qué artista tiene la mejor paga, en otras palabras, el mejor sueldo. 
Cuáles son los nombres de las películas económicas, es decir, las que tienen un presupuesto menor a USD 500.000.
Cuál es la suma de las ganancias de las películas económicas.

Además, debe permitir recategorizar a la totalidad de artistas que se encuentran almacenados en su plataforma.
*/

class Artista{
    var experiencia
    var cantidadPeliculasActuadas 
    var ahorros

    method sueldo() {
      return experiencia.dinero(cantidadPeliculasActuadas)
    }

    method recategorizarExperiencia(){
        experiencia =  experiencia.recategorizar(cantidadPeliculasActuadas)
    }

    method actuar() {
      cantidadPeliculasActuadas += 1
      ahorros += self.sueldo()
    }
}

object amateur {
  method dinero(cantidadDePeliculas){
    return 10000
  }
  method recategorizar(cantidadDepeliculas){
    if(cantidadDepeliculas > 10)
        return establecido
    else 
        return self
  }
}

object establecido {
  
  method nivelDeFama(cantidadDePeliculas){
    return cantidadDePeliculas / 2
  }

  method dinero(cantidadDePeliculas) {
    const fama = self.nivelDeFama(cantidadDePeliculas)
    if(fama < 15)
        return 15000
    else 
        return 5000 * fama
  }
}

object estrella{
    method dinero(cantidadDePeliculas) {
        return 30000 * cantidadDePeliculas
    } 
    method recategorizar(cantidadDePeliculas) {
        throw new Exception(message = "No puede recategorizarse") 
    } 
}

