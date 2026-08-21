extends Area2D

#Nombre de la tarjeta
@export var nombre_tarjeta = "Zona1"

#Numero que entrega la tarjeta
@export var numero = 7

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
		
		#Guarda la tarjeta en el inventario
		Inventario.agregar_tarjeta(nombre_tarjeta)
		  
		#Guarda el numero en el inventario
		Inventario.agregar_numero(numero)
		
		print("Tarjeta obtenida:", nombre_tarjeta)
		print("Numero obtenido:", numero)
		
		queue_free()
