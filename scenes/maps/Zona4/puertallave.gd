extends StaticBody2D


@export var llave_requerida = "llave_generica"
var jugador_cerca = false
@onready var puerta = $AnimatedSprite2D
@onready var colision = $CollisionShape2D
@onready var area = $Area2D

func _ready():
	area.body_entered.connect(_on_area_2d_body_entered)
	area.body_exited.connect(_on_area_2d_body_exited)

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		if Inventario.llaves.has(llave_requerida):
			print("Puerta abierta")
			puerta.play("open")
			$CollisionShape2D.set_deferred("disabled", true)
			await puerta.animation_finished
			puerta.stop()
			puerta.frame = 4
		else:
			print("Necesitas la llave correspondiente.")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
