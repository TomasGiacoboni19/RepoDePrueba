data Investigador = Investigador{
    nombre               :: String,
    experiencia          :: Int,
    pokemonCompañero     :: Pokemon,
    pokemones            :: [Pokemon]
    --mochila              :: [Item]
} deriving (Show)

data Pokemon = Pokemon{
    mote            :: String,
    descripcion     :: String,
    nivel           :: Int,
    puntosQueOtorga :: Int
} deriving (Show)


type Punto = Float

akari :: Investigador
akari = Investigador "Akari" 1499 oschawatt [oschawatt]

oschawatt :: Pokemon
oschawatt = Pokemon "Oschawatt" "Una nutria que pelea con el caparazón de su pecho" 5 3

