class Banda{
    const nombre
    method canon() = 1000000
    method presupuesto(){
        return self.canon() + self.extra()
    }
    method extra()
    method popularidad()
    method nombre() = nombre
}

class BandaRock inherits Banda{
    const cantidadDeSolosDeGuitarra
    override method extra() = 10000
    override method popularidad(){
        return 100*cantidadDeSolosDeGuitarra
    }
}

class BandaTrap inherits Banda{
    const tieneHielo
    override method extra() = 0
    override method popularidad(){
        if(tieneHielo){
            return 1000
        } else return 0
    }
    override method canon() = super()*self.popularidad()
}

class BandaIndie inherits Banda{
    const cantidadDeInstrumentos
    method largoDeSuNombre(){
        return self.nombre().size()
    }
    override method popularidad(){
        return 3.14 * self.largoDeSuNombre()
    }
    override method extra(){
        return cantidadDeInstrumentos * 500
    }
}