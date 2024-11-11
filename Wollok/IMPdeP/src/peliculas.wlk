import src.artistas.*

class Pelicula {
  const nombre
  const elenco = []

  method nombre() = nombre 
  method elenco() = elenco

  method presupuesto() {
    return self.sumaSueldo() *1.7
  }      

  method sumaSueldo() {
    return elenco.sum({actor => actor.sueldo()})
  }

  method ganancias() {
    return self.recaudacion() - self.presupuesto()
  }

  method recaudacion() {
    return 1000000 + self.extraPorCategoria()
  }

  method extraPorCategoria()  

  method rodar() {
    return elenco.forEach({elenco => elenco.actuar()})
  }

  method esPeliculaEconomica() {
    return self.presupuesto() < 500000
  }
}

class Drama inherits Pelicula {
  
  override method extraPorCategoria() {
    return nombre.size() * 100000
  } 
}

class Accion inherits Pelicula{

    override method extraPorCategoria() {
      return elenco.size() * 50000
    }
}

class Terror inherits Pelicula{
    const cantidadDeCuchos

    override method extraPorCategoria() {
        return cantidadDeCuchos * 20000
    } 
}

class Comedia inherits Pelicula {
  
  override method extraPorCategoria() = 0 
}