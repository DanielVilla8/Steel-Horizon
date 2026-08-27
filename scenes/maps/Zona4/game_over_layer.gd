extends CanvasLayer



func _ready():
	visible = false

func mostrar():
	visible = true
	get_tree().paused = true

func _on_reintentar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	call_deferred("_ir_al_menu")

func _ir_al_menu():
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

func _on_button_pressed() -> void:
	_on_reintentar_pressed()

func _on_button_2_pressed() -> void:
	_on_menu_pressed()
