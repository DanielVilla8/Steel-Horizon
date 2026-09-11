extends Control

@onready var boton_continuar: Button = $ColorRect/VBoxContainer/Continuar

func _ready() -> void:
	# Se asegura de que el juego no arranque pausado al entrar al menú
	get_tree().paused = false
	# Reproduce la música del menú principal
	MusicaManager.reproducir("menu")
	
	# Deshabilita el botón si no existe la partida guardada
	if not FileAccess.file_exists("user://partida.save"):
		boton_continuar.disabled = true
		
func _on_play_pressed() -> void:
	#Comenzar partida nueva
	Guardado.reiniciar_partida()
	
	# Cambia a la pantalla de introducción para arrancar el juego desde cero
	get_tree().change_scene_to_file("res://scenes/maps/intro_screen.tscn")

func _on_continuar_pressed() -> void:
	#Cargar Partida
	# Intenta cargar los datos guardados de una partida anterior
	var datos = Guardado.cargar_partida()
	
	# Si no hay datos guardados, avisa por consola y no hace nada más
	if datos.is_empty():
		print("No hay partida guardada")
		return
		
	# Obtiene el nombre de la zona guardada (por defecto "zona1" si no existe el dato)
	var zona = str(datos.get("zona", "zona1")).strip_edges()
	
	print("Zona guardada: ", zona)
	
	# Variable donde se va a armar la ruta de la escena a cargar
	var ruta = ""
	
	# Según la zona guardada, arma la ruta correspondiente
	if zona == "Zona1":
		ruta = "res://scenes/maps/Zona1/zona1.tscn"
	
	elif zona == "Zona2":
		ruta = "res://scenes/maps/Zona2/zona2.tscn"
		
	elif zona == "Zona3":
		ruta = "res://scenes/maps/Zona3/zona3.tscn"
		
	elif zona == "Zona4":
		ruta = "res://scenes/maps/Zona4/zona4.tscn"
		
	else:
		# Si la zona guardada no coincide con ninguna conocida, avisa y sale
		print("Zona desconocida:", zona)
		return
		
	print("Intentando abrir:", ruta)
	
	# Verifica que el archivo de la escena realmente exista antes de cargarlo
	if ResourceLoader.exists(ruta):
		get_tree().change_scene_to_file(ruta)
		
	else:
		# Si la ruta no existe, muestra un error en consola en vez de romper el juego
		print("ERROR: No existe esta escena:")
		print(ruta)

func _on_options_pressed() -> void:
	# Cambia a la pantalla de Opciones (volumen, pantalla completa, etc.)
	get_tree().change_scene_to_file("res://scenes/opciones.tscn")

func _on_quit_pressed() -> void:
	# Cierra el videojuego por completo
	get_tree().quit()
