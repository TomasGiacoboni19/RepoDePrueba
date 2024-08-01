import Text.Show.Functions()
import Data.Char

{- enunciado: https://docs.google.com/document/d/1mBwfHLXmcZKLHSy22exTxibwny9x2a81hKW000tOFMQ/edit?pli=1 -}

-- Punto 1 --
{-
Se sabe que los bárbaros tienen nombre, fuerza, habilidades y objetos, que los ayudarán más adelante en su lucha contra el mal. Por ejemplo: 

dave = Barbaro "Dave" 100 ["tejer","escribirPoesia"] [ardilla, varitasDefectuosas]

Se pide definir los siguientes objetos y definir algunos bárbaros de ejemplo
a. Las espadas aumentan la fuerza de los bárbaros en 2 unidades por cada kilogramo de peso.
b. Los amuletosMisticos puerco-marranos otorgan una habilidad dada a un bárbaro.
c. Las varitasDefectuosas, añaden la habilidad de hacer magia, pero desaparecen todos los demás objetos del bárbaro.
d. Una ardilla, que no hace nada.
e. Una cuerda, que combina dos objetos distintos,obteniendo uno que realiza las transformaciones de los otros dos. 

-}

data Barbaro = Barbaro{
    nombre :: String,
    fuerza :: Int,
    habilidades :: [Habilidad],
    objetos :: [Objeto]
} deriving Show

type Habilidad = String

type Objeto = Barbaro -> Barbaro

dave :: Barbaro
dave = Barbaro "Dave" 100 ["tejer","escribirPoesia"] [ardilla, varitasDefectuosas]

faffy :: Barbaro
<<<<<<< HEAD
faffy = Barbaro "faffy" 50 ["Vuelo", "Manipulacion electrica"] [amuletosMisticos "resistencia"]
=======
faffy = Barbaro "Faffy" 50 ["Electricidad", "Escribir Poesía Atroz", "Robar"] [espadas 10]

astro :: Barbaro
astro = Barbaro "Astro" 200 ["Comer", "Escribir Poesía Atroz", "Robar"] [amuletosMisticos "Programar", megafono, megafonoBarbarico]

candy :: Barbaro
candy = Barbaro "Astro" 81 ["Comer", "Escribir Poesía Atroz"] [amuletosMisticos "Programar", megafono, megafonoBarbarico]
>>>>>>> 1524cf7fc1d9e448383978ad0582bcda46aad085

-- Parte a --

espadas :: Int -> Objeto
espadas peso barbaro = cambiarFuerza(+ (2*peso)) barbaro

cambiarFuerza :: (Int -> Int) -> Barbaro -> Barbaro
cambiarFuerza funcion barbaro = barbaro {fuerza = funcion . fuerza $ barbaro}

-- Parte b --
-- b. Los amuletosMisticos puerco-marranos otorgan una habilidad dada a un bárbaro.

amuletosMisticos :: Habilidad -> Objeto
--amuletosMisticos habilidad barbaro = cambiarHabilidades (habilidad:) barbaro
-- Podemos ser más expresivos y delegarlo en una nueva función ^^^^ 
amuletosMisticos habilidad barbaro = agregarHabilidad habilidad barbaro

agregarHabilidad :: Habilidad -> Objeto     
agregarHabilidad habilidad barbaro =  cambiarHabilidades (habilidad:) barbaro

cambiarHabilidades :: ([Habilidad] -> [Habilidad]) -> Barbaro -> Barbaro
cambiarHabilidades funcion barbaro = barbaro {habilidades = funcion . habilidades $ barbaro}

-- Parte c --
--c. Las varitasDefectuosas, añaden la habilidad de hacer magia, pero desaparecen todos los demás objetos del bárbaro.
varitasDefectuosas :: Objeto
varitasDefectuosas barbaro = vaciarObjetos . agregarHabilidad "Hacer magia" $ barbaro

vaciarObjetos :: Objeto
<<<<<<< HEAD
vaciarObjetos barbaro = barbaro {objetos = []}
=======
vaciarObjetos barbaro = barbaro{objetos=[]}
>>>>>>> 1524cf7fc1d9e448383978ad0582bcda46aad085

-- Parte d --
--d. Una ardilla, que no hace nada.
ardilla :: Objeto
<<<<<<< HEAD
ardilla barbaro = id barbaro

-- Parte e --
-- e. Una cuerda, que combina dos objetos distintos,obteniendo uno que realiza las transformaciones de los otros dos. 
cuerda :: Objeto -> Objeto -> Objeto
cuerda unObjeto otroObjeto = unObjeto . otroObjeto
=======
ardilla barbaro = id barbaro 

-- Parte e --
--e.Una cuerda, que combina dos objetos distintos,obteniendo uno que realiza las transformaciones de los otros dos. 
cuerda :: Objeto -> Objeto -> Objeto
cuerda unObjeto otroObjeto = unObjeto . otroObjeto 
>>>>>>> 1524cf7fc1d9e448383978ad0582bcda46aad085

-- Punto 2 --
{-
El megafono es un objeto que potencia al bárbaro, concatenando sus habilidades y poniéndolas en mayúsculas. 
<<<<<<< HEAD

*Main> megafono dave
Barbaro "Dave" 100 ["TEJERESCRIBIRPOESIA"] [<function>,<function>]

Sabiendo esto, definir al megafono, y al objeto megafonoBarbarico, que está formado por una cuerda, una ardilla y un megáfono.
-}
megafono :: Objeto -> Barbaro -> Barbaro
megafono objeto barbaro = toUpper habilidades barbaro 
=======
*Main> megafono dave
Barbaro "Dave" 100 ["TEJERESCRIBIRPOESIA"] [<function>,<function>]
Sabiendo esto, definir al megafono, y al objeto megafonoBarbarico, que está formado por una cuerda, una ardilla y un megáfono. 
-}

