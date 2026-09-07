extends Area2D


@export var nombre_tarjeta: String = "tarjeta_escape"
var jugador_cerca = false

func _ready() -> void:
	visible = false
	monitoring = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func activar() -> void:
	visible = true
	monitoring = true
	await get_tree().physics_frame
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			jugador_cerca = true

func _on_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		Inventario.agregar_tarjeta(nombre_tarjeta)
		print("Tarjeta recogida:", nombre_tarjeta)

		# Silvestre comenta que ya no hacía falta buscar las piezas
		DialogoSilvestre.mostrar_secuencia([
			"Oh, parece que no había necesidad de encontrar esa última tarjeta, discúlpame jeje."
		])

		queue_free()
