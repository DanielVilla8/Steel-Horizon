extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("¡Electrocutado!")
		
		#Regresa el jugador al inicio
		body.global_position = Vector2(64,128)
		
		if "velocity" in body:
			body.velocity = Vector2.ZERO
