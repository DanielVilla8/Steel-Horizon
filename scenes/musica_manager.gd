extends Node

# Referencia al reproductor de audio que se encuentra
# dentro del nodo Reproductor.
@onready var reproductor: AudioStreamPlayer2D = $Reproductor


# Diccionario que contiene todas las pistas musicales del juego.
# Cada nombre funciona como identificador para poder reproducir
# una canción específica.
var pistas = {

	# Música que se reproduce en el menú principal.
	"menu": preload("res://assets/audio/musica/menu.mp3"),

	# Música correspondiente a la Zona 1.
	"zona1": preload("res://assets/audio/musica/zona1.mp3"),

	# Música correspondiente a la Zona 3.
	"zona3": preload("res://assets/audio/musica/zona3.mp3"),

	# Música correspondiente a la Zona 2.
	"zona2": preload("res://assets/audio/musica/zona2.mp3"),

	# Música correspondiente a la Zona 4.
	"zona4": preload("res://assets/audio/musica/zona4.mp3"),

	# Música que se reproduce en la escena final.
	"final": preload("res://assets/audio/musica/final.mp3"),
}


# Guarda el nombre de la pista que se está reproduciendo actualmente.
# Comienza vacío porque al iniciar todavía no hay ninguna canción.
var pista_actual = ""


# Función encargada de reproducir una pista musical.
# Recibe como parámetro el nombre de la pista que se quiere reproducir.
func reproducir(nombre: String) -> void:

	# Comprueba si la pista solicitada ya es la que está sonando.
	# Si es la misma, evita reiniciarla.
	if nombre == pista_actual:
		return

	# Comprueba si el nombre de la pista existe dentro del diccionario.
	if not pistas.has(nombre):

		# Muestra un mensaje de error en la consola si no existe.
		print("MusicaManager: no existe la pista '", nombre, "'")

		# Detiene la función para evitar intentar reproducir una pista inexistente.
		return

	# Guarda el nombre de la nueva pista como la pista actual.
	pista_actual = nombre

	# Asigna al reproductor de audio la pista seleccionada.
	reproductor.stream = pistas[nombre]

	# Hace que la canción se repita automáticamente
	# cuando llegue al final.
	reproductor.stream.loop = true

	# Inicia la reproducción de la música.
	reproductor.play()


# Función encargada de detener la música actual.
func detener() -> void:

	# Detiene la reproducción del reproductor de audio.
	reproductor.stop()

	# Limpia el nombre de la pista actual,
	# indicando que ya no hay ninguna música reproduciéndose.
	pista_actual = ""
