--------Ejercicio 1---------------

esMultiploDeTres :: Int -> Bool
esMultiploDeTres = (==0) . (`mod` 3) 

--------Ejercicio 2---------------
esMultiploDe :: Int -> Int -> Bool
esMultiploDe unNumero otroNumero = (==0).(`mod` unNumero) $ otroNumero

--------Ejercicio 3---------------
cubo :: Int -> Int
cubo unNumero = (^3) unNumero

--------Ejercicio 4---------------
type Base = Float
type Altura = Float
type Area = Float

areaRectangulo :: Base -> Altura -> Area
areaRectangulo    base    altura = base * altura

--------Ejercicio 5---------------
esBisiesto anio divisor
    | esBisiesto 