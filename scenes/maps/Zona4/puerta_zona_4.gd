extends StaticBody2D


@export var item_requerido = "tarjeta_escape"

@onready var puerta = $AnimatedSprite2D
@onready var colision = $CollisionShape2D

var abierta = false

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
	pass

func _on_area_2d_body_exited(body):
	pass
