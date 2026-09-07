extends Node2D

# Referencia a la llave que será revelada cuando la bomba sea desactivada.
@export var llave_generica: Area2D

# Referencia al temporizador de la bomba.
@onready var temporizador = $Timer

# Referencia al Label que muestra el tiempo restante.
@onready var label_contador = $Label

# Tiempo restante de la bomba en segundos.
var tiempo_restante = 60

# Indica si la bomba ya fue activada.
var activada = false

# Indica si la bomba ya fue desactivada.
var desactivada = false


func _ready() -> void:
	# Configura el temporizador para que se active cada 1 segundo.
	temporizador.wait_time = 1.0

	# Conecta la señal timeout del temporizador
	# con la función que controla la cuenta regresiva.
	temporizador.timeout.connect(_on_timer_timeout)

	# Oculta el contador al comenzar el juego.
	# Solo aparecerá cuando la bomba sea activada.
	label_contador.visible = false


# Activa la bomba y comienza la cuenta regresiva.
func activar() -> void:

	# Comprueba que la bomba no esté activada ni desactivada.
	if not activada and not desactivada:

		# Cambia el estado de la bomba a activada.
		activada = true

		# Establece el tiempo de la cuenta regresiva en 120 segundos.
		tiempo_restante = 120

		# Muestra el contador en pantalla.
		label_contador.visible = true

		# Muestra el tiempo inicial en el contador.
		label_contador.text = str(tiempo_restante)

		# Inicia el temporizador.
		temporizador.start()


# Se ejecuta cada vez que el temporizador llega a cero.
func _on_timer_timeout() -> void:

	# Reduce el tiempo restante en un segundo.
	tiempo_restante -= 1

	# Actualiza el número mostrado en pantalla.
	label_contador.text = str(tiempo_restante)

	# Comprueba si el tiempo llegó a cero.
	if tiempo_restante <= 0:

		# Si se terminó el tiempo, hace explotar la bomba.
		explotar()


# Función encargada de activar el Game Over.
func explotar() -> void:

	# Detiene el temporizador.
	temporizador.stop()

	# Muestra un mensaje en la consola.
	print("BOOM - fin del intento")

	# Busca el GameOverLayer en la escena actual
	# y muestra la pantalla de Game Over.
	get_tree().current_scene.get_node("GameOverLayer").mostrar()


# Desactiva la bomba.
func desactivar() -> void:

	# Cambia el estado de la bomba a desactivada.
	desactivada = true

	# Detiene la cuenta regresiva.
	temporizador.stop()

	# Cambia el texto del contador para indicar
	# que la bomba ya no representa una amenaza.
	label_contador.text = "Desactivada"
	
	# Comprueba que la referencia de la llave todavía exista.
	if is_instance_valid(llave_generica):

		# Si la llave existe, la revela al jugador.
		llave_generica.revelar()
