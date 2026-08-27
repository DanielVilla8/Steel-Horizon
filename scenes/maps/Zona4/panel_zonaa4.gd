extends Node2D



@onready var interfaz = $Interfaz_panel
var jugador_cerca = false

func _ready():
	interfaz.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "personaje principal":
		jugador_cerca = true
		print("Presiona E para abrir el panel")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "personaje principal":
		jugador_cerca = false
		interfaz.visible = false

func _process(delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		interfaz.visible = not interfaz.visible
