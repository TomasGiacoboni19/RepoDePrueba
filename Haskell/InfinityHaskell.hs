import Text.Show.Functions()
--import Data.Char

{-
1. Modelar Personaje, estos tienen: nombre, una cantidad de poder y una lista de derrotas (léase, las veces que derrotó a alguien). Cada derrota tiene el nombre de su oponente y el año en el que ocurrió.
-}

data Personaje = Personaje {
    nombre :: String,
    poder :: Int,
    derrotas :: [Derrota],
    equipamientos :: [Equipamiento]
} deriving Show

type Derrota = (String, Int)

nombreDerrotado :: Derrota -> String
nombreDerrotado = fst

ironMan :: Personaje
ironMan = Personaje "Iron Man" 1000 [("Hijo de Thanos", 2014)]  [trajeMecanizado 3]

thanos :: Personaje
thanos = Personaje "Thanos" 1500 [("Hijo de Thanos", 2014)]  []

hulk :: Personaje
hulk = Personaje "Hulk" 800 [("Hijo de Thanos", 2014)] [trajeMecanizado 1]

thor :: Personaje
thor = Personaje "Thor" 700 [("Caida del martillo", 2014), ("Hijo de Thanos", 2014)] [escudo]

capitanAmerica :: Personaje
capitanAmerica = Personaje "Capitan America" 500 [("Perdida del escudo", 2014), ("Hijo de Thanos", 2014)] [escudo]

{-
2. Modelar entrenamiento, el cual lo realizan un grupo de personajes y multiplica el poder de cada uno de ellos por la cantidad de personajes que están entrenando al mismo tiempo.
-}

entrenamiento :: [Personaje] -> [Personaje]
entrenamiento personajes = map(multiplicadorDePoder $ length personajes) personajes

multiplicadorDePoder :: Int -> Personaje -> Personaje
multiplicadorDePoder cantidadDePJ personaje = modificarPoder(* cantidadDePJ) personaje

modificarPoder :: (Int -> Int) -> Personaje -> Personaje
modificarPoder funcion personaje = personaje {poder = funcion . poder $ personaje}

{-
3. Modelar rivalesDignos, que dado un grupo de personajes nos dice quienes son rivales para Thanos. Son dignos aquellos personajes que, luego de haber entrenado,  tienen un poder mayor a 500 y además alguna de sus derrotas se llame "Hijo de Thanos".
-}

rivalesDignos :: [Personaje] -> [Personaje]
rivalesDignos personajes = filter esRivalDigno . entrenamiento $ personajes

esRivalDigno :: Personaje -> Bool
esRivalDigno personaje = esFuerte personaje && suDerrotaSeLLama personaje

esFuerte :: Personaje -> Bool
esFuerte personaje = (>500) . poder $ personaje

suDerrotaSeLLama :: Personaje -> Bool
suDerrotaSeLLama personaje = elem "Hijo de Thanos" . map nombreDerrotado . derrotas $ personaje

{-
4. Modelar guerraCivil, la cual dado un año y dos conjuntos de personajes hace que cada personaje pelee con su contraparte de la otra lista y nos dice quienes son los ganadores. Cuando dos personajes pelean, gana el que posee mayor poder y se le agregará la derrota del perdedor a su lista de derrotas con el año en el que ocurrió. Por ejemplo...


guerraCivil 2018 [scarletWitch, capitanAmerica, blackWidow] [vision, ironMan, spiderman] 

...hará que Scarlet Witch pelee contra Vision, el Capitán América contra Iron Man y Black Widow contra Spiderman.

-}

modificarDerrotas :: ([Derrota] -> [Derrota]) -> Personaje -> Personaje
modificarDerrotas funcion personaje = personaje {derrotas = funcion . derrotas $ personaje}

guerraCivil :: Int -> [Personaje] -> [Personaje] -> [Personaje]
guerraCivil anio personaje1 personaje2 = zipWith (pelea anio) personaje1 personaje2 

pelea :: Int -> Personaje -> Personaje -> Personaje
pelea año personaje1 personaje2
    | leGana personaje1 personaje2 = derrotarA año personaje1 personaje2
    | otherwise = derrotarA año personaje2 personaje1

leGana :: Personaje -> Personaje -> Bool
leGana personaje1 personaje2 = poder personaje1 > poder personaje2

derrotarA :: Int -> Personaje -> Personaje -> Personaje
derrotarA anio personaje1 personaje2 = modificarDerrotas((nombre personaje2, anio) :) personaje1

{-
Parte B 

Ahora aparecen los equipamientos: estos son objetos de poder que dado un personaje modifican sus habilidades de manera extraordinaria. Asimismo, sabemos que los personajes tienen varios equipamientos.

1. Escribir el tipo de un Equipamiento y modificar el modelo de Personaje para que acepte equipamientos.
-}
type Equipamiento = Personaje -> Personaje

{-
2. Tenemos equipamientos generales como por ejemplo escudo y trajeMecanizado. Modelar los siguientes equipamientos.

escudo: si tiene menos de 5 derrotas le suma 50 de poder, pero si tiene 5 o más le resta 100 de poder. 
trajeMecanizado: devuelve el personaje anteponiendo "Iron" al nombre del personaje y le agrega una versión dada al final del mismo. Por ejemplo:
Si el personaje se llama "Groot" y la versión del traje es 2 , su nombre quedaría "Iron Groot V2"
-}

