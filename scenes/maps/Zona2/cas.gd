extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("¡Electrocutado!")
	
	#Regresa apunto de inicio
	body.global_position = Vector2(64, 128)
