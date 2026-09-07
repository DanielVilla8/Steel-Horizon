extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Detonador detectó:", body.name)  # línea de prueba
	if body.is_in_group("player"):
		print("Es el jugador, activando bomba")  # línea de prueba
		get_node("/root/zona4/Bomba").activar()
		set_deferred("monitoring", false)

		# Silvestre avisa que se activó el protocolo de emergencia
		DialogoSilvestre.mostrar_secuencia([
			"Oh, parece que se ha activado un protocolo de emergencia, deberías apagar la bomba lo más antes posible."
		])
