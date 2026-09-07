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
	DialogoSilvestre.mostrar_secuencia([
		"Algo de aquí me huele muy raro, busca algo por los pasillos."
	])

func revelar_piezas() -> void:
	pieza1.revelar()
	pieza2.revelar()
	pieza3.revelar()

func _process(_delta: float) -> void:
	if not is_instance_valid(tarjeta):
		return
	if Inventario.piezas_tarjeta >= 3 and not tarjeta.visible:
		tarjeta.activar()
