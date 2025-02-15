
import Entradas.*
import Error.*
class Asistente{
    var tipoDeAbono
    var entradas = #{}
    var dinero

    method comprarEntrada(unaFecha,unaBanda){
        if( dinero > 0){
            const entrada = new Entrada(banda = unaBanda, fecha = unaFecha)
            self.pagar(entrada.precio())
            self.agregarEntrada(entrada)
        }else{
            throw new NoTieneDineroSuficienteException()
        }
    }
    method pagar(unValor){
        const precioFinal = tipoDeAbono.descuentoAplicado(unValor)
        self.modificarDinero(-precioFinal)
    }
    method agregarEntrada(unaEntrada){
        entradas.add(unaEntrada)
    }
    method modificarDinero(unValor){
        dinero += unValor
    }
    method entradasDelAnioPasado(){
        const anioPasado = new Date().year() - 1
        return entradas.filter({unaEntrada => unaEntrada.esDelAnio(anioPasado)})
    }
    method bandasDeEntradasCompradas(){
        return entradas.map({unaEntrada => unaEntrada.banda()}).asSet()
    }
    method nombresDeBandasDeEntradasCompradas(){
        return self.bandasDeEntradasCompradas().map({unaBanda => unaBanda.nombre()})
    }
    method entradas() = entradas
    method esVip(){
        return tipoDeAbono.esVip()
    }
    method aumentarDescuentoPorVip(unValor){
        tipoDeAbono.aumentarDescuento(unValor)
    }
}