megafono :: Objeto
megafono barbaro = cambiarHabilidades ((: []) . map toUpper. concat) barbaro

megafonoBarbarico :: Objeto
megafonoBarbarico barbaro = cuerda ardilla megafono $ barbaro 

-- Punto 3--
{-
Los bárbaros suelen ir de aventuras por el reino luchando contra las fuerzas del mal, pero ahora que tienen nuestra ayuda, quieren que se les diga si un grupo de bárbaros puede sobrevivir a cierta aventura.  Una aventura se compone de uno o más eventos, por ejemplo:

> invasionDeSuciosDuendes: Un bárbaro sobrevive si sabe “Escribir Poesía Atroz”
> cremalleraDelTiempo: Un bárbaro sobrevive si no tiene pulgares. Los bárbaros llamados Faffy y Astro no tienen pulgares, los demás sí. 
> ritualDeFechorias: Un bárbaro puede sobrevivir si pasa una o más pruebas como las siguientes: 
* saqueo: El bárbaro debe tener la habilidad de robar y tener más de 80 de fuerza.
* gritoDeGuerra: El bárbaro debe tener un poder de grito de guerra igual a la cantidad de letras de sus habilidades. El poder necesario para aprobar es 4 veces la cantidad de objetos del bárbaro.
* caligrafia: El bárbaro tiene caligrafía perfecta (para el estándar barbárico de la época) si sus habilidades contienen más de 3 vocales y comienzan con mayúscula.

Sabiendo esto, se pide:
Definir los eventos, modelar las aventuras y dar un ejemplo. 
Definir la función sobrevivientes que tome una lista de bárbaros y una aventura, y diga cuáles bárbaros la sobreviven (es decir, pasan todas las pruebas)
-}

type Evento = Barbaro -> Bool

type Aventura = [Evento]

invasionDeSuciosDuendes :: Evento
invasionDeSuciosDuendes barbaro = elem "Escribir Poesía Atroz" . habilidades $ barbaro

cremalleraDelTiempo :: Evento
--cremalleraDelTiempo (Barbaro "Faffy" _ _ _) = True
--cremalleraDelTiempo (Barbaro "Astro" _ _ _) = True
--cremalleraDelTiempo (Barbaro _ _ _ _) = False
cremalleraDelTiempo barbaro = tienePulgares $ barbaro

tienePulgares :: Barbaro -> Bool
tienePulgares (Barbaro "Faffy" _ _ _) = True
tienePulgares (Barbaro "Astro" _ _ _) = True
tienePulgares (Barbaro _ _ _ _) = False


ritualDeFechorias :: [Prueba] -> Evento
ritualDeFechorias prueba barbaro = any (superoPruebas barbaro) prueba
type Prueba = Barbaro -> Bool

superoPruebas :: Barbaro -> Prueba -> Bool
superoPruebas barbaro prueba = prueba barbaro

saqueo :: Prueba
saqueo barbaro = nivelDeFuerza 80 barbaro && (elem "Robar" . habilidades) barbaro

nivelDeFuerza :: Int -> Barbaro -> Bool
nivelDeFuerza nivel barbaro = (nivel <) . fuerza $ barbaro
>>>>>>> 1524cf7fc1d9e448383978ad0582bcda46aad085
