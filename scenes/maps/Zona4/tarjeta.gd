extends Area2D

# Nombre que tendrá la tarjeta de escape dentro del inventario.
@export var nombre_tarjeta: String = "tarjeta_escape"

# Identificador único de la tarjeta para el sistema de guardado.
@export var id_unico: String = ""

# Indica si el jugador se encuentra cerca de la tarjeta.
var jugador_cerca: bool = false


func _ready() -> void:
	# Comprueba si la tarjeta ya fue recogida anteriormente.
	# Si su ID está registrado en los objetos recolectados,
	# elimina la tarjeta de la escena.
	if id_unico in Guardado.objetos_recolectados:
		queue_free()
		return

	# La tarjeta comienza oculta al iniciar la escena.
	visible = false

	# Desactiva la detección del área mientras la tarjeta está oculta.
	monitoring = false

	# Comprueba si la señal body_entered todavía no está conectada.
	if not body_entered.is_connected(_on_body_entered):

		# Conecta la señal para detectar cuando un cuerpo entra en el área.
		body_entered.connect(_on_body_entered)

		# Conecta la señal para detectar cuando un cuerpo sale del área.
		body_exited.connect(_on_body_exited)


# Función que activa y muestra la tarjeta de escape.
func activar() -> void:

	# Comprueba nuevamente si la tarjeta ya fue recogida.
	# Esto evita que pueda aparecer nuevamente por algún error.
	if id_unico in Guardado.objetos_recolectados:
		return

	# Hace visible la tarjeta en el mapa.
	visible = true

	# Activa la detección de cuerpos del área.
	monitoring = true

	# Espera hasta el siguiente ciclo de física
	# para asegurarse de que el área ya esté activa.
	await get_tree().physics_frame

	# Revisa todos los cuerpos que actualmente están dentro del área.
	for body in get_overlapping_bodies():

		# Comprueba si alguno de los cuerpos pertenece al grupo "player".
		if body.is_in_group("player"):

			# Indica que el jugador está cerca de la tarjeta.
			jugador_cerca = true


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
func _process(_delta: float):

	# Comprueba si el jugador está cerca y presionó el botón de interactuar.
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):

		# Llama a la función encargada de recoger la tarjeta.
		_recolectar_tarjeta()


# Función encargada de recoger la tarjeta.
func _recolectar_tarjeta() -> void:

	# 1. Registra el ID de la tarjeta en la lista de objetos recolectados.
	# Esto permite que el juego recuerde que ya fue recogida.
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)

	# 2. Agrega el nombre de la tarjeta al inventario del jugador.
	Inventario.agregar_tarjeta(nombre_tarjeta)

	# Muestra en la consola un mensaje indicando que la tarjeta fue recogida,
	# junto con su nombre y su ID.
	print("Tarjeta recogida: ", nombre_tarjeta, " (ID: ", id_unico, ")")

	# Silvestre informa al jugador que finalmente no era necesario
	# encontrar esta última tarjeta.
	DialogoSilvestre.mostrar_secuencia([
		"Oh, parece que no había necesidad de encontrar esa última tarjeta, discúlpame jeje."
	])

	# Elimina la tarjeta de la escena después de recogerla.
	queue_free()
