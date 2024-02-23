{-
Lo que sabemos es que los participantes tienen un
nombre, una edad, un nivel de atractivo, un nivel de personalidad y un nivel
de inteligencia (todos números decimales en un principio). Además, los
participantes tienen un criterio de voto, para determinar a quién nominar.
-}

{-
Las pruebas semanales son eventos que tienen un criterio para ser
superadas, pero también tienen un índice de éxito (decimal) que es un
número entre 0 y 100 y determina qué tan bien se supera la prueba. Si la
prueba no se supera, el índice de éxito es 0.
-}

data Participante = Participante{
    nombre :: String,
    edad :: Float,
    nivelAtractivo :: Float,
    nivelInteligencia :: Float,
    criterio :: Criterio
}
type Criterio = Participante -> Participante

type Prueba = Participante -> Float

{- Las pruebas que conocemos son:
a. baileDeTikTok: requiere una personalidad de 20. El índice de
éxito se calcula como la personalidad + el doble del atractivo del
participante.
b. botonRojo: requiere una personalidad de 10 y una inteligencia
de 20. El índice de éxito es siempre 100.
c. cuentasRapidas: requiere una inteligencia de 40. El índice de
éxito se calcula como la inteligencia + la personalidad - el
atractivo.
-}

---- Punto 1 ----
baileDeTikTok :: Prueba
baileDeTikTok personalidad participante 

funcion criterio participante = 