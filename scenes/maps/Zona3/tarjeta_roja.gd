extends Area2D

# Nombre de la tarjeta que se obtiene.
var nombre_tarjeta = "Zona3"

# Número que entrega la tarjeta al jugador.
var numero = 5

# Identificador único de la tarjeta para el sistema de guardado.
@export var id_unico: String = ""

# Indica si el jugador se encuentra cerca de la tarjeta.
var jugador_cerca = false


func _ready() -> void:
	# Comprueba si la tarjeta ya fue recogida anteriormente.
	# Si su ID está registrado en los datos guardados,
	# la tarjeta desaparece automáticamente del mapa.
	if id_unico != "" and id_unico in Guardado.objetos_recolectados:
		queue_free()
		
		# Realiza una segunda comprobación después de que termine
		# de cargar el nodo.
		call_deferred("_comprobar_si_ya_fue_recogido")


# Comprueba si la tarjeta ya fue recogida en una partida anterior.
func _comprobar_si_ya_fue_recogido() -> void:
	# Si el ID de la tarjeta está registrado como recogido,
	# elimina la tarjeta del mapa.
	if id_unico in Guardado.objetos_recolectados:
		queue_free()


# Se ejecuta cuando un cuerpo entra en el área de la tarjeta.
func _on_body_entered(body):
	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):
		# Indica que el jugador está cerca de la tarjeta.
		jugador_cerca = true


# Se ejecuta cuando un cuerpo sale del área de la tarjeta.
func _on_body_exited(body):
	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):
		# Indica que el jugador ya no está cerca de la tarjeta.
		jugador_cerca = false


# Se ejecuta constantemente mientras el juego está funcionando.
func _process(delta):
	# Comprueba si el jugador está cerca y presionó el botón de interactuar.
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		# Llama a la función encargada de recoger la tarjeta.
		_recolectar_tarjeta()


# Función encargada de recoger la tarjeta.
func _recolectar_tarjeta() -> void:
	# 1. Marca la tarjeta como recogida en los datos guardados del mundo.
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)

	# 2. Guarda el nombre de la tarjeta en el inventario.
	Inventario.agregar_tarjeta(nombre_tarjeta)

	# Guarda el número de la tarjeta en el inventario.
	Inventario.agregar_numero(numero)
	
	# 3. Muestra el número obtenido en pantalla durante 5 segundos.
	UIMensajes.mostrar_numero(numero)
	
	# Solo cuando se recoge la tarjeta de Zona3,
	# Silvestre muestra un diálogo relacionado con el significado del número.
	if nombre_tarjeta == "Zona3":
		DialogoSilvestre.mostrar_secuencia([
			"Estos números deben tener algún significado, memorízalos por si los necesitamos más adelante."
		])
		
	# Muestra en la consola el ID del inventario y
	# el contenido actual de las tarjetas guardadas.
	print("ID Inventario al guardar:", Inventario.get_instance_id(), " contenido:", Inventario.tarjetas)

	# Muestra en la consola el nombre de la tarjeta obtenida.
	print("Tarjeta obtenida:", nombre_tarjeta)

	# Muestra en la consola el número obtenido.
	print("Numero obtenido:", numero)
		
	# Elimina la tarjeta del mapa después de recogerla.
	queue_free()
