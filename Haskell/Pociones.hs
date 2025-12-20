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

nombresDeIngredientesProhibidos :: [String]
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
maximoNivel persona = maximum . niveles $ persona

minimoNivel :: Persona -> Int
minimoNivel persona = minimum . niveles $ persona

niveles :: Persona -> [Int]
niveles persona = [suerte persona, inteligencia persona, fuerza persona]


nivelesMayoresA :: Int -> Persona -> Int
nivelesMayoresA n persona = length . filter (> n) $ niveles persona

{-
2) Definir la función efectosDePocion que dada una poción devuelve una lista con los efectos de todos sus ingredientes.
-}
efectosDePocion :: Pocion -> [Efecto]
efectosDePocion pocion = concatMap efectos . ingredientes $ pocion

--Dada una lista de pociones, consultar:
--a) Los nombres de las pociones hardcore, que son las que tienen al menos 4 efectos.
nombresDePocionesHardcore :: [Pocion] -> [String]
nombresDePocionesHardcore pociones =  map nombrePocion   . filter esHardcore $ pociones

esHardcore :: Pocion -> Bool
esHardcore pocion = (>=4). length . efectosDePocion $ pocion
--b) La cantidad de pociones prohibidas, que son aquellas que tienen algún ingrediente cuyo nombre figura en la lista de ingredientes prohibidos.
cantidadDePocionesProhibidas :: [Pocion] -> Int
cantidadDePocionesProhibidas pociones = length . filter esProhibida $ pociones

esProhibida :: Pocion -> Bool
esProhibida pocion = any (flip elem nombresDeIngredientesProhibidos . nombreIngrediente) . ingredientes $ pocion
--c) Si son todas dulces, lo cual ocurre cuando todas las pociones de la lista tienen algún ingrediente llamado “azúcar”.
todasDulces :: [Pocion] -> Bool
todasDulces pociones = all esDulce pociones

esDulce :: Pocion -> Bool
esDulce pocion = any ((=="azúcar") . nombreIngrediente) . ingredientes $ pocion

--4) Definir la función tomarPocion que recibe una poción y una persona, y devuelve como quedaría la persona después de tomar la poción. Cuando una persona toma una poción, se aplican todos los efectos de esta última, en orden.

tomarPocion :: Pocion -> Persona -> Persona
tomarPocion pocion persona =  (foldl (\persona efecto -> efecto persona) persona . efectosDePocion) pocion
--Otra forma de hacerlo es con foldr
--tomarPocion pocion persona =  (foldr (\efecto persona -> efecto persona) persona . efectosDePocion) pocion
--Otra forma de hacerlo es con foldl1
--tomarPocion pocion persona =  (foldl1 (\persona efecto -> efecto persona) . efectosDePocion) pocion

{- Punto 5
Definir la función esAntidotoDe que recibe dos pociones y una persona, y dice si tomar la segunda poción revierte los cambios que se producen en la persona al tomar la primera.
-}
esAntidotoDe :: Pocion -> Pocion -> Persona -> Bool
esAntidotoDe pocion antidoto persona =
  (==persona) . tomarPocion antidoto . tomarPocion pocion $ persona 



{- Punto 6
Definir la función personaMasAfectada que recibe una poción, una función cuantificadora (es decir, una función que dada una persona retorna un número) y una lista de personas, y devuelve a la persona de la lista que hace máxima el valor del cuantificador. Mostrar un ejemplo de uso utilizando los cuantificadores definidos en el punto 1.
-}
personaMasAfectada :: Pocion -> (Persona -> Int) -> [Persona] -> Persona
personaMasAfectada pocion cuantificador personas =
    maximoSegun (cuantificador . tomarPocion pocion) personas