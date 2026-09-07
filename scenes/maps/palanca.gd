extends Node2D


var jugador_cerca = false
var palanca_activada = false

func _ready() -> void:
	$LabelInteractuar.visible = false

func _process(delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar") and not palanca_activada:
		activar_palanca()

func activar_palanca() -> void:
	palanca_activada = true
	$LabelInteractuar.visible = false
	print("Palanca activada. La tarjeta cayó cerca.")
	var tarjeta_roja = get_parent().get_node("tarjeta_roja")
	tarjeta_roja.visible = true
	tarjeta_roja.monitoring = true

	# Silvestre felicita al jugador y da la siguiente instrucción
	DialogoSilvestre.mostrar_secuencia([
		"¡Oh mira, la has encontrado, estoy orgulloso de ti!",
		"Recoje la tarjeta y busca la puerta para avanzar a la siguiente y última habitación. "
		
	])

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true
		if not palanca_activada:
			$LabelInteractuar.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false
		$LabelInteractuar.visible = false
