extends StaticBody2D

# Identificador único de la puerta para el sistema de guardado.
@export var id_unico: String = ""

# Nombre de la tarjeta necesaria para abrir esta puerta.
@export var zona_requerida = "Zona3"

# Indica si el jugador se encuentra cerca de la puerta.
var jugador_cerca: bool = false

# Indica si la puerta ya está abierta.
var esta_abierta: bool = false

# Referencia al AnimatedSprite2D encargado de reproducir
# la animación de apertura de la puerta.
@onready var puerta: AnimatedSprite2D = $AnimatedSprite2D

# Referencia a la forma de colisión de la puerta.
@onready var colision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	# Comprueba si la puerta ya fue abierta anteriormente
	# y si su estado está registrado en la partida guardada.
	call_deferred("_comprobar_estado_guardado")


# Comprueba si la puerta ya había sido abierta anteriormente.
func _comprobar_estado_guardado() -> void:
	# Si el ID de la puerta está registrado como recogido/abierto,
	# aplica inmediatamente el estado de puerta abierta.
	if id_unico in Guardado.objetos_recolectados:
		_aplicar_estado_abierto_inmediato()


# Se ejecuta constantemente mientras el juego está funcionando.
func _process(delta):
	# Comprueba que la puerta esté cerrada,
	# que el jugador esté cerca y que haya presionado el botón de interactuar.
	if not esta_abierta and jugador_cerca and Input.is_action_just_pressed("interactuar"):

		# Muestra en la consola el ID del inventario
		# y las tarjetas que contiene actualmente.
		print("ID Inventario al revisar:", Inventario.get_instance_id(), " contenido:", Inventario.tarjetas)
		
		# Comprueba si el jugador tiene al menos una tarjeta.
		if Inventario.tarjetas.size() > 0:

			# Comprueba si la primera tarjeta del inventario
			# coincide exactamente con "Zona3".
			print("Comparación exacta: '", Inventario.tarjetas[0], "' == 'Zona3' -> ", Inventario.tarjetas[0] == "Zona3")

			# Muestra la cantidad de caracteres que tiene
			# el nombre de la tarjeta guardada.
			print("Longitud del string guardado:", Inventario.tarjetas[0].length())

		else:
			# Informa en la consola que no hay tarjetas en el inventario.
			print("El inventario de tarjetas está vacío")
		
		# Comprueba si el inventario contiene la tarjeta requerida.
		if Inventario.tarjetas.has(zona_requerida):

			# Si el jugador tiene la tarjeta Zona3,
			# se llama a la función para abrir la puerta.
			_abrir_puerta()

		else:
			# Si no tiene la tarjeta necesaria,
			# muestra un mensaje en la consola.
			print("Necesitas tarjeta de acceso.")


# Función encargada de abrir la puerta.
func _abrir_puerta() -> void:
	# Cambia el estado de la puerta a abierta.
	esta_abierta = true
	
	# Guarda el ID de la puerta para que permanezca abierta
	# al cambiar de escena o cargar la partida.
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)
		
	# Muestra en la consola que la puerta fue abierta.
	print("Puerta abierta")

	# Reproduce la animación de apertura de la puerta.
	puerta.play("open")

	# Desactiva la colisión para permitir que el jugador
	# pueda atravesar la puerta.
	colision.set_deferred("disabled", true)

	# Espera hasta que termine la animación de apertura.
	await puerta.animation_finished

	# Detiene la animación.
	puerta.stop()

	# Coloca el sprite en el frame 4,
	# que representa la puerta completamente abierta.
	puerta.frame = 4


# Aplica inmediatamente el estado de puerta abierta
# cuando se carga una partida donde la puerta ya estaba abierta.
func _aplicar_estado_abierto_inmediato() -> void:
	# Establece la puerta como abierta.
	esta_abierta = true

	# Desactiva la colisión de la puerta.
	colision.set_deferred("disabled", true)

	# Reproduce la animación de apertura.
	puerta.play("open")

	# Detiene la animación inmediatamente.
	puerta.stop()

	# Coloca la puerta directamente en el frame 4,
	# mostrando que ya está completamente abierta.
	puerta.frame = 4


# Se ejecuta cuando un cuerpo entra en el área de detección de la puerta.
func _on_area_2d_body_entered(body):
	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador está cerca de la puerta.
		jugador_cerca = true


# Se ejecuta cuando un cuerpo sale del área de detección de la puerta.
func _on_area_2d_body_exited(body):
	# Comprueba si el cuerpo pertenece al grupo "player".
	if body.is_in_group("player"):

		# Indica que el jugador ya no está cerca de la puerta.
		jugador_cerca = false
