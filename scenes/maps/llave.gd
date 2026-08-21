extends Area2D

#Nombre de la llave
@export var nombre_llave = "Llave1"
#Indica si el jugador esta cerca
var jugador_cerca = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
		
func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		#Guarda llave en el inventario
		Inventario.agregar_llave(nombre_llave)
		print("Llave obtenida:", nombre_llave)
		queue_free()
