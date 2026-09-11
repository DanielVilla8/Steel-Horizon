extends CharacterBody2D

# Define al enemigo como un CharacterBody2D, permitiendo controlar
# su movimiento y física.

@onready var special_collision: CollisionPolygon2D = $Area2D/specialCollision
# Obtiene el CollisionPolygon2D del área de visión del enemigo.
# Se utiliza para detectar al jugador dentro del cono de visión.

@onready var ray_cast: RayCast2D = $RayCast2D
# Obtiene el RayCast2D, que sirve para comprobar si existe
# una línea de visión directa entre el enemigo y el jugador.

@export var speed: float = 100.0
# Velocidad a la que se mueve el enemigo durante la patrulla.

@export var waypoints: Array[Marker2D]
# Lista de puntos (waypoints) que el enemigo seguirá durante su patrulla.

var current_index = 0
# Indica cuál waypoint está siguiendo actualmente.

var target_player: Node2D = null
# Guarda la referencia al jugador cuando este entra en el área de visión.


func _physics_process(delta):
	# Se ejecuta continuamente y controla la detección y el movimiento del enemigo.

	# Si se ha detectado al jugador dentro del área, verificar línea de visión directa
	if is_instance_valid(target_player):
		# Comprueba que el jugador detectado todavía existe.
		_check_and_kill_player()
		
	# Lógica de patrulla por waypoints
	if waypoints.size() == 0:
		# Comprueba si existen puntos de patrulla.

		return
		# Si no hay waypoints, el enemigo no realiza ningún movimiento.


	var min_distance = 5.0
	# Distancia mínima necesaria para considerar que el enemigo
	# llegó al waypoint.


	var target_position = waypoints[current_index].global_position
	# Obtiene la posición del waypoint actual.


	var direction = target_position - global_position
	# Calcula la dirección desde el enemigo hasta el waypoint.


	var distance = direction.length()
	# Calcula la distancia entre el enemigo y el waypoint.


	direction = direction.normalized()
	# Normaliza la dirección para obtener un vector de movimiento.


	# Cambiar la animación según la dirección
	if abs(direction.x) > abs(direction.y):
		# Determina si el movimiento es principalmente horizontal.

		if direction.x > 0:
			# Si se mueve hacia la derecha:

			$AnimatedSprite2D.play("right")
			# Reproduce la animación hacia la derecha.

			$Area2D.rotation_degrees = 180
			# Gira el cono de visión hacia la derecha.

			$Area2D.position = Vector2(12, 0)
			# Coloca el área de visión delante del enemigo.

		else:
			# Si se mueve hacia la izquierda:

			$AnimatedSprite2D.play("left")
			# Reproduce la animación hacia la izquierda.

			$Area2D.rotation_degrees = 0
			# Gira el cono de visión hacia la izquierda.

			$Area2D.position = Vector2(-12, 0)
			# Coloca el área de visión delante del enemigo.


	else:
		# Si el movimiento es principalmente vertical.

		if direction.y > 0:
			# Si se mueve hacia abajo:

			$AnimatedSprite2D.play("below")
			# Reproduce la animación hacia abajo.

			$Area2D.rotation_degrees = -90
			# Gira el cono de visión hacia abajo.

			$Area2D.position = Vector2(0, 12)
			# Coloca el área de visión delante del enemigo.

		else:
			# Si se mueve hacia arriba:

			$AnimatedSprite2D.play("above")
			# Reproduce la animación hacia arriba.

			$Area2D.rotation_degrees = 90
			# Gira el cono de visión hacia arriba.

			$Area2D.position = Vector2(0, -12)
			# Coloca el área de visión delante del enemigo.


	velocity = direction * speed
	# Calcula la velocidad del enemigo multiplicando la dirección
	# por la velocidad configurada.


	if distance < min_distance:
		# Comprueba si el enemigo llegó suficientemente cerca del waypoint.

		current_index += 1
		# Cambia al siguiente waypoint.

		if current_index >= waypoints.size():
			# Comprueba si ya llegó al último waypoint.

			current_index = 0
			# Si llegó al último, vuelve al primero para repetir la patrulla.
			
	move_and_slide()
	# Aplica el movimiento físico del enemigo.


func can_see_player() -> bool:
	# Función que determina si el enemigo tiene línea de visión directa hacia el jugador.

	if not is_instance_valid(target_player):
		# Comprueba que el jugador todavía exista.
		return false
		# Si no existe, devuelve falso.
		
	var player_target_point = target_player.global_position
	# Por defecto, el punto objetivo es el origen del jugador (puede ser
	# la cabeza/pivote del sprite, no el centro real de su colisión).
	if target_player.has_node("CollisionShape2D"):
		# Si el jugador tiene un CollisionShape2D, usamos su posición
		# global en vez del pivote del nodo, para apuntar al cuerpo real.
		player_target_point = target_player.get_node("CollisionShape2D").global_position
		# Esto evita que el rayo termine justo en la cabeza y nunca
		# llegue a cruzar la colisión del jugador (el bug original).
		
	ray_cast.global_position = $Area2D.global_position
	# Coloca el RayCast2D en la posición del enemigo.


	ray_cast.rotation = 0
	# Mantiene el RayCast2D sin rotación.


	ray_cast.target_position = ray_cast.to_local(player_target_point)
	# Dirige el RayCast2D desde el enemigo hacia la posición del jugador.


	ray_cast.add_exception(self)
	# Evita que el RayCast2D detecte al propio enemigo.

	ray_cast.force_raycast_update()
	# Actualiza inmediatamente el RayCast2D para obtener información actualizada.
	
	if ray_cast.is_colliding():
		# Comprueba si el rayo chocó contra algún objeto.
		var collider = ray_cast.get_collider()
		# Obtiene el objeto contra el que chocó el rayo.

		print("Choco contra: ", collider.name)
		# Muestra en la consola qué objeto fue detectado.

		return collider == target_player
		# Devuelve true solamente si el objeto detectado es el jugador.


	return false
	# Si no encontró ningún objeto, devuelve false.
	
func _check_and_kill_player() -> void:
	if can_see_player():
		print("¡Jugador visto y capturado!")
		
		if special_collision and special_collision.has_method("change_color"):
			special_collision.change_color(Color(Color.RED, 0.3))
			# Este código intenta cambiar el color del área de visión,
			# pero está después de return, por lo que actualmente no se ejecuta.
			

		set_physics_process(false)
		
		if target_player.has_method("die"):
			target_player.die()

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Se ejecuta cuando un cuerpo entra en el área de visión del enemigo.

	print("Detecto:", body.name)
	# Muestra en la consola qué cuerpo entró al área.

	if body.is_in_group("player"):
		# Comprueba si el cuerpo pertenece al grupo "player".

		print("Jugador entro al cono de vision")
		# Indica que el jugador entró en el cono de visión.

		target_player = body
		# Guarda al jugador como objetivo para comprobar posteriormente
		# si existe una línea de visión directa.
		
		_check_and_kill_player()
		# Evaluar inmediatamente al entrar para evitar que la salida rápida lo cancele
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	# Se ejecuta cuando un cuerpo sale del área de visión.

	if body == target_player:
		# Comprueba si el cuerpo que salió era el jugador detectado.

		print("Jugador salio del cono")
		# Muestra en la consola que el jugador salió del área.

		target_player = null
		# Elimina al jugador como objetivo.
