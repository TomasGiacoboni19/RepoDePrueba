object productora{
    const bandas = #{}
    const asistentes = #{}
    var property impuestoEntradas = 0
    method gananciaTotal(){
        self.recaudacionDeEntradas() - self.presupuestoDeLasBandas()
    }
    method entradasDeAsistentes(){
        return asistentes.flatMap({unAsistente => unAsistente.entradas()})
    }
    method recaudacionDeEntradas(){
        return self.entradasDeAsistentes().sum({unaEntrada => unaEntrada.precio()})
    }
    method presupuestoDeLasBandas(){
        return bandas.sum({unaBanda => unaBanda.presupuesto()})
    }
    method cantidadDeEntradasVendidas(){
        return self.entradasDeAsistentes().size()
    }
    method bandaMasPopular(){
        return bandas.max({unaBanda => unaBanda.popularidad()})
    }
    method bonificarAsistentesVip(){
        self.asistentesVip().forEach({unAsistente => unAsistente.aumentarDescuentoPorVip(0.1)})
    }
    //la productora no aumenta directamente el descuento del abono ya que romperia el encapsulamiento en cuanto el abono forma parte del estado del asistente
    method asistentesVip(){
        return asistentes.filter({unAsistente => unAsistente.esVip()})
    }
}