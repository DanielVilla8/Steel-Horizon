extends Control


@onready var texto = $TextoCreditos

var velocidad = 40.0   # píxeles por segundo hacia arriba

func _process(delta: float) -> void:
	texto.position.y -= velocidad * delta
	
	# Cuando el texto termina de salir por arriba, vuelve al menú
	if texto.position.y + texto.size.y < 0:
		get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
	
	# Permite saltar los créditos presionando ENTER
	if Input.is_action_just_pressed("continuar"):
		get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
