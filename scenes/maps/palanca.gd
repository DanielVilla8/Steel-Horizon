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
	print("Palanca activada. Obtuviste la tarjeta y el código.")
	
	GameManager.tiene_tarjeta = true
	GameManager.codigo_nivel3 = 7

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true
		if not palanca_activada:
			$LabelInteractuar.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false
		$LabelInteractuar.visible = false
