import Text.Show.Functions

{-
¿Tenés un perrito y te toca ir a la oficina durante el día? ¿Te vas de vacaciones y no tenés con quien dejarlo? ¡No te preocupes! "P de Perritos”, la guardería perruna, abrió sus puertas para que puedas dejar a tu fiel compañero en sus buenas manos. ¡Ayudala a dar un excelente servicio con tus conocimientos del paradigma funcional!

Parte A

Hablemos de los protagonistas: los perritos 🐶. De cada uno conocemos: su raza, sus juguetes favoritos, el tiempo que va a permanecer en la guardería, y la energía que tiene.

-}

data Perrito = Perrito{
    raza :: String,
    juguetesFav :: [Juguete],
    tiempoEnGuarderia :: Int,
    energia :: Int
} deriving Show

type Juguete = String

-- De las guarderías sabemos que tienen un nombre y una rutina para entretener a los pichichos. La rutina es un conjunto de actividades, compuestas por el ejercicio y el tiempo que éste dura en minutos. Algunos de estos ejercicios son:
data Guarderia = Guarderia{
    nombreGuarderia :: String,
    rutina :: [Actividad]
} deriving Show


data Actividad = Actividad{
    ejercicio :: Ejercicio,
    duracion :: Int
} deriving Show

type Ejercicio = Perrito -> Perrito

-- > jugar: disminuye en 10 unidades la energía del perrito 🪫. ¡No puede quedar un valor negativo!
jugar :: Ejercicio
jugar perrito = modificarEnergia(subtract 10) $ perrito

modificarEnergia :: (Int -> Int) -> Perrito -> Perrito
modificarEnergia funcion perrito = perrito {energia = max 0 . funcion . energia $ perrito}

-- > ladrar: aumenta la energía la mitad de los ladridos que se establezcan. 🗣️
ladrar :: Int -> Ejercicio
ladrar ladridos perrito = modificarEnergia(+ ladridos `div` 2) $ perrito

-- > regalar: ¡cómo no le vamos a dar un juguetito! Añade el juguete que se especifique a los favoritos. 🎁
regalar :: String -> Ejercicio
regalar juguete perrito = agregarJuguete juguete $ perrito

agregarJuguete :: String -> Perrito -> Perrito    
agregarJuguete juguete perrito = modificarJuguete(juguete :) $ perrito

modificarJuguete :: ([Juguete] -> [Juguete]) -> Perrito -> Perrito
modificarJuguete funcion perrito = perrito {juguetesFav = funcion . juguetesFav $ perrito}

-- > diaDeSpa: si el perro va a permanecer 50 minutos como mínimo en la guardería o es de raza extravagante, su energía pasa a ser 100 🔋 y se le regala el juguete "peine de goma” 🪮. Si no, no pasa nada. Las razas extravagantes son dálmata y pomerania.
diaDeSpa :: Ejercicio
diaDeSpa perrito
    | hacerDiaSpa perrito = modificarEnergia (const 100) . regalar "Peine de goma" $ perrito
    | otherwise = perrito

hacerDiaSpa :: Perrito -> Bool
hacerDiaSpa perrito = permaneceAlMenos 50 perrito || esExtravagante perrito


esExtravagante :: Perrito -> Bool
esExtravagante perrito = esRazaExtravagante . raza $ perrito

esRazaExtravagante :: String -> Bool
esRazaExtravagante "Dalmata" = True
esRazaExtravagante "Pomerania" = True
esRazaExtravagante _ = False

