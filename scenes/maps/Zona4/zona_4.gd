extends Node2D


@onready var pieza1: Area2D = $PiezaTarjeta1
@onready var pieza2: Area2D = $PiezaTarjeta2
@onready var pieza3: Area2D = $PiezaTarjeta3
@onready var tarjeta: Area2D = $Tarjeta

func _ready() -> void:
	MusicaManager.reproducir("zona4")
	tarjeta.visible = false
	tarjeta.monitoring = false

	# Silvestre comenta al entrar a la zona
	DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona4_intro", [
		"Algo de aquí me huele muy raro, busca algo por los pasillos."
	])

func revelar_piezas() -> void:
	# Reemplaza la línea 21 por una validación de instancia válida:
	if is_instance_valid(pieza1):
		pieza1.revelar()
	if is_instance_valid(pieza2):
		pieza2.revelar()
	if is_instance_valid(pieza3):
		pieza3.revelar()

func _process(_delta: float) -> void:
	if not is_instance_valid(tarjeta):
		return
	if Inventario.piezas_tarjeta >= 3 and not tarjeta.visible:
		tarjeta.activar()
