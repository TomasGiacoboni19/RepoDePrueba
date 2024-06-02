import Text.Show.Functions()
import Data.Char



data Juguete = Juguete{
    nombre :: String,
    duenio  :: String,
    nivelFacha :: Int,
    accesorios :: [Accesorio],
    vivo :: Bool
} deriving(Show)

type Efecto = Int -> Juguete -> Juguete

data Accesorio = Accesorio{
    efectoJuguetes :: Efecto,
    eficacia       :: Int
} deriving (Show) 

-- Punto 1
lucirAmenzante :: Efecto
lucirAmenzante eficacia  = modificarFacha ( + (10 + eficacia) )       


modificarFacha :: (Int -> Int) -> Juguete -> Juguete
modificarFacha unaFuncion juguete = juguete {nivelFacha = unaFuncion . nivelFacha $ juguete}
                                    

setNombre :: String -> Juguete -> Juguete
setNombre nuevoNombre juguete = modificarNombre (const nuevoNombre) juguete

modificarNombre :: (String -> String) -> Juguete -> Juguete
modificarNombre unaFuncion juguete = juguete {nombre = unaFuncion . nombre $ juguete}


setVivo :: Bool -> Juguete -> Juguete
setVivo unValor juguete = juguete {vivo = unValor}

vieneAndy :: Efecto
vieneAndy _ = setVivo False

masSteel :: Efecto
masSteel eficacia juguete = setNombre "Max Steel" . modificarFacha (+ eficacia * longitudNombre juguete) $ juguete

longitudNombre :: Juguete -> Int
longitudNombre = length.nombre

quemadura :: Int -> Int -> Juguete -> Juguete
quemadura gradoQuemadura eficacia juguete = modificarFacha  (+ (negate gradoQuemadura * (eficacia + 2)) ) juguete

-- Punto 2
serpienteEnBota :: Accesorio
serpienteEnBota = Accesorio lucirAmenzante 2

-- Punto 3
woody :: Juguete
woody = Juguete "Woody" "Andy" 100 [serpienteEnBota] True

-- Punto 4
esImpaktante :: Juguete -> Bool
esImpaktante unJuguete = any ((> 10) . eficacia) (accesorios unJuguete)

esDislexico :: Juguete -> Bool
esDislexico  juguete =  all (\letra -> elem letra "andy") (duenio juguete)  && ((== largoAndy).length.duenio) juguete 

largoAndy = length "andy"


--esDisxelico :: Juguete -> Bool
--esDisxelico juguete = tieneEnDesorden "andy" (duenio juguete)
--tieneEnDesorden letras palabra =
--    letras /= palabra &&
--    length palabra == length letras &&
--    all (\letra -> elem letra letras) palabra


type Cajon = [Juguete]

cantidadDeAlgo :: (Juguete -> Bool) -> Cajon -> Int
cantidadDeAlgo criterio  = length . filter criterio 

mayorASeis :: [Juguete] -> Int
mayorASeis juguete = cantidadDeAlgo ((>6) . longitudNombre) juguete 
