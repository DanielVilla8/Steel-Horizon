extends Node

var game_over_ui_scene = preload("res://scenes/gameover_ui.tscn")
var current_ui_instance = null

func show_game_over() -> void:
	print("Mostrando Game Over")
	
	if current_ui_instance == null or not is_instance_valid(current_ui_instance):
		current_ui_instance = game_over_ui_scene.instantiate() as CanvasLayer
		get_tree().root.add_child(current_ui_instance)
		
		current_ui_instance.layer = 100
		current_ui_instance.trigger_game_over()
