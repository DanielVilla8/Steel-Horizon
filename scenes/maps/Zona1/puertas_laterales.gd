extends StaticBody2D

@export var id_unico: String = ""
@export var llave_requerida: String = "Llave1"
#Comprueba si el jugador esta cerca
var jugador_cerca: bool = false
var esta_abierta: bool = false
@onready var puerta: AnimatedSprite2D = $AnimatedSprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D
func _ready() -> void:
	# 2. Verificar si la puerta ya se abrió previamente en el guardado
	call_deferred("_comprobar_estado_guardado")

func _comprobar_estado_guardado() -> void:
	if id_unico in Guardado.objetos_recolectados:
		_aplicar_estado_abierto_inmediato()
		
func _process(delta):
	if not esta_abierta and jugador_cerca and Input.is_action_just_pressed("interactuar"):
		if Inventario.llaves.has(llave_requerida):
			_abrir_puerta()
		else:
			print("Necesitas llave de acceso.")

func _abrir_puerta() -> void:
	esta_abierta = true

	# Registrar el ID en los datos de guardado
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)

	print("Puerta abierta")
	# Reproduce la animación
	puerta.play("open")
	# Desactiva la colisión
	colision.set_deferred("disabled", true)
	# Cuando termine la animación
	await puerta.animation_finished
	# Se queda en el último fotograma
	puerta.stop()
	puerta.frame = 6

func _aplicar_estado_abierto_inmediato() -> void:
	esta_abierta = true
	colision.set_deferred("disabled", true)
	puerta.play("open")
	puerta.stop()
	puerta.frame = 6
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
