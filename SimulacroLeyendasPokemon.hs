import Text.Show.Functions()
----PUNTO 1----
data Investigador = Investigador{
    nombre               :: String,
    experiencia          :: Float,
    pokemonCompañero     :: Pokemon,
    pokemones            :: [Pokemon],
    mochila              :: [Item]
} deriving (Show)

data Pokemon = Pokemon{
    mote            :: String,
    descripcion     :: String,
    nivel           :: Float,
    puntosQueOtorga :: Float
} deriving (Show)


type Punto = Float

akari :: Investigador
akari = Investigador "Akari" 1499 oschawatt [oschawatt] []

oschawatt :: Pokemon
oschawatt = Pokemon "Oschawatt" "Una nutria que pelea con el caparazón de su pecho" 5 3

----PUNTO 2----

data Rango = Cielo | Estrella | Constelacion | Galaxia

rango :: Investigador -> Rango
rango investigador 
    | experiencia investigador <  100   = Cielo
    | experiencia investigador <  500   = Estrella
    | experiencia investigador <  2000  = Constelacion
    | otherwise                         = Galaxia

----PUNTO 3----

type Actividad = Investigador -> Investigador
type Item = Float -> Float 

obtenerUnItem :: Item -> Actividad  
obtenerUnItem item investigador = cambiarMochila (item :) . cambiarExperiencia (item) $ investigador
baya :: Item
baya = (^2).(+1)

apricorns :: Item
apricorns = (*1.5)

guijarros :: Item
guijarros = (+2)

fragmentosDeHierro :: Float -> Item
fragmentosDeHierro cantidad = (/ cantidad)

admirarElPaisaje :: Actividad
admirarElPaisaje investigador = cambiarMochila (drop 3) . cambiarExperiencia (*0.95) $ investigador

cambiarMochila :: ([Item]->[Item]) -> Investigador -> Investigador
cambiarMochila funcion investigador = Investigador { mochila = funcion (mochila investigador)}

cambiarExperiencia :: (Float->Float) -> Investigador -> Investigador
cambiarExperiencia funcion investigador = Investigador { experiencia = funcion (experiencia investigador)}

