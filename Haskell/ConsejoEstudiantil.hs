import Text.Show.Functions()
{-
Se acerca la votación al consejo estudiantil y como queremos tener una idea aproximada de los resultados, vamos a programar una solución en Haskell.

Un candidato tiene nombre, edad, carisma y capacidades. Las capacidades sirven para convencer a la gente (mejor explicado más adelante).
-}

type Capacidad = Candidato -> Float

data Candidato = Candidato{
    nombre :: String,
    edad :: Float,
    carisma :: Float,
    capacidades :: [Capacidad]
} deriving Show

--- Punto 1 ---
-- 1) Las capacidades del candidato para convencer son:

-- a) facha: (60 - edad del candidato)  + carisma del candidato * 3

facha :: Capacidad
facha candidato = (((60-).edad) candidato) + ((*3).carisma) candidato

--b) liderazgo: edad del candidato * 10
liderazgo :: Capacidad
liderazgo = (*10).edad

--c) riqueza: carisma del candidato + edad del candidato / 50
riqueza :: Capacidad
riqueza candidato = carisma candidato + (edad candidato / 50)

--d) corrupto: resta 100 (en este caso no ayuda a convencer)
corrupto :: Capacidad
corrupto candidato = -100

--e) tiktoker: 100
tiktoker :: Capacidad
tiktoker candidato = 100

--f) flogger: 0 ( ya pasó de moda (?) )
flogger :: Capacidad
flogger candidato = 0

{- 
2) Modelar a los siguientes candidatos:
*  Cintia, que tiene 40 años, su carisma es de 12 y las capacidades que tiene son liderazgo, riqueza y es tiktoker.
-}
cintia = Candidato "Cintia" 40 12 [liderazgo, riqueza, tiktoker]

-- Marcos, que tiene 45 años, su carisma es de 10 y las capacidades que tiene son facha, liderazgo, corrupto.
marcos = Candidato "Marcos" 45 10 [facha, liderazgo, corrupto]

{-
3) Se desea saber si una persona tiene capacidades inútiles, se cumple cuando la persona tiene al menos una capacidad con convencimiento menor o igual a 0.
ej: tieneCapacidadInutil marcos 
True
-}
tieneCapacidadInutil :: Candidato -> Bool
tieneCapacidadInutil candidato = any(esInutilPara candidato) (capacidades candidato)

esInutilPara :: Candidato -> Capacidad -> Bool
esInutilPara candidato capacidad = (capacidad candidato) <= 0

-- 4) Saber los candidatos que entre sus capacidades no tienen ninguna que reste puntos o que no hagan nada.
tieneCapacidadesEficientes :: [Candidato] -> [Candidato]
tieneCapacidadesEficientes candidatos = filter (not.tieneCapacidadInutil) candidatos

{-
5) Se desea poder evaluar las capacidades de un candidato y obtener el valor de la suma de su convencimiento. Se debe devolver un candidato evaluado: (nombre, sumaCapacidades). Si la suma es menor a 0 debe devolver 0.
Ej: evaluarCandidato cintia
(“cintia”, 512.8)	(400 + 12 + 0.8 + 100)
-}
evaluarCandidato :: Candidato -> (String, Float)
evaluarCandidato candidato = (nombre candidato, sumaCapacidades candidato)

sumaCapacidades :: Candidato -> Float
sumaCapacidades candidato = max 0 (sum (map ($ candidato) (capacidades candidato)))

{-
6) Definir la función “elMejor/3” que dado dos elementos y una operación define cuál es el mejor de los dos. Se considera que un elemento es mejor que otro, si la operación a ese elemento, éste tiene un mayor resultado que el segundo. Se espera como resultado el elemento. En caso de empate devuelve el primero.
-}

elMejor :: Ord a => (a -> a) -> a -> a -> a
elMejor criterio primerElemento segundoElemento 
    |criterio primerElemento >= segundoElemento = primerElemento
    |otherwise = segundoElemento

{-
7) Definir la función “votacion/2” que dada una cantidad de votantes y una lista de candidatos devuelve una nueva lista con el nombre del candidato y la cantidad de votos que consiguió.

La cantidad de votos se define por: cantidadVotantes * convencimientoCandidato / totalConvencimientoDeTodosLosCandidatos
-}


