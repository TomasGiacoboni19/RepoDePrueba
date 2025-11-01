// Enunciado: https://docs.google.com/document/d/1RAa8LS1E0CE_Ycysc1b4SN08tYVyCG6TiInzZU5zDd4/edit?tab=t.0#heading=h.uqyo573fdfh7

class SuperComputadora{
    const equipos = []

    method equiposActivos() = equipos.filter(equipos => equipos.estaActivo())

    method computo() = self.equiposActivos().sum{(equipo => equipo.computo())}
    method consumo() = self.equiposActivos().sum{(equipo => equipo.consumo())}


    method malConfigurada() = 
        self.equiposActivos().max{(equipo => equipo.consumo())} != 
        self.equiposActivos().max{(equipo => equipo.computo())}    
    
}

// Equipos
class Equipo{
    var property modo
    var property estaQuemado = false

    method estaActivo() = !estaQuemado && self.computo() > 0
    method consumo() = modo.consumoDe(self)
    method computo() = modo.computoDe(self)

    method consumoBase()
}

class A105 inherits Equipo{
    
    override method consumoBase() = 300
}
class B2 inherits Equipo{
    const microChips
    override method consumoBase() = 10 + 50 * microChips
}

// Modos

object standard{

    method consumoDe(equipo) = equipo.consumoBase()
    method computoDe(equipo) = equipo.computoBase()
    
}

class Overcklock {
    method consumoPara(equipo) = 10
    method computoPara(equipo) = 25
    
}

class AhorroDeEnergia {
    method consumoPara(equipo) = 2
    method computoPara(equipo) = 5
}