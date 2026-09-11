extends Control

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

func _on_timer_timeout() -> void:
	$TextoParpadeo.visible = !$TextoParpadeo.visible
