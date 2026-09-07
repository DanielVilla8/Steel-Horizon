extends StaticBody2D

# Identificador único de la puerta para el sistema de guardado.
@export var id_unico: String = ""

# Nombre del objeto que se necesita para abrir la puerta.
@export var item_requerida: String = "tarjeta_escape"


# Referencia al AnimatedSprite2D encargado de mostrar
# la animación de apertura de la puerta.
@onready var puerta: AnimatedSprite2D = $AnimatedSprite2D

# Referencia a la colisión de la puerta.
# Se desactiva cuando la puerta se abre.
@onready var colision: CollisionShape2D = $CollisionShape2D


# Indica si la puerta ya está abierta.
var abierta: bool = false

# Evita que el diálogo de despedida se muestre más de una vez.
var despedida_mostrada: bool = false


func _ready() -> void:

	# 1. Si no se asignó un ID manualmente desde el Inspector,
	# utiliza automáticamente la ruta de la puerta dentro de la escena.
	if id_unico == "":
		id_unico = str(get_path())

	# 2. Comprueba si la puerta ya había sido abierta anteriormente
	# y si su estado está registrado en los datos guardados.
	call_deferred("_comprobar_estado_guardado")


# Comprueba si la puerta aparece registrada como abierta en el guardado.
func _comprobar_estado_guardado() -> void:

	# Si el ID de la puerta está dentro de los objetos recolectados,
	# significa que la puerta ya fue abierta anteriormente.
	if id_unico in Guardado.objetos_recolectados:

		# Aplica inmediatamente el estado de puerta abierta.
		_aplicar_estado_abierto_inmediato()


# Se ejecuta constantemente mientras el juego está funcionando.
func _process(_delta: float) -> void:

	# Si la puerta ya está abierta, no continúa comprobando.
	if abierta:
		return

	# Comprueba si la tarjeta requerida se encuentra
	# dentro del inventario del jugador.
	if Inventario.tarjetas.has(item_requerida):

		# Si la tarjeta está en el inventario,
		# abre automáticamente la puerta.
		_abrir_puerta()


# Función encargada de abrir la puerta.
func _abrir_puerta() -> void:

	# Marca la puerta como abierta.
	abierta = true

	# Comprueba si el ID de la puerta todavía no está registrado
	# en los datos guardados.
	if not (id_unico in Guardado.objetos_recolectados):

		# Guarda el ID para recordar que la puerta ya fue abierta.
		Guardado.objetos_recolectados.append(id_unico)

	# Muestra en la consola que se detectó la tarjeta
	# y que la puerta se está abriendo.
	print("Tarjeta detectada, abriendo puerta")

	# Reproduce la animación de apertura de la puerta.
	puerta.play("open")

	# Desactiva la colisión para permitir que el jugador
	# pueda atravesar la puerta.
	colision.set_deferred("disabled", true)

	# Espera hasta que termine la animación de apertura.
	await puerta.animation_finished

	# Detiene la animación una vez que terminó.
	puerta.stop()

	# Mantiene la puerta en el frame 4,
	# que representa su estado completamente abierto.
	puerta.frame = 4


# Aplica el estado de puerta abierta inmediatamente.
# Se utiliza cuando la puerta ya estaba abierta en una partida guardada.
func _aplicar_estado_abierto_inmediato() -> void:

	# Marca la puerta como abierta.
	abierta = true

	# Desactiva la colisión de la puerta.
	colision.set_deferred("disabled", true)

	# Reproduce la animación de apertura.
	puerta.play("open")

	# Detiene la animación.
	puerta.stop()

	# Coloca la puerta directamente en el frame 4,
	# mostrando que ya está completamente abierta.
	puerta.frame = 4


# Se ejecuta cuando un cuerpo entra en el área de la puerta.
func _on_area_2d_body_entered(body):

	# Comprueba tres condiciones:
	# 1. La puerta debe estar abierta.
	# 2. El cuerpo debe pertenecer al grupo "player".
	# 3. El diálogo de despedida todavía no debe haberse mostrado.
	if abierta and body.is_in_group("player") and not despedida_mostrada:

		# Marca el diálogo como mostrado para evitar que se repita.
		despedida_mostrada = true

		# Silvestre muestra un mensaje de despedida al jugador.
		DialogoSilvestre.mostrar_secuencia([
			"Ten mucha suerte y toma justicia por mí. Muchas gracias."
		])

		# Espera a que termine el diálogo de Silvestre.
		# CONNECT_ONE_SHOT hace que esta conexión se ejecute solamente una vez.
		DialogoSilvestre.dialogo_terminado.connect(_ir_a_pantalla_final, CONNECT_ONE_SHOT)


# Se ejecuta cuando un cuerpo sale del área de la puerta.
# Actualmente no realiza ninguna acción.
func _on_area_2d_body_exited(body):
	pass


# Cambia la escena actual por la pantalla final del juego.
func _ir_a_pantalla_final():

	# Carga la escena de la pantalla final.
	get_tree().change_scene_to_file("res://scenes/maps/pantalla_final.tscn")
