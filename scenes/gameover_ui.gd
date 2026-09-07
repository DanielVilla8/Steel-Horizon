extends CanvasLayer

@onready var retry_button: Button = $Control/VBoxContainer/Button
@onready var menu_button: Button = $Control/VBoxContainer/Button2

func _ready() -> void:
	hide()#Oculta la pantalla al iniciar el juego
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
func trigger_game_over() -> void:
	show()
	get_tree().paused = true #Pausa del juego mientras esta el menu
	
func _on_retry_pressed() -> void:
	hide()#Oculta la interfaz
	get_tree().paused = false
	queue_free()
	get_tree().reload_current_scene() #Reinicia el nivel al punto inicial
	
func _on_menu_pressed() -> void:
	hide()#Oculta la interfaz
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
