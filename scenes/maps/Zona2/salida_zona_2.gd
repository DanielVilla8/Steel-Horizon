extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("_cambiar_zona")
		
func _cambiar_zona():
	get_tree().change_scene_to_file("res://scenes/maps/Zona3/zona3.tscn")
