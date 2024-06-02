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
dave = Barbaro "Dave" 100 ["tejer","escribirPoesia"] []

lula :: Barbaro
lula = Barbaro "Lula" 50 ["Inmortabilidad", "Regeneracion"] [espadas 10]

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