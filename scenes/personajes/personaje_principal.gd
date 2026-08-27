extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite
@export var speed = 200.0
var last_direction = "down"  # guarda hacia dónde miraba por última vez, para la animación Idle
@export var zona_actual = "Zona1"

func _ready() -> void:
	# Registra a este nodo en el grupo "player" al iniciar el juego.
	# Es esencial: todos tus scripts (Tarjeta, Puerta, Panel, Detonador) usan
	# body.is_in_group("player") para reconocer al jugador. Sin esta línea,
	# ninguno de esos sistemas te detecta, aunque choques con ellos.
	add_to_group("player")
	if Guardado.hay_partida:
		cargar()
	
func _physics_process(delta):
	# Lee el input direccional (WASD o flechas) como un vector
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if input_direction == Vector2.ZERO:
		# Sin input: se queda quieto, reproduce animación de reposo según la última dirección
		animated_sprite.play("Idle_" + last_direction)
	else:
		# Con input: determina la dirección dominante (horizontal vs vertical) para elegir animación
		if abs(input_direction.x) > abs(input_direction.y):
			if input_direction.x > 0:
				last_direction = "right"
			else:
				last_direction = "left"
		else:
			if input_direction.y > 0:
				last_direction = "down"
			else:
				last_direction = "up"
		animated_sprite.play("Walk_" + last_direction)

	move_and_slide()  # aplica el movimiento físico real usando la velocity calculadora

func guardar():
	Guardado.guardar_partida(zona_actual, global_position, last_direction)
	
func cargar():
	var datos = Guardado.cargar_partida()
	
	if datos.is_empty():
		return
		
	if datos.get("zona", "") != zona_actual:
		return
		
	global_position = Vector2(
		datos.get("posicion_x", global_position.x),
		datos.get("posicion_y", global_position.y)
		) 
	last_direction = datos.get("direccion", "down")
	animated_sprite.play("Idle_" + last_direction)
	print("posicion y animacion cargadas")
			
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		guardar()
		get_tree().quit()
