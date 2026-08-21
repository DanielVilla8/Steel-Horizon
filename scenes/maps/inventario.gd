extends Node
#Pertenece a un Nodo

var letras = []
var tarjetas = []
var numeros = []
var llaves = []
#Aqui se guardaran las cosas obtenidas

func agregar_letra(letra):
#Se agrega letra al inventario
	letras.append(letra)
#Guarda la letra en la lista

	print("letra recogida:", letra)
#Muestra que letra que se recogio
	print("Inventario:", letras)
#Muestra el inventario con todas las letras recogidas

func agregar_tarjeta(nombre):
	tarjetas.append(nombre)
	
func agregar_numero(numero):
	numeros.append(numero)
	
func agregar_llave(llave):
	llaves.append(llave)
	print("Llave recogida:", llave)
