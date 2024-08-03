{-
Carreras
Queremos armar un programa que nos permita simular unas fantásticas carreras de autos en las cuales cada vehículo avanza tan rápido como puede para consagrarse campeón, aprovechando del uso de algunos poderes especiales (o power ups) que encuentren a lo largo del trayecto para sacar ventaja por sobre los demás autos.
De cada auto conocemos su color (que nos servirá para identificarlo durante el desarrollo de la carrera), la velocidad a la que está yendo y la distancia que recorrió, ambos valores de tipo entero.
De la carrera sólo nos interesa el estado actual de los autos que están participando, lo cual nos permitirá analizar cómo viene cada uno, y posteriormente procesar aquellos eventos que se den en la carrera para determinar el resultado de la misma.
Teniendo en cuenta lo descrito anteriormente se pide resolver los siguientes puntos explicitando el tipo de cada función desarrollada y utilizando los conceptos aprendidos del Paradigma Funcional, poniendo especial énfasis en el uso de Composición, Aplicación Parcial y Orden Superior.
-}

{- Punto 1
Declarar los tipos Auto y Carrera como consideres convenientes para representar la información indicada y definir funciones para resolver los siguientes problemas:
-}

data Auto = Auto{
    color :: String,
    velocidad :: Int,
    distancia :: Int     
} deriving (Eq, Show)

type Carrera = [Auto]

azul :: Auto
azul = Auto "Azul" 120 200

rojo :: Auto
rojo = Auto "Rojo" 100 185

carrera :: Carrera
carrera = [azul, rojo]
{- A
Saber si un auto está cerca de otro auto, que se cumple si son autos distintos y la distancia que hay entre ellos (en valor absoluto) es menor a 10.
-}

estaCercaDeOtroAuto :: Auto -> Auto -> Bool
estaCercaDeOtroAuto  unAuto otroAuto = ((<10) . abs. distanciaEntre unAuto $ otroAuto) && autosDistintos unAuto otroAuto

autosDistintos :: Auto -> Auto -> Bool
autosDistintos unAuto otroAuto = not (color unAuto == color otroAuto) 

distanciaEntre :: Auto -> Auto -> Int
distanciaEntre unAuto otroAuto =  (distancia unAuto -) . distancia $ otroAuto

{- B
Saber si un auto va tranquilo en una carrera, que se cumple si no tiene ningún auto cerca y les va ganando a todos (por haber recorrido más distancia que los otros).
-}
vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo unAuto carrera = (not.tieneAlgunAutoCerca unAuto ) carrera && vaGanando unAuto carrera
-- && leVaGanandoATodos auto carrera

tieneAlgunAutoCerca :: Auto -> Carrera -> Bool
tieneAlgunAutoCerca auto carrera = any (estaCercaDeOtroAuto auto) $ carrera

vaGanando :: Auto -> Carrera -> Bool
vaGanando auto  = all(leVaGanandoATodos auto) . filter (/= auto) 

leVaGanandoATodos :: Auto -> Auto -> Bool
leVaGanandoATodos ganador perdedor = (<distancia ganador) . distancia $ perdedor

{-Conocer en qué puesto está un auto en una carrera, que es 1 + la cantidad de autos de la carrera que le van ganando.-}

puesto :: Auto -> Carrera -> Int 
puesto auto = (1 +) . length . filter (not . leVaGanandoATodos auto) 

correr :: Int -> Auto -> Auto
correr tiempo auto = auto {
    distancia = distancia auto +
        tiempo * velocidad auto
}

type ModificadorDeVelocidad = Int -> Int
alterarVelocidad :: ModificadorDeVelocidad -> Auto -> Auto
alterarVelocidad modificador auto =
    auto { velocidad = (modificador . velocidad) auto}

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad velocidadABajar 
  = alterarVelocidad (max 0 . subtract velocidadABajar)

------

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

type PowerUp = Auto -> Carrera -> Carrera
terremoto :: PowerUp
terremoto autoQueGatillo =
    afectarALosQueCumplen (estaCercaDeOtroAuto autoQueGatillo) (bajarVelocidad 50)

miguelitos :: Int -> PowerUp
miguelitos velocidadABajar autoQueGatillo =
    afectarALosQueCumplen (leVaGanandoATodos autoQueGatillo) (bajarVelocidad velocidadABajar)

jetPack :: Int -> PowerUp
jetPack tiempo autoQueGatillo =
    afectarALosQueCumplen (== autoQueGatillo)
        (alterarVelocidad (\ _ -> velocidad autoQueGatillo) 
          . correr tiempo . alterarVelocidad (*2))

type Color = String
type Evento = Carrera -> Carrera
simularCarrera :: Carrera -> [Evento] -> [(Int, Color)]
simularCarrera carrera eventos = (tablaDePosiciones . procesarEventos eventos) carrera

tablaDePosiciones :: Carrera -> [(Int, Color)]
tablaDePosiciones carrera 
  = map (entradaDeTabla carrera) carrera

entradaDeTabla :: Carrera -> Auto -> (Int, String)
entradaDeTabla carrera auto = (puesto auto carrera, color auto)

tablaDePosiciones' :: Carrera -> [(Int, String)]
tablaDePosiciones' carrera 
  = zip (map (flip puesto carrera) carrera) (map color carrera)

procesarEventos :: [Evento] -> Carrera -> Carrera
procesarEventos eventos carreraInicial =
    foldl (\carreraActual evento -> evento carreraActual) 
      carreraInicial eventos

procesarEventos' eventos carreraInicial =
    foldl (flip ($)) carreraInicial eventos

correnTodos :: Int -> Evento
correnTodos tiempo = map (correr tiempo)

usaPowerUp :: PowerUp -> Color -> Evento
usaPowerUp powerUp colorBuscado carrera =
    powerUp autoQueGatillaElPoder carrera
    where autoQueGatillaElPoder = find ((== colorBuscado).color) carrera

find :: (c -> Bool) -> [c] -> c
find cond = head . filter cond

ejemploDeUsoSimularCarrera =
    simularCarrera autosDeEjemplo [
        correnTodos 30,
        usaPowerUp (jetPack 3) "azul",
        usaPowerUp terremoto "blanco",
        correnTodos 40,
        usaPowerUp (miguelitos 20) "blanco",
        usaPowerUp (jetPack 6) "negro",
        correnTodos 10
    ]

autosDeEjemplo :: [Auto]
autosDeEjemplo = map (\color -> Auto color 120 0) ["rojo", "blanco", "azul", "negro"]

---- Punto 5
{-

5a

Se puede agregar sin problemas como una función más misilTeledirigido :: Color -> PowerUp, y usarlo como:
usaPowerUp (misilTeledirigido "rojo") "azul" :: Evento


5b

- vaTranquilo puede terminar sólo si el auto indicado no va tranquilo
(en este caso por tener a alguien cerca, si las condiciones estuvieran al revés, 
terminaría si se encuentra alguno al que no le gana).
Esto es gracias a la evaluación perezosa, any es capaz de retornar True si se encuentra alguno que cumpla 
la condición indicada, y all es capaz de retornar False si alguno no cumple la condición correspondiente. 
Sin embargo, no podría terminar si se tratara de un auto que va tranquilo.

- puesto no puede terminar nunca porque hace falta saber cuántos le van ganando, entonces por más 
que se pueda tratar de filtrar el conjunto de autos, nunca se llegaría al final para calcular la longitud.

-}