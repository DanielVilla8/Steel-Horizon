extends Control

func _ready() -> void:
	get_tree().paused = false
	MusicaManager.reproducir("menu")

func _on_play_pressed() -> void:
	#Comenzar partida nueva
	Inventario.letras.clear()
	Inventario.tarjetas.clear()
	Inventario.numeros.clear()
	Inventario.llaves.clear()
	
	get_tree().change_scene_to_file("res://scenes/maps/intro_screen.tscn")

func _on_continuar_pressed() -> void:
	#Cargar Partida
	var datos = Guardado.cargar_partida()
	
	if datos.is_empty():
		print("No hay partida guardada")
		return
		
	var zona = str(datos.get("zona", "zona1")).strip_edges()
	
	print("Zona guardada: ", zona)
	
	var ruta = ""
	
	if zona == "Zona1":
		ruta = "res://scenes/maps/Zona1/zona1.tscn"
	
	elif zona == "Zona2":
		ruta = "res://scenes/maps/Zona2/zona2.tscn"
		
	elif zona == "Zona3":
		ruta = "res://scenes/maps/Zona3/zona3.tscn"
		
	elif zona == "Zona4":
		ruta = "res://scenes/maps/Zona4/zona4.tscn"
		
	else:
		print("Zona desconocida:", zona)
		return
		
	print("Intentando abrir:", ruta)
	
	if ResourceLoader.exists(ruta):
		get_tree().change_scene_to_file(ruta)
		
	else:
		print("ERROR: No existe esta escena:")
		print(ruta)

func _on_options_pressed() -> void:
	print("Opciones")

func _on_quit_pressed() -> void:
	get_tree().quit()
