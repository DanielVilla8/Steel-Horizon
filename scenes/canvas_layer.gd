extends CanvasLayer


@onready var label_numero = $LabelNumero

func _ready() -> void:
	label_numero.visible = false

func mostrar_numero(numero) -> void:
	label_numero.text = "Número: " + str(numero)
	label_numero.visible = true
	await get_tree().create_timer(5.0).timeout
	label_numero.visible = false
