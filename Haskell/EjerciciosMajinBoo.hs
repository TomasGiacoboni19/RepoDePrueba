data Granuja = Granuja {
    nombre :: String,
    fuerza  :: Int
} deriving(Show)

majinBoo = Granuja "Majin Boo" 100
granuja1 = Granuja "El Caballero Rojo" 70
granuja2 = Granuja "Momia" 10

fuerzaAumentada boo granuja = boo {fuerza = fuerza boo + (((length.nombre) granuja) *6)}

fusionarNombre boo granuja = boo {nombre = nombre boo ++ nombre granuja} 

modificarMonstruo boo granuja = flip fuerzaAumentada granuja . fusionarNombre granuja 

mataAEsosGranujas boo listaGranuja= foldl modificarMonstruo boo listaGranuja 

--Por recursividad
--mataAEsosGranujas unMonstruo [] = unMonstruo
--mataAEsosGranujas unMonstruo (unGranuja:otrosGranujas) = mataAEsosGranujas (modificarMonstruo unMonstruo unGranuja) otrosGranujas



----------------- más ejercicios ----------------------


esMultiplodeAlguno numero listaNumero = any((==0).(numero `mod`)) listaNumero

esMultiplode numero otroNumero = numero % otroNumero == 0

esMultiplodeAlguno1 numero lista = any (esMultiplode numero) lista

---1a---


find condicion = (head . filter condicion)
