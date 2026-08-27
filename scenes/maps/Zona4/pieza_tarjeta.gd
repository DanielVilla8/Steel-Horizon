extends Area2D


var jugador_cerca = false

func _ready() -> void:
	visible = false
	monitoring = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false

func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		Inventario.agregar_pieza_tarjeta()
		queue_free()

func revelar() -> void:
	visible = true
	monitoring = true