escudo :: Equipamiento
escudo personaje
    | fueDerrotadoPorMuchos personaje = modificarPoder(subtract 100) personaje
    | otherwise = modificarPoder(+ 50) personaje

fueDerrotadoPorMuchos :: Personaje -> Bool
fueDerrotadoPorMuchos personaje = (5>=) . length .  derrotas $ personaje

trajeMecanizado :: Int -> Equipamiento
trajeMecanizado version personaje = modificarNombre(\nombre -> "Iron " ++ nombre ++ " V" ++ show version) personaje

modificarNombre :: (String -> String) -> Personaje -> Personaje
modificarNombre funcion personaje = personaje {nombre = funcion . nombre $ personaje}

{-
3. También tenemos equipamientos exclusivos que solo lo pueden usar determinados personajes, por ejemplo: stormBreaker solo lo puede usar Thor, guantelete del Infinito sólo lo puede usar Thanos, gemaDelAlma sólo lo puede usar Thanos. Modelar:

stormBreaker: Le agrega "dios del trueno" al final del nombre y limpia su historial de derrotas ya que un dios es bondadoso.
gemaDelAlma: Añade a la lista de derrotas a todos los extras, y cada uno con un año diferente comenzando con el actual. Considerar que hay incontables extras. Por ejemplo: 

[("extra numero 1", 2018), ("extra numero 2", 2019), …]

guanteleteInfinito: Aplica todos los equipamientos que sean gemas del infinito al personaje. Usar la función sin definirla esGemaDelInfinito la cual recibe un equipamiento y nos dice si la misma es o no una gema del infinito. 

>> esGemaDelInfinito escudo
False
>> esGemaDelInfinito gemaDelAlma
True

-}

equipamientoExclusivo :: String -> Personaje  -> Equipamiento -> Equipamiento
equipamientoExclusivo nombrePersonaje personaje equipamiento 
    | nombre personaje == nombrePersonaje = equipamiento
    | otherwise = id

stormBreaker :: Equipamiento
stormBreaker personaje = 
    equipamientoExclusivo "Thor" personaje (modificarNombre(++ " dios del trueno")) . modificarDerrotas(const[]) $ personaje

gemaDelAlma :: Equipamiento
gemaDelAlma personaje = equipamientoExclusivo "Thanos" personaje (modificarDerrotas (++ derrotasExtras)) $ personaje

derrotasExtras :: [Derrota]
derrotasExtras  = zip extras [2014..] 

extras :: [String]
extras = map  (("extra numero "++) . show) [1..]

guanteleteInfinito :: Equipamiento
guanteleteInfinito personaje = equipamientoExclusivo "Thanos" personaje usarGemasDelInfinito $ personaje

usarGemasDelInfinito :: Personaje -> Personaje
usarGemasDelInfinito personaje = foldr ($) personaje $ gemasDelInfinito personaje

gemasDelInfinito :: Personaje -> [Equipamiento]
gemasDelInfinito  = filter esGemaDelInfinito . equipamientos

esGemaDelInfinito :: Equipamiento -> Bool
esGemaDelInfinito = undefined

{-
Parte C
  a. Se cuelga porque definí derrotoAMuchos con un length, y el length de una lista infinita no termina de evaluar.
     Se puede definir derrotoAMuchos de forma de que sea lazy y pueda terminar de evaluar, como:
     derrotoAMuchos = not . null . drop 5 . derrotas
  b. Si no es fuerte luego de entrenar con el resto del equipo, termina bien.
     Si es fuerte y el hijo de thanos se encuentra entre sus derrotados, termina bien.
     En caso contrario, no termina.
  c. Si. Porque haskell trabaja con evaluación perezosa, y no es necesario evaluar toda la lista para tomar los primeros 100 elementos.
-}

{-
Sobre `zip`, y `zipWith`:
`zip` es una función que toma dos listas y nos devuelve el resultado de "aparearlas" (va agarrando de a un elemento en cada una y devuelve un par ordenado con ambos valores):
zip :: [a] -> [b] -> [(a, b)]
> zip [1, 2, 3, 4] ["hola", "como", "te", "va?"]
[(1, "hola"), (2, "como"), (3, "te"), (4, "va?")]
En caso de que una de las listas sea más corta que la otra, los elementos que "sobren" de la lista más larga se descartan.
> zip [1, 2, 3, 4] ["hola", "como", "te"]
[(1, "hola"), (2, "como"), (3, "te")]
> zip [1, 2, 3] ["hola", "como", "te", "va?"]
[(1, "hola"), (2, "como"), (3, "te")]
Una definición posible de `zip` sería:
zip :: [a] -> [b] -> [(a, b)]
zip []       _        = []
zip _        []       = []
zip (x : xs) (y : ys) = (x, y) : zip xs ys
`zipWith`, muy similarmente, toma dos listas, pero también toma una función con la que aparear a las listas:
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]     (atención al tipo de la función y de las listas)
> zipWith (*) [1, 2, 3] [4, 5, 6]
[1 * 4, 2 * 5, 3 * 6]
[4, 10, 18]
Se comporta igual que zip en cuanto a que pasa cuando una lista es más larga que la otra.
> zipWith ($) [even, (> 3), odd, (== 4)] [1..]
[even $ 1, (> 3) $ 2, odd $ 3, (== 4) $ 4]
[False, False, True, True]
Una definición posible de `zipWith` sería:
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ []       _        = []
zipWith _ _        []       = []
zipWith f (x : xs) (y : ys) = f x s : zipWith f xs ys
-}