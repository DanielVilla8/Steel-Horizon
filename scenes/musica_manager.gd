extends Node

@onready var reproductor: AudioStreamPlayer2D = $Reproductor


var pistas = {
	"menu": preload("res://assets/audio/musica/menu.mp3"),
	"zona1": preload("res://assets/audio/musica/zona1.mp3"),
	"zona3": preload("res://assets/audio/musica/zona3.mp3"),
	"zona4": preload("res://assets/audio/musica/zona4.mp3"),
	"final": preload("res://assets/audio/musica/final.mp3"),
}

var pista_actual = ""

func reproducir(nombre: String) -> void:
	# Si ya está sonando esa misma pista, no la reinicia
	if nombre == pista_actual:
		return

	if not pistas.has(nombre):
		print("MusicaManager: no existe la pista '", nombre, "'")
		return

	pista_actual = nombre
	reproductor.stream = pistas[nombre]
	reproductor.stream.loop = true
	reproductor.play()

func detener() -> void:
	reproductor.stop()
	pista_actual = ""
