extends Node2D


func _ready() -> void:
	MusicaManager.reproducir("zona3")
	DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona3_intro", [
		"Oh, esta habitación está infestada de robots, ¡UFFF, ESTOY CONTENTO DE NO ESTAR EN TU LUGAR!",
		"Debería haber algún objeto que nos pueda ayudar a avanzar a la siguiente habitación."
	])
