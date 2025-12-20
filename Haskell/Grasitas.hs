--https://docs.google.com/document/u/1/d/e/2PACX-1vQNqVQl8zhWL3kiviJYzw87_SQfjmWvrvuOhH1wSDJj4TAm3fkifzgiwrrdSRsIcqodQB0pZJRTh1__/pub

{-
De cada gimnasta nos interesa saber su peso y su coeficiente de tonificación.


Los profesionales del gimnasio preparan rutinas de ejercicios pensadas para las necesidades de cada gimnasta. Una rutina es una lista de ejercicios que el gimnasta realiza durante unos minutos para quemar calorías y tonificar sus músculos.


Se pide:

Modelar a los Gimnastas y las operaciones necesarias para hacerlos ganar tonificación y quemar calorías considerando que por cada 500 calorías quemadas se baja 1 kg de peso.-}

data Gimnasta = Gimnasta{
    peso :: Int,
    coeficienteTonificacion :: Int
} deriving (Show, Eq)

type Peso = Int
type CoeficienteTonificacion = Int
type Tiempo = Int


data Rutina = Rutina{
    nombre :: String,
    duracionTotal :: Tiempo,
    ejercicios :: [Ejercicio]
} 

type Ejercicio = Tiempo -> Gimnasta -> Gimnasta

ganarTonificacion ::  CoeficienteTonificacion -> Gimnasta -> Gimnasta
ganarTonificacion cantidadTonificacion gimnasta =
    modificarTonificacion (+ cantidadTonificacion) gimnasta

modificarTonificacion :: (Int -> Int) -> Gimnasta -> Gimnasta
modificarTonificacion funcion gimnasta =
    gimnasta { coeficienteTonificacion = funcion . coeficienteTonificacion $ gimnasta }

quemarCalorias :: Int -> Gimnasta -> Gimnasta
quemarCalorias calorias gimnasta =
    modificarPeso (subtract (calorias `div` 500)) gimnasta

modificarPeso :: (Int -> Int) -> Gimnasta -> Gimnasta
modificarPeso funcion gimnasta =
    gimnasta { peso = funcion . peso $ gimnasta }

{- Punto 2
Modelar los siguientes ejercicios del gimnasio:

a) La cinta es una de las máquinas más populares entre los socios que quieren perder peso. Los gimnastas simplemente corren sobre la cinta y queman calorías en función de la velocidad promedio alcanzada (quemando 10 calorías por la velocidad promedio por minuto).
La cinta puede utilizarse para realizar dos ejercicios diferentes:
La caminata es un ejercicio en cinta con velocidad constante de 5 km/h. 
El pique arranca en 20 km/h y cada minuto incrementa la velocidad en 1 km/h, con lo cual la velocidad promedio depende de los minutos de entrenamiento.
-}
cinta :: Int -> Ejercicio
cinta velocidadPromedio duracion gimnasta =
    quemarCalorias (velocidadPromedio * 10 * duracion) gimnasta

caminata :: Ejercicio  
caminata duracion gimnasta = cinta 5 duracion gimnasta

pique :: Ejercicio
pique duracion gimnasta = cinta (duracion `div` 2 + 20) duracion $ gimnasta

{-
b) Las pesas son el equipo preferido de los que no quieren perder peso, sino ganar musculatura. Una sesión de levantamiento de pesas de más de 10 minutos hace que el gimnasta gane una tonificación equivalente a los kilos levantados. Por otro lado, una sesión de menos de 10 minutos es demasiado corta, y no causa ningún efecto en el gimnasta.
-}
pesas :: Int -> Ejercicio
pesas kilosLevantados duracion gimnasta
    | duracion > 10 = ganarTonificacion kilosLevantados gimnasta
    | otherwise     = gimnasta

{-
c) La colina es un ejercicio que consiste en ascender y descender sobre una superficie inclinada y quema 2 calorías por minuto multiplicado por la inclinación con la que se haya montado la superficie

Los gimnastas más experimentados suelen preferir otra versión de este ejercicio: la montaña, que consiste en 2 colinas sucesivas (asignando a cada una la mitad del tiempo total), donde la segunda colina se configura con una inclinación de 5 grados más que la inclinación de la primera. Además de la pérdida de peso por las calorías quemadas en las colinas, la montaña incrementa en 3 unidades la tonificación del gimnasta.
-}
colina :: Grados -> Ejercicio
colina inclinacion duracion gimnasta = quemarCalorias (2 * inclinacion * duracion) gimnasta

type Grados = Int

montana :: Grados -> Ejercicio
montana inclinacion duracion gimnasta =
    ganarTonificacion 3. colina (inclinacion + 5) (duracion `div` 2) . colina (inclinacion) (duracion `div` 2) $ gimnasta

{-
Dado un gimnasta y una Rutina de Ejercicios, representada con la siguiente estructura:
data Rutina = Rutina {
 nombre :: String,

  duracionTotal :: Int,
 ejercicios :: [Ejercicio]
}


Implementar una función realizarRutina, que dada una rutina y un gimnasta retorna el gimnasta resultante de realizar todos los ejercicios de la rutina, repartiendo el tiempo total de la rutina en partes iguales. Mostrar un ejemplo de uso con una rutina que incluya todos los ejercicios del punto anterior.
-}  
realizarRutina ::  Gimnasta -> Rutina ->Gimnasta
realizarRutina gimnasta rutina = foldl (\gimnasta ejercicio -> ejercicio (tiempoParaEjercicio rutina)gimnasta) gimnasta (ejercicios rutina)

tiempoParaEjercicio :: Rutina -> Tiempo
tiempoParaEjercicio rutina =  (div (duracionTotal rutina) . length . ejercicios) rutina

{-
Definir las operaciones necesarias para hacer las siguientes consultas a partir de una lista de rutinas:
¿Qué cantidad de ejercicios tiene la rutina con más ejercicios?
¿Cuáles son los nombres de las rutinas que hacen que un gimnasta dado gane tonificación?
¿Hay alguna rutina peligrosa para cierto gimnasta? Decimos que una rutina es peligrosa para alguien si lo hace perder más de la mitad de su peso.
-}
cantidadMaximaDeEjercicios :: [Rutina] -> Int
cantidadMaximaDeEjercicios rutinas = maximum . map (length .ejercicios) $ rutinas

nombresDeRutinasQueHacenGanarTonificacion :: Gimnasta -> [Rutina] -> [String]
nombresDeRutinasQueHacenGanarTonificacion gimnasta rutinas = map nombre . filter((> coeficienteTonificacion gimnasta). coeficienteTonificacion . realizarRutina gimnasta) $ rutinas

hayPeligrosa :: Gimnasta -> [Rutina] -> Bool
hayPeligrosa gimnasta rutinas = any ((< peso gimnasta `div` 2) . peso. realizarRutina gimnasta) $ rutinas