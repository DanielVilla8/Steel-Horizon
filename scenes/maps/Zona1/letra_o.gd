extends Area2D
#Pertenece a un nodo2D

# Letra asignada
@export var letra = "O"
# Indica si el jugador esta cerca de la letra
var jugador_cerca = false

func _on_body_entered(body):
	# Comprueba que el cuerpo que entra sea el jugador
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body):
	# Comprueba que el cuerpo que sale es el jugador
	if body.is_in_group("player"):
		jugador_cerca = false

func _process(delta):
	# Comprueba que el jugador este cerca de la letra y
	# que haya presionado la tecla asignada (E)
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		# Agrega la letra al inventario
		Inventario.agregar_letra(letra)
		# Elimina la letra de la escena
		queue_free()

		# Cuando se junta la última letra (las 5 en total: A, D, J, O, R),
		# Silvestre comenta sobre la contraseña
		if Inventario.letras.size() == 5:
			DialogoSilvestre.mostrar_secuencia([
				"Con el tiempo la contraseña ha sido cambiada, así que algunas letras no serán necesarias."
			])
