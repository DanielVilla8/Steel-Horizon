extends CharacterBody2D
@onready var special_collision: CollisionPolygon2D = $Area2D/specialCollision

@export var speed:float =200.0
@export var waypoints: Array[Marker2D]


var current_index = 0

func _physics_process(delta):
	var min_distance = 8.0
	var target_position = waypoints[current_index].global_position
	var direction = target_position - global_position
	var distance = direction.length()
	direction = direction.normalized()
	#Cambiar la animacion segun la direccion
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("right")
			$Area2D.rotation_degrees = 180
			$Area2D.position = Vector2(6, 0)
		else:
			$AnimatedSprite2D.play("left")
			$Area2D.rotation_degrees = 180
			$Area2D.position = Vector2(0, 0)
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("above")
			$Area2D.rotation_degrees = -90
			$Area2D.position = Vector2(4, -2)
		else:
			$AnimatedSprite2D.play("below")
			$Area2D.rotation_degrees = 90
			$Area2D.position = Vector2(4, 1)
			
	velocity = direction * speed
	
	if distance < min_distance:
		current_index += 1
		if current_index >= waypoints.size():
			current_index = 0
				 
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Detecto:", body.name)
	
	if body.is_in_group("player"):
		print("¡Jugador Detectado!")
		set_physics_process(false)
		special_collision.change_color(Color(Color.RED, 0.3))
