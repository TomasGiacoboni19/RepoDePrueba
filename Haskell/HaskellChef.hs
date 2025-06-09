import Text.Show.Functions()

{-
Parte A

Nuestro programa tendrá participantes que cuentan con nombre, trucos de cocina y un plato que es su especialidad. Los platos, a su vez, tienen una dificultad que va de 0 a 10 y un conjunto de componentes que nos indican sus ingredientes con sus respectivos pesos en gramos.
-}

data Participante = Participante{
    nombre :: String,
    truco :: [Truco],
    especialidad :: Plato
} deriving Show

type Truco = Plato -> Plato

data Plato = Plato{
    dificultad :: Int,
    componentes :: [Componente]
} deriving Show

type Componente = (Ingrediente, Peso)
type Ingrediente = String
type Peso = Int

{-
Algunos de los trucos más famosos son:

endulzar: dada una cantidad de gramos de azúcar, le agrega ese componente a un plato.  
salar: la vieja y confiable… dada una cantidad de gramos de sal y un plato, nos retorna el mismo con esa cantidad de sal para que quede flama.
darSabor: dadas una cantidad de sal y una de azúcar sala y endulza un plato.
duplicarPorcion: se duplica la cantidad de cada componente de un plato… para más placer.
simplificar: hay platos que son realmente un bardo. Es por ello que si un plato tiene más de 5 componentes y una dificultad mayor a 7 lo vamos a simplificar, sino lo dejamos igual. Simplificar un plato es dejarlo con 5 de dificultad y quitarle aquellos componentes de los que hayamos agregado menos de 10 gramos.

-}

tiramisu :: Plato
tiramisu = Plato 8 [("quesoCrema", 250), ("chocolate", 50), ("vainilla", 400)]

papasFritas :: Plato
papasFritas = Plato 3 [("papas", 200)]

endulzar :: Peso -> Truco
endulzar gramos plato = agregarComponente "Azucar" gramos plato
--endulzar = agregarComponente "Azucar" 

agregarComponente :: Ingrediente -> Peso -> Plato -> Plato
agregarComponente ingrediente gramos = modificarComponentes (\componentes -> (ingrediente, gramos) : componentes)

modificarComponentes :: ([Componente] -> [Componente]) -> Plato -> Plato
modificarComponentes funcion plato = plato {componentes = funcion . componentes $ plato}

salar :: Peso -> Truco
salar gramos plato = agregarComponente "Sal" gramos plato
--salar = agregarComponente "Sal" 

darSabor :: Int -> Int -> Truco
darSabor gramosSal gramosAzucar plato = endulzar gramosAzucar . salar gramosSal $ plato

duplicarPorcion :: Truco
duplicarPorcion = modificarComponentes (map duplicarComponentes)

duplicarComponentes :: Componente -> Componente
duplicarComponentes (ingrediente, peso ) = (ingrediente, peso * 2) 

simplificar :: Truco
simplificar plato
--  | esUnBardo plato = modificarComponentes (filter hayMuchos) $ plato {dificultad = 5}
    | esUnBardo plato = plato {dificultad = 5, componentes = filter((>=10). snd) (componentes plato)}
    | otherwise = plato

--hayMuchos :: Componente -> Bool
--hayMuchos (_, gramos) = gramos >= 10

cantidadDeComponentes :: Plato -> Int
cantidadDeComponentes plato = length . componentes $ plato

esUnBardo :: Plato -> Bool
esUnBardo plato = ((>7). dificultad) plato && ((>5) . cantidadDeComponentes) plato