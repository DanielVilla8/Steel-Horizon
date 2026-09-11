extends Control


@onready var texto = $ColorRect/TextoIntro    # Label con el texto de la intro
@onready var aviso = $AvisoContinuar          # Texto "Presiona ENTER para continuar"

# Texto completo de la introducción, se muestra letra por letra
var contenido_intro = "Es el año 2167, la empresa tecnológica Horizon es líder en tecnología y política. Tú, un reportero, decides investigar a fondo a la compañía, sin embargo te das cuenta de un plan perturbador que consta de unir a todas las mentes de la humanidad en una sola a través de la robotización.

Estás a punto de publicar la historia, sin embargo eres raptado y enviado a los laboratorios, en donde esperas a ser robotizado.

Tu objetivo es escapar sin ser detectado y llevar la historia a la luz."

var texto_completo = false   # Indica si ya terminó (o se saltó) la animación de escritura
var saltar_texto = false     # Le avisa al bucle de escritura que debe cortarse


func _ready() -> void:
	texto.text = contenido_intro    # Carga el texto completo en el nodo
	texto.visible_ratio = 0.0       # Empieza sin mostrar ninguna letra
	aviso.visible = false           # El aviso de continuar arranca oculto
	_animar_texto()                 # Inicia el efecto de escritura


func _animar_texto() -> void:
	# Va revelando el texto letra por letra
	var total = texto.get_total_character_count()
	for i in range(total + 1):
		if saltar_texto:      # Si se pidió saltar (ENTER presionado), corta el bucle
			break
		texto.visible_ratio = float(i) / total
		await get_tree().create_timer(0.03).timeout   # Pausa entre cada letra
	if not texto_completo:    # Evita repetir esto si ya se marcó completo desde _process
		texto.visible_ratio = 1.0
		texto_completo = true
		_parpadear_aviso()    # Cuando termina, empieza a parpadear el aviso


func _parpadear_aviso() -> void:
	# Alterna la visibilidad del aviso cada 0.6 segundos (efecto parpadeo)
	aviso.visible = true
	while true:
		aviso.visible = not aviso.visible
		await get_tree().create_timer(0.6).timeout


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("continuar"):
		if not texto_completo:
			# Primer ENTER: corta la animación en curso y muestra el texto completo de una vez
			saltar_texto = true
			texto.visible_ratio = 1.0
			texto_completo = true
			_parpadear_aviso()
		else:
			# Segundo ENTER (o si ya estaba completo): avanza a la siguiente escena
			get_tree().change_scene_to_file("res://scenes/maps/Zona1/zona1.tscn")
