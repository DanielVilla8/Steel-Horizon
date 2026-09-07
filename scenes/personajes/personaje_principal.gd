extends CharacterBody2D

# Referencia al nodo que contiene las animaciones del personaje.
@onready var animated_sprite = $AnimatedSprite

# Velocidad de movimiento del jugador.
@export var speed = 200.0

# Guarda la última dirección en la que miró el personaje
# para reproducir la animación Idle correspondiente.
var last_direction = "down"

# Indica la zona en la que se encuentra actualmente el jugador.
@export var zona_actual = "Zona1"


func _ready() -> void:
	# Activa el procesamiento de física del personaje.
	set_physics_process(true)
	
	# Agrega al personaje al grupo "player" para que otros objetos
	# puedan identificarlo como el jugador.
	add_to_group("player")
	
	# Si existe una partida guardada, carga sus datos.
	if Guardado.hay_partida:
		cargar()


func _physics_process(delta):
	# Obtiene la dirección introducida mediante las teclas configuradas.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# Calcula la velocidad según la dirección y la velocidad establecida.
	velocity = input_direction * speed

	# Comprueba si el jugador está quieto.
	if input_direction == Vector2.ZERO:
		# Reproduce la animación de reposo según la última dirección.
		animated_sprite.play("Idle_" + last_direction)
	else:
		# Determina si el movimiento es principalmente horizontal o vertical.
		if abs(input_direction.x) > abs(input_direction.y):
			if input_direction.x > 0:
				# El jugador se está moviendo hacia la derecha.
				last_direction = "right"
			else:
				# El jugador se está moviendo hacia la izquierda.
				last_direction = "left"
		else:
			if input_direction.y > 0:
				# El jugador se está moviendo hacia abajo.
				last_direction = "down"
			else:
				# El jugador se está moviendo hacia arriba.
				last_direction = "up"
		
		# Reproduce la animación de caminar correspondiente.
		animated_sprite.play("Walk_" + last_direction)

	# Aplica el movimiento y las colisiones del personaje.
	move_and_slide()


# Guarda los datos actuales del jugador.
func guardar():
	Guardado.guardar_partida(zona_actual, global_position, last_direction)


# Carga los datos de una partida guardada.
func cargar():
	var datos = Guardado.cargar_partida()
	
	# Si no existen datos guardados, termina la función.
	if datos.is_empty():
		return
		
	# Solo carga la posición si la partida pertenece a la zona actual.
	if datos.get("zona", "") != zona_actual:
		return
	
	# Recupera la posición guardada del jugador.
	global_position = Vector2(
		datos.get("posicion_x", global_position.x),
		datos.get("posicion_y", global_position.y)
	)
	
	# Recupera la última dirección del personaje.
	last_direction = datos.get("direccion", "down")
	
	# Reproduce la animación Idle según la dirección recuperada.
	animated_sprite.play("Idle_" + last_direction)
	
	print("Posición y animación cargadas")


# Detecta cuando se intenta cerrar el juego.
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Guarda automáticamente la partida antes de cerrar.
		guardar()
		
		# Cierra el juego.
		get_tree().quit()


# Función que se ejecuta cuando el jugador muere.
func die() -> void:
	# Detiene el procesamiento de movimiento y física.
	set_physics_process(false)
	
	# Muestra la pantalla de Game Over.
	GameOverManager.show_game_over()
