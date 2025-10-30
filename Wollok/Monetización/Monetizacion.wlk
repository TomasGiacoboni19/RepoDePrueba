// Contenidos
class Contenido {
  const property titulo
  var property vistas = 0
  var property ofensivo = false
  var property monetizacion

  method monetizacion(nuevaMonetizacion) {
    if (!nuevaMonetizacion.puedeAplicarseA(self)) {
      throw new Exception(message = "La monetización no puede aplicarse a este contenido")
    }
    monetizacion = nuevaMonetizacion
  }

  override method initialize(monetizacion) {
    if (!monetizacion.puedeAplicarseA(self)) {
      throw new Exception(message = "La monetización no pudo instanciarse a este contenido")
    }
  }

  method recaudacion() = monetizacion.recaudacionDe(self)
  method puedeVenderse() = self.esPopular()
  method esPopular()
  method recaudacionMaximaParaPublicidad()

  method puedeAlquilarse() 
}

class Video inherits Contenido {
  override method esPopular() = vistas > 1000
  override method recaudacionMaximaParaPublicidad() = 10000  

  override method puedeAlquilarse() = true
}

const tagsDeModa = ["objetos", "pdep", "wollok"]

class Imagen inherits Contenido {
  const property tags = []

  override method esPopular() = tags.all({tag => tagsDeModa.contains(tag)})
  override method recaudacionMaximaParaPublicidad() = 4000

  override method puedeAlquilarse() = false
}

// Monetización

object publicidad {
  method recaudacionDe(contenido) = 
    (0.05 + contenido.vistas() + 
    if (contenido.esPopular()) 2000 else 0)
    .min(contenido.recaudacionMaximaParaPublicidad())

    method puedeAplicarseA(contenido) = !contenido.ofensivo()
}

class Donacion{
    var property donaciones = 0
    
    method recaudacionDe(contenido) = donaciones 

    method puedeAplicarseA(contenido) = true
}

class Descarga{
  const property precioPorDescarga

  override method initialize(precio) {
    if(precioPorDescarga < 5) {
      throw new Exception(message = "El precio por descarga debe ser al menos 5")
    }
  }

  method recaudacionDe(contenido) = contenido.vistas() * precioPorDescarga

  method puedeAplicarseA(contenido) = contenido.puedeVenderse()
}

class Alquiler inherits Descarga {
  override method precioPorDescarga() = 1.max(super())

  override method puedeAplicarseA(contenido) = super(contenido) && contenido.puedeAlquilarse()
}

// Usuarios

object usuarios{
  const todosLosUsuarios = []

  method emailsDeUsuariosCotizados() = todosLosUsuarios
  .filter{usuario =>  usuario.verificado()}
  .sortedBy{unUsuario, otroUsuario => unUsuario.saldoTotal() > otroUsuario.saldoTotal()}
  .take(100)
  .map{usuario => usuario.email()}

  method cantidadDeSuperUsuarios() = todosLosUsuarios
  .count{usuario => usuario.esSuperUsuario()}
}

class Usuario{
  const property nombre
  const property email
  var property verificado = false
  const contenidos = []

  method publicar(contenido) {
  contenidos.add(contenido) 
  }

  method recaudacionTotal() = 
    contenidos.sum({contenido => contenido.recaudacion()})

  method esSuperUsuario() = contenidos.count{contenido => contenido.esPopular()} >= 10

  
}