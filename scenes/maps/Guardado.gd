extends Node
# Define este script como un nodo general.
# Se utiliza para controlar el sistema de guardado de la partida.

const RUTA_GUARDADO = "user://partida.save"
# Define la ubicación donde se almacenará el archivo de guardado.
# "user://" es una carpeta propia de Godot para guardar datos del usuario.

var hay_partida = false
# Indica si existe una partida guardada que se pueda cargar.

var objetos_recolectados: Array = []
# Guarda una lista de los objetos que el jugador ya ha recolectado.

var estados_puertas: Dictionary = {}
# Guarda el estado de las puertas, por ejemplo, si están abiertas o cerradas.


func guardar_partida(zona_actual, posicion_jugador, direccion_jugador):
	# Función encargada de guardar toda la información importante de la partida.

	var datos = {
		"zona": zona_actual,
		# Guarda la zona o nivel donde se encuentra el jugador.

		"posicion_x": posicion_jugador.x,
		# Guarda la posición horizontal del jugador.

		"posicion_y": posicion_jugador.y,
		# Guarda la posición vertical del jugador.

		"direccion": direccion_jugador,
		# Guarda la última dirección en la que estaba mirando el jugador.

		"letras": Inventario.letras,
		# Guarda las letras que el jugador ha conseguido.

		"tarjetas": Inventario.tarjetas,
		# Guarda las tarjetas que tiene el jugador.

		"llaves": Inventario.llaves,
		# Guarda las llaves obtenidas.

		"numeros": Inventario.numeros,
		# Guarda los números obtenidos durante los diferentes niveles.

		"objetos_recolectados": objetos_recolectados,
		# Guarda los objetos que ya fueron recogidos.

		"estados_puertas": estados_puertas
		# Guarda el estado de las puertas del juego.
	}

	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)
	# Abre o crea el archivo de guardado en modo escritura.

	archivo.store_var(datos)
	# Guarda toda la información almacenada en la variable "datos".

	archivo.close()
	# Cierra el archivo después de guardar la información.

	print("Partida guardada correctamente")
	# Muestra un mensaje en la consola indicando que el guardado terminó.


func cargar_partida():
	# Función encargada de cargar una partida guardada anteriormente.

	if not FileAccess.file_exists(RUTA_GUARDADO):
		# Comprueba si existe el archivo de guardado.

		print("No existe una partida guardada")
		# Informa en la consola que no existe una partida.

		hay_partida = false
		# Indica que no hay una partida disponible.

		return {}
		# Termina la función y devuelve un diccionario vacío.


	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.READ)
	# Abre el archivo existente en modo lectura.

	var datos = archivo.get_var()
	# Obtiene la información almacenada en el archivo.

	archivo.close()
	# Cierra el archivo después de leerlo.


	Inventario.letras = datos.get("letras", [])
	# Recupera las letras que tenía el jugador.

	Inventario.tarjetas = datos.get("tarjetas", [])
	# Recupera las tarjetas del inventario.

	Inventario.numeros = datos.get("numeros", [])
	# Recupera los números obtenidos.

	Inventario.llaves = datos.get("llaves", [])
	# Recupera las llaves obtenidas.


	objetos_recolectados = datos.get("objetos_recolectados", [])
	# Recupera los objetos que ya habían sido recolectados.

	estados_puertas = datos.get("estado_puertas", {})
	# Recupera los estados de las puertas.


	hay_partida = true
	# Indica que existe una partida guardada y cargada correctamente.

	print("Partida cargada correctamente")
	# Muestra un mensaje en la consola indicando que la carga terminó.

	return datos
	# Devuelve todos los datos de la partida cargada.
