extends Control


@onready var texto = $ColorRect/TextoIntro
@onready var aviso = $AvisoContinuar

var contenido_intro = "Es el año 2167, la empresa tecnológica Horizon es líder en tecnología y política. Tú, un reportero, decides investigar a fondo a la compañía, sin embargo te das cuenta de un plan perturbador que consta de unir a todas las mentes de la humanidad en una sola a través de la robotización.

Estás a punto de publicar la historia, sin embargo eres raptado y enviado a los laboratorios, en donde esperas a ser robotizado.

Tu objetivo es escapar sin ser detectado y llevar la historia a la luz."

var texto_completo = false

func _ready() -> void:
	texto.text = contenido_intro
	texto.visible_ratio = 0.0
	aviso.visible = false
	_animar_texto()

func _animar_texto() -> void:
	var total = texto.get_total_character_count()
	for i in range(total + 1):
		texto.visible_ratio = float(i) / total
		await get_tree().create_timer(0.03).timeout
	texto_completo = true
	_parpadear_aviso()

func _parpadear_aviso() -> void:
	aviso.visible = true
	while true:
		aviso.visible = not aviso.visible
		await get_tree().create_timer(0.6).timeout

func _process(delta: float) -> void:
	if texto_completo and Input.is_action_just_pressed("continuar"):
		get_tree().change_scene_to_file("res://scenes/maps/Zona1/zona1.tscn")
