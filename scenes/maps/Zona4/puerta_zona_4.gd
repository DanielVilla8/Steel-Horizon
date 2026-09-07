extends StaticBody2D


@export var item_requerido = "tarjeta_escape"
@onready var puerta = $AnimatedSprite2D
@onready var colision = $CollisionShape2D
var abierta = false
var despedida_mostrada = false

func _process(delta):
	if abierta:
		return
	if Inventario.tarjetas.has(item_requerido):
		print("Tarjeta detectada, abriendo puerta")
		abierta = true
		puerta.play("open")
		colision.set_deferred("disabled", true)
		await puerta.animation_finished
		puerta.stop()
		puerta.frame = 4

func _on_area_2d_body_entered(body):
	if abierta and body.is_in_group("player") and not despedida_mostrada:
		despedida_mostrada = true
		DialogoSilvestre.mostrar_secuencia([
			"Ten mucha suerte y toma justicia por mí. Muchas gracias."
		])
		DialogoSilvestre.dialogo_terminado.connect(_ir_a_pantalla_final, CONNECT_ONE_SHOT)

func _on_area_2d_body_exited(body):
	pass

func _ir_a_pantalla_final():
	get_tree().change_scene_to_file("res://scenes/maps/pantalla_final.tscn")
