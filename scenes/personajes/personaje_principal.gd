extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite

var speed = 150.0
var last_direction = "down"

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")

	velocity = input_direction * speed

	if input_direction == Vector2.ZERO:
		animated_sprite.play("Idle_" + last_direction)
	else:
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

	move_and_slide()
