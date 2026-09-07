extends Control

# Referencia al slider que controla el volumen
@onready var slider_volumen = $Contenedor/SliderVolumen
# Referencia al botón de activar/desactivar pantalla completa
@onready var check_fullscreen = $Contenedor/CheckFullscreen

func _ready() -> void:
	# Sincroniza el slider con el volumen actual del bus Master
	# Obtiene el índice del bus "Master" (el bus general de audio)
	var bus_index = AudioServer.get_bus_index("Master")
	# Obtiene el volumen actual de ese bus, en decibeles
	var db = AudioServer.get_bus_volume_db(bus_index)
	# Convierte los decibeles a un valor lineal (0 a 1) y lo asigna al slider
	slider_volumen.value = db_to_linear(db)

	# Sincroniza el CheckButton con el estado actual de la ventana
	# Si la ventana ya está en modo pantalla completa, marca el CheckButton como activado
	check_fullscreen.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_slider_volumen_value_changed(value: float) -> void:
	# Se ejecuta cada vez que el jugador mueve el slider
	# Vuelve a obtener el bus Master
	var bus_index = AudioServer.get_bus_index("Master")
	# Convierte el valor lineal del slider (0 a 1) a decibeles y lo aplica al bus
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_check_fullscreen_toggled(button_pressed: bool) -> void:
	# Se ejecuta cuando el jugador activa o desactiva el CheckButton
	if button_pressed:
		# Si se activó, cambia la ventana a modo pantalla completa
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# Si se desactivó, vuelve al modo ventana normal
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_boton_volver_pressed() -> void:
	# Se ejecuta al presionar el botón "Volver"
	# Regresa al menú principal
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
