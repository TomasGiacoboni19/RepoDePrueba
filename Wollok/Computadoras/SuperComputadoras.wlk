// Enunciado: https://docs.google.com/document/d/1RAa8LS1E0CE_Ycysc1b4SN08tYVyCG6TiInzZU5zDd4/edit?tab=t.0#heading=h.uqyo573fdfh7

class SuperComputadora{
    const equipos = []
    var totalDeComplejidadComputadora = 0

    method equiposActivos() = equipos.filter{equipos => equipos.estaActivo()}

    method estaActivo() = true

    method computo() = self.equiposActivos().sum{equipo => equipo.computo()}
    method consumo() = self.equiposActivos().sum{equipo => equipo.consumo()}


    method malConfigurada() = 
        self.equiposActivos().max{equipo => equipo.consumo()} != 
        self.equiposActivos().max{equipo => equipo.computo()}    
    
    method computar(problema){
        self.equiposActivos().forEach{equipo => equipo.computar(New Problema(complejidad = problema.totalDeComplejidadComputadora() / self.equiposActivos().size()))}
       
        totalDeComplejidadComputadora += problema.complejidad()
    }
}

class Problema{
    const property complejidad

}

// Equipos
class Equipo{
    var property modo
    var property estaQuemado = false

    method estaActivo() = !estaQuemado && self.computo() > 0
    method consumo() = modo.consumoDe(self)
    method computo() = modo.computoDe(self)

    method consumoBase()
    method computoBase()
    method computoExtraPorOverclock()
    method computar(problema) { 
        if(problema.complejidad() > self.computo()) throw New Exception("No se puede computar el problema, falla")
        modo.realizoComputo(self)
    }
}
class A105 inherits Equipo{
    
    override method consumoBase() = 300
    override method computoBase() = 600
    override method computoExtraPorOverclock() = self.computoBase() * 0.3

    override method computar(problema) { 
        if(problema.complejidad() < 5) throw New Exception("Fallo en el calculo")
        super(problema)
    }
}
class B2 inherits Equipo{
    const microChips
    override method consumoBase() = 10 + 50 * microChips
    override method computoBase() = 800.min(100 * microChips)
    override method computoExtraPorOverclock() = microChips * 20

    
}

// Modos

object standard{

    method consumoDe(equipo) = equipo.consumoBase()
    method computoDe(equipo) = equipo.computoBase()
    method realizoComputo(equipo) {}   
}

class Overcklock {
    var UsosRestantes
    
    method consumoDe(equipo) = equipo.consumoBase() * 2
    method computoDe(equipo) = equipo.computoBase() + equipo.computoExtraPorOverclock()
    method realizoComputo(equipo) {
        if(UsosRestantes <= 0) {
            equipo.estaQuemado(true)
            throw New Exception(message = "El equipo se quemo por overclockearlo de mas")
        }
        usosRestantes =- 1
    } 
}

class AhorroDeEnergia {
    var computosRealizados = 0

    method consumoPara(equipo) = 200
    method computoPara(equipo) = self.consumoDe(equipo) / equipo.consumoBase() * equipo.computoBase()   
    method realizoComputo(equipo) {
        computosRealizados += 1
        if(computosRealizados % self.perioricidadDeError() == 0) {
            throw New Exception(message = "El equipo está corriendo el monitor")
        }
    }
    method perioricidadDeError() = 17
}

class APruebaDeFallos inherits AhorroDeEnergia {
    override method computoDe(equipo) = super(equipo) / 2
    override method perioricidadDeError() = 100
}