import artistas.*
import peliculas.*

object impdep {
    const artistas = #{}
    const peliculas = #{}

    method artistas() = artistas

    method peliculas() = peliculas 

    method agregarPelicula(pelicula) {
        pelicula.add(pelicula)
        artistas.addAll(pelicula.elenco())
    } 

    method artistaMejorPago() {
      return artistas.max({artista => artista.sueldo()})
    }

    method peliculasEconomicas(){
      peliculas.filter({pelicula => pelicula.esPeliculaEconomica()})
      return peliculas.map({pelicula => pelicula.nombre()})
    }

    method gananciasPeliculasEconomicas() {
      return self.peliculasEconomicas().sum({pelicula => pelicula.ganancias()})
    }
    
    method recategorizarArtistas() {
      return artistas.forEach({artista => artista.recategorizarExperiencia()})
    }
}