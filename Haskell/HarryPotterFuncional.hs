-- Nombre: Tomás Giacoboni

import Text.Show.Functions


{-
    De los magos, sabemos que tienen un nombre, una edad y cierta cantidad de salud. Además, cada mago conoce un conjunto de hechizos el cual puede usar para hacerle cosas raras a otros magos.
    Se pide resolver los siguientes puntos, aprovechando al máximo los conceptos del paradigma funcional:

    1. Elegir un tipo de dato con el que representar a los Magos y los Hechizos (justificando brevemente la elección) de forma tal que se respete la descripción previa del dominio y sea posible modelar los siguientes hechizos:

    a. curar: Este hechizo hace que el mago sobre el que lanzamos el hechizo recupere una cierta cantidad de salud. Este hechizo puede usarse para curar distintas cantidades de vida.

    b. lanzarRayo: Este hechizo le hace daño al mago sobre el que se lanza. Si la salud de dicho mago es mayor a 10, le hace 10 puntos de daño, de lo contrario le quita la mitad de su vida actual. 

    c. amnsesia: El mago objetivo olvida los primeros N hechizos que conozca. Se puede lanzar este hechizo con diferentes valores de N.

    d. confundir: El mago objetivo se ataca a si mismo con su primer hechizo

2. Modelar las siguientes funciones:

    a. poder: El poder de un mago es su salud sumada al resultado de multiplicar su edad por la cantidad de hechizos que conoce.
    b. daño: Esta funcion retorna la cantidad de vida que un mago pierde si le lanzan un hechizo.
    c. diferenciaDePoder: La diferencia de poder entre dos magos es el valor absoluto de la resta del poder de cada uno. Esto siempre retorna un número positivo.

3. Dada una Academia, la cual representamos con el siguiente tipo de dato:

    data Academia = Academia{
        magos :: [Mago],
        examenDeIngreso :: Mago -> Bool
    }
Se pide escribir el codigo necesario para realizar las siguientes consultas sin usar recursividad:
    a. Saber si hay algún mago sin hechizos cuyo nombre sea "Rincenwind"
    b. Saber si todos los magos viejos (>50) son ñoños. Esto ocurre si tienen más hechizos que salud.
    c. Conocer la cantidad de magos que no pasarian el examen de ingreso si lo volvieran a rendir
    d. Averiguar la sumatoria de la edad de los magos que saben más de 10 hechizos

4. Dadas las siguientes funciones:

    maximoSegun criterio valor comparables = foldl1 (mayorSegun $ criterio valor) comparables

    mayorSegun evaluador comparable1 comparable2
        | evaluador comparable1 >= evaluador comparable2 = comparable1
        | otherwise = comparable2

Usar la funcion maximoSegun para definir las siguientes funciones, sin repetir código ni definir funciones auxiliares:
    i. mejorHechizoContra: Dados dos magos, retorna el hechizo del segundo que le haga más daño al primero.
    ii. mejorOponente: Dado un mago y una academia, retorna el mago de la academia que tenga la mayor diferencia de  poder con el mago recibido.

5. Definir la siguiente función sin utilizar recursividad:

    noPuedeGanarle: Decimos que el segundo mago no puede ganarle al primero si, luego de hechizarlo con todos los hechizos que conoce (uno atrás del otro) la salud del primer mago sigue siendo la misma.
-}


data Mago = Mago{
    nombre :: String,
    edad :: Int,
    cantidadSalud :: Int,
    hechizos :: [Hechizo]
} deriving Show 

type Hechizo = Mago -> Mago


-- Punto 1 --

-- a
curar :: Int -> Hechizo
curar cantidadSalud = modificarSalud (+ cantidadSalud)

modificarSalud :: (Int -> Int) -> Mago -> Mago
modificarSalud funcion mago = mago {cantidadSalud = max 0 . funcion . cantidadSalud $ mago}

-- b
lanzarRayo :: Hechizo
lanzarRayo mago
  | cantidadSalud mago > 10 = modificarSalud (subtract 10) $ mago
  | otherwise = modificarSalud (`div` 2) $ mago

--c
amnesia :: Int -> Hechizo
amnesia cantidadHechizos mago = modificarHechizos (drop cantidadHechizos) $ mago

modificarHechizos :: ([Hechizo] -> [Hechizo]) -> Mago -> Mago
modificarHechizos funcion mago = mago { hechizos = funcion . hechizos $ mago }

--d
confundir :: Hechizo
confundir mago = foldr ($) mago (take 1 (hechizos mago))

