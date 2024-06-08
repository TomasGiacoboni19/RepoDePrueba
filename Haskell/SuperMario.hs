{-
Como todos sabemos, Mario es un plomero, una noble profesión que nos salva las papas del fuego cuando se nos rompen los caños de la casa y no tenemos ni la más pálida idea de por dónde arrancar. 
De los plomeros conocemos su nombre, la caja de herramientas que llevan, el historial de reparaciones que han hecho y el dinero que llevan encima (¡no trabajan gratis!). 
Hay unas cuantas herramientas que un plomero puede tener encima, y de cada una conocemos su denominación (nombre de la herramienta), su precio y el material de su empuñadura, que puede ser hierro, madera, goma o plástico.
-}

data Plomero = Plomero {
    nombre :: String,
    dinero :: Float,
    reparaciones :: [Reparacion],
    herramientas :: [Herramienta]
} deriving (Show)

type Reparacion = [String]

data Herramienta = Herramienta{
    denominacion :: String,
    material :: Material,
    precio :: Float
    } deriving (Show)

data Material = Hierro | Madera | Goma | Plastico deriving Show

{- 1)
Mario, un plomero que tiene $1200, no hizo ninguna reparación hasta ahora y en su caja de herramientas lleva una llave inglesa con mango de hierro que tiene un precio de $200 y un martillo con empuñadura de madera que le salió $20
-}

mario :: Plomero
mario = Plomero "Mario" 1200 [] [Herramienta "Llave Inglesa" Hierro 200, Herramienta "Martillo" Madera 20]
{-
Wario, tiene 50 centavos encima, no hizo reparaciones, lleva infinitas llaves francesas, obviamente de hierro, la primera le salió un peso, pero cada una que compraba le salía un peso más cara. La inflación lo está matando. 
-}
wario :: Plomero
wario = Plomero "Wario" 0.50 [] (map (Herramienta "Llave Francesa" Hierro) [1..])

{-
2) Saber si un plomero:
-}
-- a --
-- Tiene una herramienta con cierta denominación.
tiene :: String -> Plomero -> Bool
tiene unaDenominacion = any ((==unaDenominacion). denominacion) . herramientas

-- b --
-- Es malvado: se cumple si su nombre empieza con Wa.

esMalvado :: Plomero -> Bool
esMalvado = (=="Wa").take 2. nombre 

-- c --
-- Puede comprar una herramienta: esto sucede si tiene el dinero suficiente para pagar el precio de la misma.

puedeComprar herramienta plomero = dinero plomero >= precio herramienta