extends Area2D

# Nombre que tendrá la llave dentro del inventario.
@export var nombre_llave: String = "llave_generica"

# Identificador único de la llave para el sistema de guardado.
@export var id_unico: String = ""

# Indica si el jugador se encuentra cerca de la llave.
var jugador_cerca: bool = false


func _ready() -> void:

	# Comprueba si la llave ya fue recogida anteriormente.
	# Si su ID está registrado en los objetos recolectados,
	# elimina la llave de la escena.
	if id_unico in Guardado.objetos_recolectados:
		queue_free()
		return

	# La llave comienza oculta al iniciar la escena.
	visible = false

	# Desactiva la detección del área mientras la llave está oculta.
	monitoring = false

	# Conecta la señal para detectar cuando un cuerpo entra en el área.
	body_entered.connect(_on_body_entered)

	# Conecta la señal para detectar cuando un cuerpo sale del área.
	body_exited.connect(_on_body_exited)


# Función encargada de revelar la llave en el mapa.
func revelar() -> void:

	# Comprueba si la llave ya fue recogida anteriormente.
	# Si ya está registrada en el guardado, evita que vuelva a aparecer.
	if id_unico in Guardado.objetos_recolectados:
		return

	# Hace visible la llave en el mapa.
	visible = true

	# Activa la detección del área para detectar al jugador.
	monitoring = true

	# Muestra en la consola que la llave fue revelada.
	print("llave revelada en el mapa")


# Se ejecuta cuando un cuerpo entra en el área de la llave.
func _on_body_entered(body: Node2D) -> void:

	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador está cerca de la llave.
		jugador_cerca = true


# Se ejecuta cuando un cuerpo sale del área de la llave.
func _on_body_exited(body: Node2D) -> void:

	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador ya no está cerca de la llave.
		jugador_cerca = false


# Se ejecuta constantemente mientras el juego está funcionando.
func _process(_delta: float) -> void:

	# Comprueba si el jugador está cerca y presionó el botón de interactuar.
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):

		# Llama a la función encargada de recoger la llave.
		_recolectar_llave()


# Función encargada de recoger la llave.
func _recolectar_llave():

	# 1. Registra el ID de la llave en la lista de objetos recolectados.
	# Esto permite que el juego recuerde que ya fue recogida.
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)

	# 2. Agrega la llave al inventario del jugador.
	Inventario.agregar_llave(nombre_llave)

	# Muestra en la consola el nombre de la llave y su ID.
	print("Llave recogida: ", nombre_llave, " (ID: ", id_unico, ")")

	# 3. Elimina la llave de la escena después de recogerla.
	queue_free()