-- Punto 2 --
--a
poder :: Mago -> Int
poder mago = cantidadSalud mago + edad mago * length (hechizos mago)


--b
daño :: Hechizo -> Mago -> Int
daño hechizo mago = cantidadSalud mago - cantidadSalud (hechizo mago)

-- c
diferenciaDePoder :: Mago -> Mago -> Int
diferenciaDePoder mago1 mago2 = abs (poder mago1 - poder mago2)

-- Ejemplo
harry :: Mago
harry = Mago "Harry" 26 80 [curar 10, lanzarRayo, amnesia 5, confundir]

-- Punto 3 --
data Academia = Academia{
    magos :: [Mago],
    examenDeIngreso :: Mago -> Bool
    }


--Parte A

esRincewindSinHechizos :: Mago -> Bool
esRincewindSinHechizos mago = nombre mago == "Rincewind" && null (hechizos mago)

hayRincewindSinHechizos :: Academia -> Bool
hayRincewindSinHechizos academia = any esRincewindSinHechizos . magos $ academia

--Parte b

esViejoÑoño :: Mago -> Bool
esViejoÑoño mago = edad mago > 50 && length (hechizos mago) > cantidadSalud mago

todosLosViejosSonÑoños :: Academia -> Bool
todosLosViejosSonÑoños = all esViejoÑoño . magos

--Parte c
magosQueNoPasanExamen :: Academia -> Int
magosQueNoPasanExamen academia = length . filter (noPasaExamen (examenDeIngreso academia)) $ magos academia

noPasaExamen :: (Mago -> Bool) -> Mago -> Bool
noPasaExamen examenDeIngreso mago = not (examenDeIngreso mago)

--Parte d
sumaEdadesDeMagosConMasDe10Hechizos :: Academia -> Int
sumaEdadesDeMagosConMasDe10Hechizos academia = sum $ map edad $ magosConMasDe 10 (magos academia)

tieneMasDe :: Int -> Mago -> Bool
tieneMasDe nHechizos mago = length (hechizos mago) > nHechizos

magosConMasDe :: Int -> [Mago] -> [Mago]
magosConMasDe nHechizos = filter (tieneMasDe nHechizos)


-- Punto 4 --

maximoSegun :: (a -> Int) -> [a] -> a
maximoSegun criterio = foldl1 (mayorSegun criterio)

mayorSegun :: (a -> Int) -> a -> a -> a
mayorSegun evaluador comparable1 comparable2
    | evaluador comparable1 >= evaluador comparable2 = comparable1
    | otherwise = comparable2


mejorHechizoContra :: Mago -> Mago -> Hechizo
mejorHechizoContra objetivo oponente = maximoSegun (`daño` objetivo) (hechizos oponente)

mejorOponente :: Mago -> Academia -> Mago
mejorOponente mago academia = maximoSegun (diferenciaDePoder mago) (magos academia)

-- Punto 5 --

aplicarHechizos :: [Hechizo] -> Mago -> Mago
aplicarHechizos hechizos mago = foldl (flip ($)) mago hechizos

noPuedeGanarle :: Mago -> Mago -> Bool
noPuedeGanarle unMago otroMago = cantidadSalud unMago == cantidadSalud (aplicarHechizos (hechizos otroMago) unMago)

-- Defini algunos magos de prueba
mago1 :: Mago
mago1 = Mago {
    nombre = "Gandalf",
    edad = 80,
    cantidadSalud = 100,
    hechizos = [curar 20, lanzarRayo]
}

mago2 :: Mago
mago2 = Mago {
    nombre = "Harry",
    edad = 20,
    cantidadSalud = 60,
    hechizos = [confundir, lanzarRayo, amnesia 1]
}

mago3 :: Mago
mago3 = Mago {
    nombre = "Rincewind",
    edad = 50,
    cantidadSalud = 40,
    hechizos = [lanzarRayo]
}

mago4 :: Mago
mago4 = Mago {
    nombre = "Winnie Pooh",
    edad = 25,
    cantidadSalud = 10,
    hechizos = [curar 10, confundir, lanzarRayo, amnesia 2]
}

-- Cree una academia de prueba
miAcademia :: Academia
miAcademia = Academia {
    magos = [mago1, mago2, mago3, mago4],
    examenDeIngreso = criterioDeIngreso
}

-- Defini el criterio de examen de ingreso
criterioDeIngreso :: Mago -> Bool
criterioDeIngreso mago = cantidadSalud mago > 50 && edad mago < 30





