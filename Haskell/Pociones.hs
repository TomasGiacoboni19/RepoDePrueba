-- https://docs.google.com/document/u/1/d/e/2PACX-1vQX84Z8tKK_1tZtS27zFcqovm8zwTUSPDmPqJvyC5IoODbk9YQtLxxbfAftwLBwFH7a3J3WDz0BRg9k/pub

data Persona = Persona {
  nombrePersona :: String,
  suerte :: Int,
  inteligencia :: Int,
  fuerza :: Int
} deriving (Show, Eq)

data Pocion = Pocion {
  nombrePocion :: String,
  ingredientes :: [Ingrediente]
}

type Efecto = Persona -> Persona

data Ingrediente = Ingrediente {
  nombreIngrediente :: String,
  efectos :: [Efecto]
}

nombresDeIngredientesProhibidos = [
 "sangre de unicornio",
 "veneno de basilisco",
 "patas de cabra",
 "efedrina"]

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun _ [ x ] = x
maximoSegun  f ( x : y : xs)
  | f x > f y = maximoSegun f (x:xs)
  | otherwise = maximoSegun f (y:xs)

{-
Dada una persona definir las siguientes funciones para cuantificar sus niveles de suerte, inteligencia y fuerza sin repetir código:
a- sumaDeNiveles que suma todos sus niveles.
b- diferenciaDeNiveles es la diferencia entre el nivel más alto y más bajo.
c- nivelesMayoresA n, que indica la cantidad de niveles de la persona que están por encima del valor dad
-}
sumaDeNiveles :: Persona -> Int
sumaDeNiveles persona = maximoNivel persona + minimoNivel persona

maximoNivel :: Persona -> Int
maximoNivel persona = maximum . niveles