extends Node2D



@onready var temporizador = $Timer
@onready var label_contador = $Label
var tiempo_restante = 60  # segundos antes de que explote — ajusta a tu gusto
var activada = false
var desactivada = false

func _ready() -> void:
	temporizador.wait_time = 1.0
	temporizador.timeout.connect(_on_timer_timeout)
	label_contador.visible = false  # oculto hasta que se active

func activar() -> void:
	if not activada and not desactivada:
		activada = true
		tiempo_restante = 120
		label_contador.visible = true
		label_contador.text = str(tiempo_restante)
		temporizador.start()

func _on_timer_timeout() -> void:
	tiempo_restante -= 1
	label_contador.text = str(tiempo_restante)
	if tiempo_restante <= 0:
		explotar()

func explotar() -> void:
	temporizador.stop()
	print("BOOM - fin del intento")
	get_tree().current_scene.get_node("GameOverLayer").mostrar()

func desactivar() -> void:
	desactivada = true
	temporizador.stop()
	label_contador.text = "Desactivada"
