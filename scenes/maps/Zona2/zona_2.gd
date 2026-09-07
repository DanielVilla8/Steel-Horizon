extends Node2D


func _ready() -> void:
	MusicaManager.reproducir("zona2")
	DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona2_intro", [
		"¡OH MIRA ES UN LABERINTO MUY BRILLANTE, PARECE SER PAN COMIDO!",
		"OH, parece que las luces son únicamente temporales.",
		"Deberás avanzar con paciencia y memorizar el camino, pero tampoco te tardes demasiado, recuerda que el futuro de la humanidad depende de ti ¡SIN PRESIONES!"
	])
