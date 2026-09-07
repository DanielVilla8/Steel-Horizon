extends CanvasLayer


signal dialogo_terminado

@onready var caja = $PanelDialogo/Caja
@onready var texto = $PanelDialogo/Caja/TextoDialogo

var cola: Array = []
var dialogo_activo = false
var escribiendo = false

func _ready() -> void:
	caja.visible = false

func mostrar(mensaje: String) -> void:
	mostrar_secuencia([mensaje])

func mostrar_secuencia(mensajes: Array) -> void:
	cola = mensajes.duplicate()
	caja.visible = true
	dialogo_activo = true
	get_tree().paused = true
	_siguiente_linea()

func _siguiente_linea() -> void:
	if cola.is_empty():
		_cerrar()
		return
	var linea = cola.pop_front()
	texto.text = linea
	texto.visible_ratio = 0.0
	escribiendo = true
	_animar_texto()

func _animar_texto() -> void:
	var total = texto.get_total_character_count()
	for i in range(total + 1):
		texto.visible_ratio = float(i) / total
		await get_tree().create_timer(0.02).timeout
	escribiendo = false

func _process(delta: float) -> void:
	if dialogo_activo and Input.is_action_just_pressed("interactuar"):
		if escribiendo:
			texto.visible_ratio = 1.0
			escribiendo = false
		else:
			_siguiente_linea()

func _cerrar() -> void:
	caja.visible = false
	dialogo_activo = false
	get_tree().paused = false
	dialogo_terminado.emit()
