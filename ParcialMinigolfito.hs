module Lib where

import Text.Show.Functions
-- Modelo inicial

data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo

bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)

mayorSegun f a b
  | f a > f b = a
  | otherwise = b

----------------------------------------------
---- Resolución del ejercicio
----------------------------------------------

{-
1)
a. Modelar los palos usados en el juego que a partir de una determinada habilidad generan un tiro que se compone por velocidad, precisión y altura.

- El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.

- La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.

- Los hierros, que varían del 1 al 10 (número al que denominaremos n), generan un tiro de velocidad igual a la fuerza multiplicada por n, la precisión dividida por n y una altura de n-3 (con mínimo 0). Modelarlos de la forma más genérica posible.
-}

type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = UnTiro {
  velocidad = 10,
  precision = precisionJugador habilidad * 2,
  altura = 0
}

madera :: Palo
madera habilidad = UnTiro {
  velocidad = 100,
  precision = precisionJugador habilidad `div`  2,
  altura = 5
}

hierro :: Int -> Palo
hierro n habilidad = UnTiro {
  velocidad = fuerzaJugador habilidad * n,
  precision = precisionJugador habilidad `div` n,
  altura = max 0 (n-3)
}

--b. Definir una constante palos que sea una lista con todos los palos que se pueden usar en el juego.

palos :: [Palo]
palos = [putter, madera] ++ map hierro [1..10]

{- 
2) Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar ese palo con las habilidades de la persona.

Por ejemplo si Bart usa un putter, se genera un tiro de velocidad = 10, precisión = 120 y altura = 0.
-}

golpe :: Jugador -> Palo ->  Tiro
golpe jugador palo = palo . habilidad $ jugador

{-
3) Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo, cómo se ve afectado dicho tiro por el obstáculo. En principio necesitamos representar los siguientes obstáculos:
Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro. Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0. 
Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros. Luego de superar una laguna el tiro llega con la misma velocidad y precisión, pero una altura equivalente a la altura original dividida por el largo de la laguna.
Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95. Al superar el hoyo, el tiro se detiene, quedando con todos sus componentes en 0.
-}

data Obstaculo = Obstaculo {
  puedeSuperarlo :: Tiro -> Bool,
  efectoDelObstaculo :: Tiro -> Tiro
}

superarObstaculo :: Obstaculo -> Tiro -> Tiro
superarObstaculo obstaculo tiro 
  | puedeSuperarlo obstaculo $ tiro = efectoDelObstaculo obstaculo $ tiro
  | otherwise = tiroDetenido 

tiroDetenido :: Tiro
tiroDetenido  = UnTiro 0 0 0

tunelConRampita :: Obstaculo
tunelConRampita = Obstaculo superarTunelConRampita efectoTunelConRampita

superarTunelConRampita :: Tiro -> Bool
superarTunelConRampita tiro = ((>90) . precision $ tiro) && vaAlRasDelSuelo tiro


vaAlRasDelSuelo tiro = (==0) . altura $ tiro 

efectoTunelConRampita :: Tiro -> Tiro
efectoTunelConRampita tiro = UnTiro {
  velocidad = velocidad tiro * 2,
  precision = 100,
  altura    = 0
}

laguna :: Int -> Obstaculo
laguna largoLaguna= Obstaculo superarLaguna (efectoLaguna largoLaguna) 

superarLaguna :: Tiro -> Bool
superarLaguna tiro = ((>80) . velocidad $ tiro) && ((between 1 5 . altura) $ tiro)

-- between n m x = elem x [n .. m]

efectoLaguna :: Int -> Tiro -> Tiro
efectoLaguna largoLaguna tiro = UnTiro {
  altura = altura tiro `div` largoLaguna
}

{-
Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95. Al superar el hoyo, el tiro se detiene, quedando con todos sus componentes en 0.
-}

hoyo :: Obstaculo
hoyo = Obstaculo superaHoyo efectoHoyo

superaHoyo :: Tiro -> Bool
superaHoyo tiro = (between 5 20 . velocidad) tiro && vaAlRasDelSuelo tiro && precision tiro > 95
efectoHoyo :: Tiro -> Tiro
efectoHoyo _ = tiroDetenido

{-
data Obstaculo = UnObstaculo {
  puedeSuperar :: Tiro -> Bool,
  efectoLuegoDeSuperar :: Tiro -> Tiro
  }
-}

{-
Definir palosUtiles que dada una persona y un obstáculo, permita determinar qué palos le sirven para superarlo.
-}

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter (leSirveParaSuperar jugador obstaculo) palos

palosUtiles' jugador obstaculo = filter (puedeSuperarlo obstaculo . golpe jugador) palos

leSirveParaSuperar :: Jugador -> Obstaculo -> Palo -> Bool
leSirveParaSuperar jugador obstaculo = puedeSuperarlo obstaculo . golpe jugador

{-
Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.
Por ejemplo, para un tiro de velocidad = 10, precisión = 95 y altura = 0, y una lista con dos túneles con rampita seguidos de un hoyo, el resultado sería 2 ya que la velocidad al salir del segundo túnel es de 40, por ende no supera el hoyo.
-}

cuantosObstaculosConsecutivosSupera :: Tiro -> [Obstaculo] -> Int
cuantosObstaculosConsecutivosSupera tiro [] = 0
cuantosObstaculosConsecutivosSupera tiro (obstaculo : obstaculos)
  | puedeSuperarlo obstaculo tiro
      = 1 + cuantosObstaculosConsecutivosSupera (efectoDelObstaculo obstaculo tiro) obstaculos
  | otherwise = 0

{-
Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar más obstáculos con un solo tiro.
-}

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos
  = maximoSegun (flip cuantosObstaculosConsecutivosSupera obstaculos.golpe jugador) palos

{-
    Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo, se pide retornar la lista de padres que pierden la apuesta por ser el “padre del niño que no ganó”. Se dice que un niño ganó el torneo si tiene más puntos que los otros niños.
-}

jugadorDeTorneo = fst
puntosGanados = snd

pierdenLaApuesta :: [(Jugador, Puntos)] -> [String]
pierdenLaApuesta puntosDeTorneo
  = (map (padre.jugadorDeTorneo) . filter (not . gano puntosDeTorneo)) puntosDeTorneo

gano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano puntosDeTorneo puntosDeUnJugador
  = (all ((< puntosGanados puntosDeUnJugador).puntosGanados)
      . filter (/= puntosDeUnJugador)) puntosDeTorneo