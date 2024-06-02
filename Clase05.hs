import Text.Show.Functions
{-
Supercelda, una importante empresa de desarrollo de videojuegos, nos pidió crear el que cree va a ser su próximo éxito: Braulio Estrella. Un juego multijugador donde varios personajes compiten en grupo o en solitario, en diferentes modos de juego para obtener la mayor cantidad de trofeos. Igualmente, quieren empezar con una demo sencilla: existirá un solo modo de juego de supervivencia en dúo, donde cada equipo de personajes deberá luchar contra otros, pudiendo emplear sus poderes para vencer y quedar en primer lugar. ¡Empecemos!

Por el momento sólo tendremos a los personajes Espina 🌵 y Pamela 👩‍⚕️, y de éstos nos interesa saber:
su nombre;
su poder básico;
su súper poder;
si tiene el súper poder activo y
su cantidad de vida.

Los poderes son los siguientes:


-}

data Personaje = Personaje{
    nombre :: String,
    poderBasico :: PoderBasico,
    superPoder :: SuperPoder,
    poderActivo :: Bool,
    cantidadDeVida :: Int
}   deriving Show

type PoderBasico = Personaje -> Personaje
type SuperPoder = String
-- Punto 1 --
-- Modelar los poderes.

--bolaEspinosa: le quita 1000 puntos de vida a quien sea su contrincante (¡no debe quedar un número negativo!).

bolaEspinosa :: PoderBasico
bolaEspinosa personaje = modificarVida (max 0 . subtract 1000) personaje

modificarVida :: (Int -> Int) -> Personaje -> Personaje
modificarVida unaFuncion personaje = personaje {cantidadDeVida = unaFuncion . cantidadDeVida $ personaje}


-- lluviaDeTuercas: pueden ser sanadoras o dañinas. Las primeras le suman 800 puntos de vida a su colega y las segundas le disminuyen a la mitad la vida de quien sea su contrincante. En cualquier otro caso, no le pasa nada al personaje.

lluviaDeTuercas :: 

-- granadaDeEspinas: el daño va a depender del radio de explosión de la misma. Si es mayor a 3, le agregara a su nombre “Espina estuvo aquí”. Si además su contrincante tiene menos de 800 vida, desactiva su súper y lo deja con 0 de vida. En otro caso, se usa una bola de espinas.
-- torretaCurativa: le activa el súper a su aliado y lo deja con el doble de su salud inicial.

--Además se quiere reportar lo siguiente:

-- atacar con el poder especial: si el personaje tiene el súper poder activo, entonces va a atacar a su contrincante con el súper y con el básico. Si no, no hará nada.
-- saber quiénes están en las últimas: es decir, el nombre de aquellos brawlers que tienen menos de 800 puntos de vida. 

-- Punto 3 --
-- Modelar a Espina con 4800 puntos de vida, cuyo básico es la bola de espinas y su súper la granada de espinas de 5 metros de radio. ¡Siempre tiene el súper activo!

espina :: Personaje
espina = Personaje "Espina" bolaEspinosa "Super Granada de Espinas" True 4800

-- Punto 4 --

-- Modelar a Pamela con 9600 puntos de vida, cuyo básico es la lluvia de tuercas sanadoras y el súper la torreta curativa (full soporte). No tiene el súper activo

--pamela :: Personaje
--pamela personaje = Personaje "Pamela" lluviaDeTuercas
