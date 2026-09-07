extends Area2D

func _ready() -> void:
	# Conecta la señal body_entered con la función
	# que detectará cuando un cuerpo entre al área.
	body_entered.connect(_on_body_entered)


# Se ejecuta cuando un cuerpo entra en el área del detonador.
func _on_body_entered(body: Node2D) -> void:

	# Muestra en la consola el nombre del cuerpo que entró.
	# Se utiliza principalmente para comprobar que la detección funciona.
	print("Detonador detectó:", body.name)

	# Comprueba si el cuerpo que entró pertenece al grupo "player".
	if body.is_in_group("player"):

		# Muestra en la consola que se detectó al jugador
		# y que se procederá a activar la bomba.
		print("Es el jugador, activando bomba")

		# Busca la bomba dentro de la escena Zona4
		# y llama a su función activar().
		get_node("/root/zona4/Bomba").activar()

		# Desactiva la detección del área para evitar
		# que el detonador vuelva a activarse.
		set_deferred("monitoring", false)

		# Silvestre avisa al jugador de que se activó
		# el protocolo de emergencia.
		DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona4_detonador", [
			"Oh, parece que se ha activado un protocolo de emergencia, deberías apagar la bomba lo más antes posible."
		])
