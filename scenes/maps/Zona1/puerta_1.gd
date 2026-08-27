extends StaticBody2D

#Comprueba si el jugador esta cerca
var jugador_cerca = false

@onready var puerta = $AnimatedSprite2D
@onready var colision = $CollisionShape2D

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		if Inventario.llaves.has("Llave1"):
			print("Puerta abierta")
			#Reproduce la animacion
			puerta.play("abrir")
			#Desactiva la colision
			$CollisionShape2D.set_deferred("disabled", true)
			#Cuando termine la animacion
			await puerta.animation_finished
			#Se queda en el ultimo fotograma
			puerta.stop()
			puerta.frame = 4
		else:
			print("Necesitas llave de acceso.")
			
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
