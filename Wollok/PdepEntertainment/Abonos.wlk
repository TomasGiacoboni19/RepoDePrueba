class AbonoVIP{
    var descuento
    method aumentarDescuento(unValor){
        descuento += unValor
    }
    method descuentoAplicado(unValor){
        return unValor*(1-descuento)
    }
    method esVip() = true
}

object abonoFan{
    method esVip() = false
    method descuentoAplicado(unValor) = unValor
    method aumentarDescuento(unValor){}
}