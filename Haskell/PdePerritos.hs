import Text.Show.Functions

{-
¿Tenés un perrito y te toca ir a la oficina durante el día? ¿Te vas de vacaciones y no tenés con quien dejarlo? ¡No te preocupes! "P de Perritos”, la guardería perruna, abrió sus puertas para que puedas dejar a tu fiel compañero en sus buenas manos. ¡Ayudala a dar un excelente servicio con tus conocimientos del paradigma funcional!

Parte A

Hablemos de los protagonistas: los perritos 🐶. De cada uno conocemos: su raza, sus juguetes favoritos, el tiempo que va a permanecer en la guardería, y la energía que tiene.

De las guarderías sabemos que tienen un nombre y una rutina para entretener a los pichichos. La rutina es un conjunto de actividades, compuestas por el ejercicio y el tiempo que éste dura en minutos. Algunos de estos ejercicios son:
> jugar: disminuye en 10 unidades la energía del perrito 🪫. ¡No puede quedar un valor negativo!
> ladrar: aumenta la energía la mitad de los ladridos que se establezcan. 🗣️
> regalar: ¡cómo no le vamos a dar un juguetito! Añade el juguete que se especifique a los favoritos. 🎁
> diaDeSpa: si el perro va a permanecer 50 minutos como mínimo en la guardería o es de raza extravagante, su energía pasa a ser 100 🔋 y se le regala el juguete "peine de goma” 🪮. Si no, no pasa nada. Las razas extravagantes son dálmata y pomerania.
> diaDeCampo: ¡nada más lindo que ver perritos jugar! Lástima que así siempre pierden el primer juguete.😅

Modelar:
Los ejercicios antes mencionados.
A Zara, una perra dálmata que tiene como juguetes favoritos una pelota y una mantita, permanece 1 hora y media en la guardería y su energía es de 80. 
La GuarderíaPdePerritos que tiene como rutina las siguientes actividades:

Ejercicio          Tiempo (min)
Jugar               30
Ladrar 18           20
Regalar pelota      0
Día de spa          120
Día de campo        720

Hablemos de los protagonistas: los perritos 🐶. De cada uno conocemos: su raza, sus juguetes favoritos, el tiempo que va a permanecer en la guardería, y la energía que tiene.
-}

data Perrito = Perrito{
    raza :: String,
    juguetesFav :: [Juguete],
    tiempoEnGuarderia :: Int,
    energia :: Int
} deriving Show

type Juguete = String

data Guarderia = Guarderia{
    nombreGuarderia :: String,
    rutina :: [Actividad]
} deriving Show


data Actividad = Actividad{
    ejercicio :: Ejercicio,
    duracion :: Int
} deriving Show

type Ejercicio = Perrito -> Perrito

jugar :: Ejercicio
jugar perrito = modificarEnergia(subtract 10) $ perrito

modificarEnergia :: (Int -> Int) -> Perrito -> Perrito
modificarEnergia funcion perrito = perrito {energia = max 0 . funcion . energia $ perrito}

zara :: Perrito
zara = Perrito "dalmata" ["Pelota", "Mantita"] 90 80 


{-
A Zara, una perra dálmata que tiene como juguetes favoritos una pelota y una mantita, permanece 1 hora y media en la guardería y su energía es de 80. 
La GuarderíaPdePerritos que tiene como rutina las siguientes actividades:
Parte B

Y entonces… ¿cuándo abreeeeeee? ✋Primero debemos asegurarnos de:
Saber si un perro puede estar en una guardería. Para eso, el tiempo de permanencia tiene que ser mayor que el de la rutina. 🕰️
Reconocer a perros responsables. Estos serían los que aún después de pasar un día de campo siguen teniendo más de 3 juguetes. 🧸
Que un perro realice una rutina de la guardería (que realice todos sus ejercicios). Para eso, el tiempo de la rutina no puede ser mayor al tiempo de permanencia. En caso de que esta condición no se cumpla, el perro no hace nada. 🐕
Dados unos perros, reportar todos los que quedan cansados después de realizar la rutina de una guardería. Es decir, que su energía sea menor a 5 luego de realizar todos los ejercicios. 💤
-}

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