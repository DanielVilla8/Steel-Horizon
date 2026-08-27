extends Node

const RUTA_GUARDADO = "user://partida.save"
var hay_partida = false

func guardar_partida(zona_actual, posicion_jugador, direccion_jugador):
	var datos = {
		"zona": zona_actual,
		"posicion_x": posicion_jugador.x,
		"posicion_y": posicion_jugador.y,
		"direccion": direccion_jugador,
		"letras": Inventario.letras,
		"tarjetas": Inventario.tarjetas,
		"llaves": Inventario.llaves,
		"numeros": Inventario.numeros
	}

	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)
	archivo.store_var(datos)
	archivo.close()
	print("Partida guardada correctamente")

func cargar_partida():
	if not FileAccess.file_exists(RUTA_GUARDADO):
		print("No existe una partida guardada")
		hay_partida = false
		return {}
		
	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.READ)
	var datos = archivo.get_var()
	archivo.close()
	
	Inventario.letras = datos.get("letras", [])
	Inventario.tarjetas = datos.get("tarjetas", [])
	Inventario.numeros = datos.get("numeros", [])
	Inventario.llaves = datos.get("llaves", [])
	
	hay_partida = true
	
	print("Partida cargada correctamente")

	return datos
