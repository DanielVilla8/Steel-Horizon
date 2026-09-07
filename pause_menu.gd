extends CanvasLayer

func _ready() -> void:
	#Aseguramos que el menu comience oculto
	hide()
	
func _input(event: InputEvent) -> void:
	#Si se presiona la tecla asignada a la pausa
	if event.is_action_pressed("UI PAUSE"):
		toggle_pause()
		
func toggle_pause() -> void:
	#Invertimos el estado de pause al juego
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	
	#Mostramos u ocultamos el menu segun el estado
	visible = new_pause_state
	
func _on_resume_button_pressed() -> void:
	#Al presionar "Reanudar", quitamos la pausa
	toggle_pause()
	
func _on_quit_button_pressed() -> void:
	# Cierra a la fuerza cualquier diálogo de Silvestre que haya quedado abierto
	DialogoSilvestre.forzar_cierre()
	
	# Busca al jugador (está en el grupo "player") y guarda la partida
	# antes de salir, para no perder el progreso actual
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador and jugador.has_method("guardar"):
		jugador.guardar()
	
	#Al presionar "Salir" cambair de escena
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
