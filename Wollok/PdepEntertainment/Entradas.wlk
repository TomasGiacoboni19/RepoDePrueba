import Productora.*

class Entrada{
    const banda 
    const fecha
    // asumo que el impuesto es un precio fijo
    method precio(){
        return 1000 + productora.impuestoEntradas()
    }
    method esDelAnio(unAnio){
        return fecha.year() == unAnio
    }
    method banda() = banda
}


