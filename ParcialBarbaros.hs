module Lib where 
import Text.Show.Functions()
import Data.Char

doble :: Int -> Int
doble = (*2)

{-
Punto 1

Se sabe que los bárbaros tienen nombre, fuerza, habilidades y objetos, que los ayudarán más adelante en su lucha contra el mal. Por ejemplo: 

dave = Barbaro "Dave" 100, ["tejer","escribirPoesia"] [ardilla, libroPedKing]

Se pide definir los siguientes objetos y definir algunos bárbaros de ejemplo
1) Las espadas aumentan la fuerza de los bárbaros en 2 unidades por cada kilogramo de peso.
2) Los amuletosMisticos puerco-marranos otorgan una habilidad dada a un bárbaro.
3) Las varitasDefectuosas, añaden la habilidad de hacer magia, pero desaparecen todos los demás objetos del bárbaro.
4) Una ardilla, que no hace nada.
5) Una cuerda, que combina dos objetos distintos, obteniendo uno que realiza las transformaciones de los otros dos.
-}


type Habilidad = String
type Objeto = Barbaro -> Barbaro

data Barbaro = Barbaro {
    nombre :: String,
    fuerza :: Int,
    habilidades :: [Habilidad],
    objetos :: [Objeto]

} deriving (Show)

juanito :: Barbaro
juanito = Barbaro "Juan" 50 ["tejer"] [espadas 10]

faffy :: Barbaro
faffy = Barbaro "Faffy" 50 ["tejer"] [espadas 5]

espadas :: Int -> Objeto
espadas peso barbaro = barbaro {fuerza = fuerza barbaro + peso *2}

agregarHabilidad :: Habilidad -> Objeto
agregarHabilidad habilidad barbaro = cambiarHabilidades (habilidad:) barbaro

amuletosMisticos :: Habilidad -> Objeto
amuletosMisticos habilidad barbaro = agregarHabilidad habilidad barbaro

varitasDefectuosas :: Objeto
varitasDefectuosas barbaro = vaciarObjetos . agregarHabilidad "Hacer magia" $ barbaro

vaciarObjetos :: Objeto
vaciarObjetos barbaro = barbaro {objetos = []}

ardilla :: Objeto
ardilla barbaro = id barbaro

cuerda :: Objeto -> Objeto -> Objeto
cuerda objeto1 objeto2 = objeto1 . objeto2 

{- 
Punto 2

El megafono es un objeto que potencia al bárbaro, concatenando sus habilidades y poniéndolas en mayúsculas. 

> megafono dave
Barbaro "Dave" 100 ["TEJERESCRIBIRPOESIA"] [ardilla, libroPedKing]

Sabiendo esto, definir al megafono, y al objeto megafonoBarbarico, que está formado por una cuerda, una ardilla y un megáfono. 
-}

megafono :: Objeto
megafono barbaro = cambiarHabilidades ((:[]) . map toUpper . concat) barbaro

cambiarHabilidades :: ([Habilidad] -> [Habilidad]) -> Barbaro -> Barbaro
cambiarHabilidades funcion barbaro = barbaro {habilidades = funcion . habilidades $ barbaro}

megafonoBarbarico :: Objeto
megafonoBarbarico barbaro = cuerda ardilla megafono barbaro

{- 
Punto 3

Los bárbaros suelen ir de aventuras por el reino luchando contra las fuerzas del mal, pero ahora que tienen nuestra ayuda, quieren que se les diga si un grupo de bárbaros puede sobrevivir a cierta aventura.  Una aventura se compone de uno o más eventos, por ejemplo:

invasionDeSuciosDuendes: Un bárbaro sobrevive si sabe “Escribir Poesía Atroz”
cremalleraDelTiempo: Un bárbaro sobrevive si no tiene pulgares. Los bárbaros llamados Faffy y Astro no tienen pulgares, los demás sí. 
ritualDeFechorias: Un bárbaro puede sobrevivir si pasa una o más pruebas como las siguientes: 
saqueo: El bárbaro debe tener la habilidad de robar y tener más de 80 de fuerza.
gritoDeGuerra: El bárbaro debe tener un poder de grito de guerra igual a la cantidad de letras de sus habilidades. El poder necesario para aprobar es 4 veces la cantidad de objetos del bárbaro.
caligrafia: El bárbaro tiene caligrafía perfecta (para el estándar barbárico de la época) si sus habilidades contienen más de 3 vocales y comienzan con mayúscula.

Sabiendo esto, se pide:
Definir los eventos, modelar las aventuras y dar un ejemplo. 
Definir la función sobrevivientes que tome una lista de bárbaros y una aventura, y diga cuáles bárbaros la sobreviven (es decir, pasan todas las pruebas)
-}

type Aventura = [Evento]
type Evento = Barbaro -> Bool

invasionDeSuciosDuendes :: Evento
invasionDeSuciosDuendes barbaro = (elem "Escribir Poesia Atroz" . habilidades) barbaro

cremalleraDelTiempo :: Evento
cremalleraDelTiempo barbaro = not . tienePulgares $ barbaro

tienePulgares :: Barbaro -> Bool
tienePulgares (Barbaro "Faffy" _ _ _) = False
tienePulgares (Barbaro "Astro" _ _ _) = False
tienePulgares    _    = True

type Prueba = Barbaro -> Bool

nivelDeFuerza :: Int -> Barbaro -> Bool
nivelDeFuerza nivel barbaro = (nivel>=). fuerza $ barbaro

saqueo :: Prueba
saqueo barbaro = nivelDeFuerza 80 barbaro && (elem "robar" . habilidades) barbaro

ritualDeFechorias :: [Prueba] -> Evento
ritualDeFechorias pruebas barbaro = any (superoPruebas barbaro) pruebas  

superoPruebas :: Barbaro -> Prueba -> Bool
superoPruebas barbaro prueba = prueba barbaro

{-
Punto 4 - Dinastia

A - Los bárbaros se marean cuando tienen varias habilidades iguales. Por todo esto, nos piden desarrollar una función que elimine los elementos repetidos de una lista (sin utilizar nub ni nubBy)

> sinRepetidos [1,2,3,4,4,5,5,6,7]
[1,2,3,4,5,6,7]

Nota: Puede usarse revursividad para este punto.
-}
sinRepetidos :: Eq a => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (x:xs)
  | elem x xs = sinRepetidos xs
  | otherwise = x : sinRepetidos xs

sinRepetidos' :: Eq a => [a] -> [a]
sinRepetidos' [] = []
sinRepetidos' (x:xs) = x : sinRepetidos' (filter (/= x) xs)

{-

B - Los bárbaros son una raza muy orgullosa, tanto que quieren saber cómo van a ser sus descendientes y asegurarse de que los mismos reciban su legado.

El descendiente de un bárbaro comparte su nombre, y un asterico por cada generación. Por ejemplo "Dave*", "Dave**", "Dave***", etc.

Además, tienen en principio su mismo poder, habilidades sin repetidos, y los objetos de su padre, pero antes de pasar la siguiente generación, utilizan (aplican sobre si mismos) los objetos. Por ejemplo, el hijo de Dave será equivalente a:

(ardilla.varitasDefectuosas) (Barbaro "Dave" 100 ["tejer", "escribirPoesia"] [ardilla])

Definir la función descendientes, que dado un bárbaro nos de sus infinitos descendientes.
-}


{-

C - Pregunta: ¿Se podría aplicar sinRepetidos sobre la lista de objetos? ¿Y sobre el nombre de un bárbaro? ¿Por qué?

-}