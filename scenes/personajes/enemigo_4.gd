extends CharacterBody2D

@onready var special_Collision: CollisionPolygon2D = $Area2D/specialCollision
@onready var ray_cast: RayCast2D = $RayCast2D

@export var speed: float = 150.0
@export var waypoints: Array[Marker2D]

var target_player: Node2D = null
var current_index = 0

func _physics_process(delta):
	# Si se ha detectado al jugador dentro del área, verificar línea de visión directa
	if is_instance_valid(target_player):
		if can_see_player():
			print("¡Jugador visto y capturado!")
			set_physics_process(false)
			target_player.die()
			return # Detiene la patrulla
			
			if special_Collision and special_Collision.has_method("change_color"):
				special_Collision.change_color(Color(Color.RED, 0.3))

	# Lógica de patrulla por waypoints
	if waypoints.size() == 0:
		return
		
	var min_distance = 8.0
	var target_position = waypoints[current_index].global_position
	var direction = target_position - global_position
	var distance = direction.length()
	direction = direction.normalized()
	#Cambiar la animacion segun la direccion
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("rigth")
			$Area2D.rotation_degrees = 180
			$Area2D.position = Vector2(9, 0)
		else:
				$AnimatedSprite2D.play("left")
				$Area2D.rotation_degrees = 0
				$Area2D.position = Vector2(0, 0)
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("above")
			$Area2D.rotation_degrees = -90
			$Area2D.position = Vector2(0, 7)
		else:
			$AnimatedSprite2D.play("below")
			$Area2D.rotation_degrees = 90
			$Area2D.position = Vector2(0, 4)
	velocity = direction * speed
	
	if distance < min_distance:
		current_index += 1
		if current_index >= waypoints.size():
			current_index = 0
		
	move_and_slide()

func can_see_player() -> bool:
	if not is_instance_valid(target_player):
		return false

	ray_cast.global_position = global_position
	ray_cast.rotation = 0
	ray_cast.target_position = ray_cast.to_local(target_player.global_position)

	ray_cast.add_exception(self)
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		print("Choco contra: ", collider.name)
		return collider == target_player

	return false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Detecto:", body.name)
	if body.is_in_group("player"):
		print("Jugador entro al cono de vision")
		target_player = body
		# OJO: ya no se llama a die() aquí — eso lo decide can_see_player()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == target_player:
		print("Jugador salio del cono")
		target_player = null
