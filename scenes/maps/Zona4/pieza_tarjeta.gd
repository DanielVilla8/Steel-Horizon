extends Area2D

# Identificador único de la pieza para el sistema de guardado.
@export var id_unico: String = ""

# Indica si el jugador se encuentra cerca de la pieza.
var jugador_cerca: bool = false


func _ready() -> void:

	# Comprueba si la pieza ya fue recogida anteriormente.
	# Si su ID está registrado en los objetos recolectados,
	# elimina la pieza de la escena.
	if id_unico in Guardado.objetos_recolectados:
		queue_free()
		return

	# La pieza comienza oculta al iniciar la escena.
	visible = false

	# Desactiva la detección del área mientras la pieza está oculta.
	monitoring = false

	# Conecta la señal para detectar cuando un cuerpo entra en el área.
	body_entered.connect(_on_body_entered)

	# Conecta la señal para detectar cuando un cuerpo sale del área.
	body_exited.connect(_on_body_exited)


# Se ejecuta cuando un cuerpo entra en el área de la pieza.
func _on_body_entered(body: Node2D) -> void:

	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador está cerca de la pieza.
		jugador_cerca = true


# Se ejecuta cuando un cuerpo sale del área de la pieza.
func _on_body_exited(body: Node2D) -> void:

	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador ya no está cerca de la pieza.
		jugador_cerca = false


# Se ejecuta constantemente mientras el juego está funcionando.
func _process(_delta: float) -> void:

	# Comprueba si el jugador está cerca y presionó el botón de interactuar.
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):

		# Llama a la función encargada de recoger la pieza.
		_recolectar_pieza()


# Función encargada de recoger la pieza.
func _recolectar_pieza() -> void:

	# 1. Registra el ID de la pieza en la lista de objetos recolectados.
	# Esto permite que el juego recuerde que ya fue recogida.
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)

	# 2. Agrega una pieza de tarjeta al inventario del jugador.
	Inventario.agregar_pieza_tarjeta()

	# Muestra en la consola un mensaje indicando que la pieza fue recogida,
	# junto con su ID.
	print("Pieza de tarjeta recogida (ID: ", id_unico, ")")

	# 3. Elimina la pieza de la escena después de recogerla.
	queue_free()


# Función encargada de revelar la pieza.
func revelar() -> void:

	# Comprueba si la pieza ya fue recogida anteriormente.
	# Si ya está registrada en el guardado, evita que vuelva a aparecer.
	if id_unico in Guardado.objetos_recolectados:
		return

	# Hace visible la pieza en el mapa.
	visible = true

	# Activa nuevamente la detección del área.
	monitoring = true
