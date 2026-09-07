extends Area2D

# Nombre de la tarjeta
@export var nombre_tarjeta = "Zona1"

# Identificador único de la tarjeta para el sistema de guardado
@export var id_unico: String = ""

# Número que entrega la tarjeta al jugador
@export var numero = 7

# Indica si el jugador se encuentra cerca de la tarjeta
var jugador_cerca = false


func _ready() -> void:
	# Comprueba si la tarjeta ya fue recogida anteriormente.
	# Si su ID está registrado en los datos guardados, la elimina del mapa.
	if id_unico != "" and id_unico in Guardado.objetos_recolectados:
		queue_free()
		
		# Comprueba nuevamente después de que termine de cargar el nodo.
		call_deferred("_comprobar_si_ya_fue_recogido")


# Comprueba si la tarjeta ya había sido recogida en una partida anterior.
func _comprobar_si_ya_fue_recogido() -> void:
	if id_unico in Guardado.objetos_recolectados:
		# Si ya fue recogida, elimina la tarjeta del mapa.
		queue_free()


# Se ejecuta cuando un cuerpo entra en el área de la tarjeta.
func _on_body_entered(body):
	# Comprueba si el cuerpo que entró pertenece al grupo "player".
	if body.is_in_group("player"):
		# Indica que el jugador está cerca de la tarjeta.
		jugador_cerca = true


# Se ejecuta cuando un cuerpo sale del área de la tarjeta.
func _on_body_exited(body):
	# Comprueba si el cuerpo que salió pertenece al grupo "player".
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
		
	# Solo cuando se recoge la tarjeta de la Zona1,
	# Silvestre muestra un diálogo relacionado con el significado del número.
	if nombre_tarjeta == "Zona1":
		DialogoSilvestre.mostrar_secuencia([
			"Estos números deben tener algún significado, memorízalos por si los necesitamos más adelante."
		])
		
	# Muestra en la consola el nombre de la tarjeta obtenida.
	print("Tarjeta obtenida:", nombre_tarjeta)

	# Muestra en la consola el número obtenido.
	print("Numero obtenido:", numero)
		
	# Elimina la tarjeta del mapa después de recogerla.
	queue_free()
