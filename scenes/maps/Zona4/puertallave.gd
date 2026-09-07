extends StaticBody2D

# Identificador único de la puerta para el sistema de guardado.
@export var id_unico: String = ""

# Nombre de la llave necesaria para abrir esta puerta.
@export var llave_requerida: String = "llave_generica"


# Indica si el jugador se encuentra cerca de la puerta.
var jugador_cerca: bool = false

# Indica si la puerta ya fue abierta.
var esta_abierta: bool = false


# Referencia al AnimatedSprite2D encargado de mostrar
# la animación de apertura de la puerta.
@onready var puerta: AnimatedSprite2D = $AnimatedSprite2D

# Referencia a la colisión física de la puerta.
@onready var colision: CollisionShape2D = $CollisionShape2D

# Referencia al Area2D utilizado para detectar al jugador.
@onready var area: Area2D = $Area2D


func _ready() -> void:

	# 1. Si no se especificó un ID desde el Inspector,
	# genera automáticamente uno utilizando la ruta de la puerta.
	if id_unico == "":
		id_unico = str(get_path())

	# 2. Conecta la señal para detectar cuando el jugador
	# entra en el área de la puerta.
	area.body_entered.connect(_on_area_2d_body_entered)

	# Conecta la señal para detectar cuando el jugador
	# sale del área de la puerta.
	area.body_exited.connect(_on_area_2d_body_exited)

	# 3. Comprueba si la puerta ya había sido abierta
	# anteriormente y su estado está guardado.
	call_deferred("_comprobar_estado_guardado")


# Comprueba si la puerta aparece registrada como abierta
# en los datos guardados.
func _comprobar_estado_guardado() -> void:

	# Si el ID de la puerta está registrado como recolectado,
	# significa que ya fue abierta anteriormente.
	if id_unico in Guardado.objetos_recolectados:

		# Aplica inmediatamente el estado de puerta abierta.
		_aplicar_estado_abierto_inmediato()


# Se ejecuta constantemente mientras el juego está funcionando.
func _process(_delta: float) -> void:

	# Comprueba que la puerta esté cerrada,
	# que el jugador esté cerca y que haya presionado interactuar.
	if not esta_abierta and jugador_cerca and Input.is_action_just_pressed("interactuar"):

		# Comprueba si el jugador tiene la llave requerida
		# dentro de su inventario.
		if Inventario.llaves.has(llave_requerida):

			# Si tiene la llave correcta, abre la puerta.
			_abrir_puerta()

		# Si el jugador no tiene la llave necesaria,
		# muestra un mensaje en la consola.
		else:
			print("Necesitas la llave correspondiente.")


# Función encargada de abrir la puerta.
func _abrir_puerta() -> void:

	# Marca la puerta como abierta.
	esta_abierta = true

	# Registra el ID de la puerta en los datos guardados.
	# Esto permite recordar que ya fue abierta.
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)

	# Muestra en la consola que la puerta fue abierta.
	print("Puerta abierta")

	# Reproduce la animación de apertura.
	puerta.play("open")

	# Desactiva la colisión para permitir que el jugador
	# pueda atravesar la puerta.
	colision.set_deferred("disabled", true)

	# Espera hasta que termine la animación de apertura.
	await puerta.animation_finished

	# Detiene la animación después de terminar.
	puerta.stop()

	# Mantiene la puerta en el frame 4,
	# mostrando que está completamente abierta.
	puerta.frame = 4


# Aplica el estado de puerta abierta inmediatamente.
# Se utiliza cuando la puerta ya estaba abierta en el guardado.
func _aplicar_estado_abierto_inmediato() -> void:

	# Marca la puerta como abierta.
	esta_abierta = true

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

	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador está cerca de la puerta.
		jugador_cerca = true


# Se ejecuta cuando un cuerpo sale del área de la puerta.
func _on_area_2d_body_exited(body):

	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador ya no está cerca de la puerta.
		jugador_cerca = false
