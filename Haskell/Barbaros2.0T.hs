import Text.Show.Functions()

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
faffy = Barbaro "faffy" 50 ["Vuelo", "Manipulacion electrica"] [amuletosMisticos "resistencia"]

-- Parte a --

espadas :: Int -> Objeto
espadas peso barbaro = barbaro {fuerza = fuerza barbaro + 2 * peso}

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
vaciarObjetos barbaro = barbaro {objetos = []}

-- Parte d --
--d. Una ardilla, que no hace nada.
ardilla :: Objeto
ardilla barbaro = id barbaro

-- Parte e --
-- e. Una cuerda, que combina dos objetos distintos,obteniendo uno que realiza las transformaciones de los otros dos. 
cuerda :: Objeto -> Objeto -> Objeto
cuerda unObjeto otroObjeto = unObjeto . otroObjeto

-- Punto 2 --
{-
El megafono es un objeto que potencia al bárbaro, concatenando sus habilidades y poniéndolas en mayúsculas. 

*Main> megafono dave
Barbaro "Dave" 100 ["TEJERESCRIBIRPOESIA"] [<function>,<function>]

Sabiendo esto, definir al megafono, y al objeto megafonoBarbarico, que está formado por una cuerda, una ardilla y un megáfono.
-}
megafono :: Objeto -> Barbaro -> Barbaro
megafono objeto barbaro = toUpper habilidades barbaro 
