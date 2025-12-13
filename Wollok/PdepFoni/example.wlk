// https://docs.google.com/document/d/1nVLdccfRxa-1mYPtnj2hSlc45UrEn9kljvLZuYGcAnQ/edit?tab=t.0

/*
Una reconocida empresa de servicio de telefonía celular nos está pidiendo realizar el sistema que maneja las líneas y packs de sus clientes. No vamos a revelar cuál es, pero hay una pista en la imagen.
Una línea tiene un número de teléfono, y puede tener varios packs activos, que sirven para que la línea pueda realizar consumos. Por ahora Pdepfoni permite hacer dos tipos de consumo:
Consumo de Internet (cada consumo es por una cantidad de MB)
Consumo de llamadas (cada consumo es por una cantidad de segundos)
Para poder realizar esos consumos, se pueden agregar packs a la línea. Algunos packs que hoy existen son: 
Cierta cantidad de crédito disponible.
Una cant de MB libres para navegar por Internet.
Llamadas gratis.
Internet ilimitado los findes (*)
Agregar packs a futuro debe ser sencillo (como Internet gratis los martes, segundos de llamada libres, etc., aunque no hace falta agregarlos ahora).
Además algunos packs pueden tener vigencia (una fecha de vencimiento). Puede entonces existir un pack de llamadas gratis ó uno con 1000 MB que si están vencidos, no podrán utilizarse más. 
(*) Ver al final del enunciado el uso de la clase Date.

Se pide la codificación de la solución en Wollok para:
Conocer el costo de un consumo realizado.	
Se sabe que la empresa de telefonía dispone de precios por MB y por segundo de llamada. Además, se sabe que siempre se cobra un precio fijo por los primeros 30 segundos de llamada y luego se cobra por segundo pasado de los 30.
Por ejemplo, si el precio por segundo es $0.05, con un precio fijo de $1; y el precio por MB es $0.10, entonces 
- un consumo de llamada de 40 segundos vale ($1 + 10 * $0.05 = $1.50),
- y un consumo de internet de 5 MB vale (5 * $0.10 = $0.50).
Recomendación: leer el punto siguiente para ayudarse con el modelado.

*/
class Consumo{

}

class ConsumoInternet inherits Consumo{
    const property cantidadMB
    
}

class ConsumoLlamada inherits Consumo{
    
}