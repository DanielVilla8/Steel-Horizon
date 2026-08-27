extends StaticBody2D

@export var zona_requerida = "Zona1"
var jugador_cerca = false
@onready var puerta = $AnimatedSprite2D
@onready var colision = $CollisionShape2D

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		print("ID Inventario al revisar:", Inventario.get_instance_id(), " contenido:", Inventario.tarjetas)
		
		if Inventario.tarjetas.size() > 0:
			print("Comparación exacta: '", Inventario.tarjetas[0], "' == 'Zona1' -> ", Inventario.tarjetas[0] == "Zona3")
			print("Longitud del string guardado:", Inventario.tarjetas[0].length())
		else:
			print("El inventario de tarjetas está vacío")
		
		if Inventario.tarjetas.has(zona_requerida):
			print("Puerta abierta")
			puerta.play("open")
			$CollisionShape2D.set_deferred("disabled", true)
			await puerta.animation_finished
			puerta.stop()
			puerta.frame = 4
		else:
			print("Necesitas tarjeta de acceso.")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
