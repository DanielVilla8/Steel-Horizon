extends StaticBody2D

# Define la puerta como un cuerpo físico estático.
# Permite que la puerta tenga colisiones y pueda bloquear el paso del jugador.

@export var id_unico: String = ""
# Identificador único de la puerta.
# Sirve para saber qué puerta ya fue abierta y guardar ese estado.

@export var zona_requerida = "Zona1"
# Indica qué tarjeta necesita el jugador para abrir esta puerta.

var jugador_cerca: bool = false
# Indica si el jugador se encuentra cerca de la puerta.

var esta_abierta: bool = false
# Indica si la puerta ya está abierta.


@onready var puerta: AnimatedSprite2D = $AnimatedSprite2D
# Obtiene el nodo AnimatedSprite2D que contiene las animaciones de la puerta.

@onready var colision: CollisionShape2D = $CollisionShape2D
# Obtiene la colisión de la puerta.
# Esta colisión se desactiva cuando la puerta se abre.


func _ready() -> void:
	# Se ejecuta cuando la puerta está lista.
	# Comprueba si la puerta ya había sido abierta anteriormente.

	call_deferred("_comprobar_estado_guardado")
	# Llama a la función que comprueba el estado guardado.
	# call_deferred permite ejecutarla después de que la escena termine de inicializarse.


func _comprobar_estado_guardado() -> void:
	# Comprueba si el ID de esta puerta se encuentra entre los objetos
	# que el jugador ya ha recolectado/activado.

	if id_unico in Guardado.objetos_recolectados:
		# Si la puerta ya había sido abierta anteriormente:

		_aplicar_estado_abierto_inmediato()
		# La muestra directamente como abierta.


func _process(delta):
	# Se ejecuta continuamente y controla la interacción del jugador con la puerta.

	if not esta_abierta and jugador_cerca and Input.is_action_just_pressed("interactuar"):
		# Comprueba tres condiciones:
		# 1. La puerta todavía está cerrada.
		# 2. El jugador está cerca.
		# 3. El jugador presionó el botón de interacción.

		print("ID Inventario al revisar:", Inventario.get_instance_id(), " contenido:", Inventario.tarjetas)
		# Muestra en la consola el contenido actual de las tarjetas del inventario.


		if Inventario.tarjetas.size() > 0:
			# Comprueba si el jugador tiene al menos una tarjeta.

			print("Comparación exacta: '", Inventario.tarjetas[0], "' == 'Zona1' -> ", Inventario.tarjetas[0] == "Zona3")
			# Muestra en la consola una comparación para comprobar
			# qué tarjeta tiene el jugador.

			print("Longitud del string guardado:", Inventario.tarjetas[0].length())
			# Muestra la cantidad de caracteres de la tarjeta guardada.

		else:
			# Si no tiene ninguna tarjeta:

			print("El inventario de tarjetas está vacío")
			# Informa en la consola que no hay tarjetas.


		if Inventario.tarjetas.has(zona_requerida):
			# Comprueba si el inventario contiene la tarjeta necesaria
			# para abrir esta puerta.

			_abrir_puerta()
			# Si la tarjeta es correcta, abre la puerta.

		else:
			# Si no posee la tarjeta requerida:

			print("Necesitas tarjeta de acceso.")
			# Muestra un mensaje indicando que necesita una tarjeta.


func _abrir_puerta() -> void:
	# Función encargada de abrir la puerta.

	esta_abierta = true
	# Cambia el estado de la puerta a abierta.


	# Guardar el ID para que persista al cambiar de escena o cargar partida
	if not (id_unico in Guardado.objetos_recolectados):
		# Comprueba que el ID de la puerta todavía no esté guardado.

		Guardado.objetos_recolectados.append(id_unico)
		# Guarda el ID de la puerta para recordar que ya fue abierta.


	print("Puerta abierta")
	# Muestra en la consola que la puerta se abrió.

	puerta.play("open")
	# Reproduce la animación de apertura.

	colision.set_deferred("disabled", true)
	# Desactiva la colisión de la puerta.
	# Esto permite que el jugador pueda atravesarla.


	await puerta.animation_finished
	# Espera hasta que termine la animación de apertura.

	puerta.stop()
	# Detiene la animación.

	puerta.frame = 4
	# Mantiene la puerta visualmente en el último frame de la animación.


func _aplicar_estado_abierto_inmediato() -> void:
	# Aplica el estado de puerta abierta cuando se carga una partida.

	esta_abierta = true
	# Marca la puerta como abierta.

	colision.set_deferred("disabled", true)
	# Desactiva la colisión para permitir el paso.

	puerta.play("open")
	# Reproduce la animación de apertura.

	puerta.stop()
	# Detiene inmediatamente la animación.

	puerta.frame = 4
	# Deja la puerta en el frame correspondiente a su estado abierto.


func _on_area_2d_body_entered(body):
	# Se ejecuta cuando un cuerpo entra en el área cercana a la puerta.

	if body.is_in_group("player"):
		# Comprueba si el cuerpo que entró pertenece al grupo "player".

		jugador_cerca = true
		# Indica que el jugador está cerca de la puerta.


func _on_area_2d_body_exited(body):
	# Se ejecuta cuando un cuerpo sale del área de la puerta.

	if body.is_in_group("player"):
		# Comprueba si el cuerpo pertenece al grupo "player".

		jugador_cerca = false
		# Indica que el jugador ya no está cerca.