{- OTRA VARIANTE DE CHEQUEAR SI EL PERRITO ES EXTRAVAGANTE
esRazaExtravagante' :: Perrito -> Bool
esRazaExtravagante' perrito = elem (raza perrito) ["Dalmata", "Pomerania"]-}

permaneceAlMenos :: Int -> Perrito -> Bool
permaneceAlMenos minutos perrito = (>=minutos) . tiempoEnGuarderia $ perrito

-- > diaDeCampo: ¡nada más lindo que ver perritos jugar! Lástima que así siempre pierden el primer juguete.😅
diaDeCampo :: Ejercicio
diaDeCampo perrito = perderJuguete . jugar $ perrito

perderJuguete :: Perrito -> Perrito
perderJuguete perrito = modificarJuguete (drop 1) $ perrito

{-
Modelar:
Los ejercicios antes mencionados.
A Zara, una perra dálmata que tiene como juguetes favoritos una pelota y una mantita, permanece 1 hora y media en la guardería y su energía es de 80. 
-}
zara :: Perrito
zara = Perrito "Dalmata" ["Pelota", "Mantita"] 90 80 

-- ALGUNOS EJEMPLOS MÁS
kiara :: Perrito
kiara = Perrito "Setter Irlandes" ["Pelota", "Gatito"] 40 60 

rita :: Perrito
rita = Perrito "Setter Irlandes" ["Gatito", "Silla"] 50 20 

puky :: Perrito
puky = Perrito "Pomerania" ["Hueso", "Cuerda"] 900 80 

lola :: Perrito
lola = Perrito "Schnauzer" ["Pelota", "Cucha"] 200 80 
{-
La GuarderíaPdePerritos que tiene como rutina las siguientes actividades:

Ejercicio          Tiempo (min)
Jugar               30
Ladrar 18           20
Regalar pelota      0
Día de spa          120
Día de campo        720
-}
pDePerritos :: Guarderia
pDePerritos = Guarderia 
    {nombreGuarderia = "PdePerritos", 
    rutina = 
        [
        Actividad jugar 30, 
        Actividad (ladrar 18) 20, 
        Actividad (regalar "Pelota") 0,
        Actividad diaDeSpa 120,
        Actividad diaDeCampo 720
        ]}

{-


Parte B

Y entonces… ¿cuándo abreeeeeee? ✋Primero debemos asegurarnos de:
Saber si un perro puede estar en una guardería. Para eso, el tiempo de permanencia tiene que ser mayor que el de la rutina. 🕰️

-}
puedeEstarEnGuarderia :: Perrito -> Guarderia -> Bool
puedeEstarEnGuarderia perrito =  flip permaneceAlMenos perrito . duracionRutina  . rutina 

duracionRutina :: [Actividad] -> Int
duracionRutina actividades = sum . map duracion $ actividades

-- Reconocer a perros responsables. Estos serían los que aún después de pasar un día de campo siguen teniendo más de 3 juguetes. 🧸
esPerritoResponsable :: Perrito -> Bool
esPerritoResponsable perrito = tieneMasDeNJuguetes 3 . diaDeCampo $ perrito

tieneMasDeNJuguetes :: Int -> Perrito -> Bool
tieneMasDeNJuguetes cantidad = (> cantidad) . length . juguetesFav  

-- Que un perro realice una rutina de la guardería (que realice todos sus ejercicios). Para eso, el tiempo de la rutina no puede ser mayor al tiempo de permanencia. En caso de que esta condición no se cumpla, el perro no hace nada. 🐕
realizarRutinaGuarderia :: Guarderia -> Perrito -> Perrito
realizarRutinaGuarderia guarderia perrito
    | puedeEstarEnGuarderia perrito guarderia = (aplicarRutina . rutina $ guarderia) $ perrito
    | otherwise = perrito

aplicarRutina :: [Actividad] -> Perrito -> Perrito
aplicarRutina rutina perrito = foldl (flip ejercicio) perrito rutina

-- Dados unos perros, reportar todos los que quedan cansados después de realizar la rutina de una guardería. Es decir, que su energía sea menor a 5 luego de realizar todos los ejercicios. 💤
perritosCansados :: Guarderia -> [Perrito] -> [Perrito]
perritosCansados guarderia = filter (estaCansado . realizarRutinaGuarderia guarderia)

estaCansado :: Perrito -> Bool
estaCansado perrito = (>5) . energia $ perrito
{-
Parte C

¡Infinita diversión! ♾️ Pi es un perrito un poco especial… Su raza es labrador y tiene muchos, muchos, incontables juguetes favoritos. Con la particularidad de que son todas soguitas numeradas del 1 al infinito. Su tiempo de permanencia es de 314 minutos y su energía es de 159.
Luego de modelar a Pi, respondé las siguientes preguntas justificando y escribiendo la consulta que harías en la consola:
¿Sería posible saber si Pi es de una raza extravagante?
¿Qué pasa si queremos saber si Pi tiene…
… algún huesito como juguete favorito? 
… alguna pelota luego de pasar por la Guardería de Perritos?
… la soguita 31112?
¿Es posible que Pi realice una rutina?
¿Qué pasa si le regalamos un hueso a Pi?

Aclaraciones
 Todas las funciones deberán estar tipadas.
 NO repetir lógica.
 Usar composición siempre que sea posible.
-}

perroPi = Perrito "Labrador" sogasInfinitas 314 159 

sogasInfinitas :: [String]
sogasInfinitas = map (\n -> "Soguita " ++ show n) [1 ..]