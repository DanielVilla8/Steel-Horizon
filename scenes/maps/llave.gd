extends Area2D
# Define la llave como un Area2D, permitiendo detectar
# cuando el jugador entra o sale de su área.


# Nombre de la llave
@export var nombre_llave = "Llave1"
# Nombre que tendrá la llave dentro del inventario.


@export var id_unico: String = ""
# Identificador único de la llave.
# Sirve para saber si esta llave ya fue recogida y guardar ese estado.


# Indica si el jugador está cerca
var jugador_cerca = false
# Guarda si el jugador se encuentra dentro del área de la llave.


func _ready() -> void:
	# Se ejecuta cuando la llave está lista en la escena.

	# Si al cargar la partida este ID ya fue recogido,
	# desaparece del mapa automáticamente.
	if id_unico != "" and id_unico in Guardado.objetos_recolectados:
		# Comprueba que la llave tenga un ID y que ese ID
		# ya se encuentre registrado como recogido.

		queue_free()
		# Elimina la llave de la escena porque ya había sido recogida.

		
		call_deferred("_comprobar_si_ya_fue_recogido")
		# Llama posteriormente a otra función para comprobar
		# nuevamente si la llave ya fue recogida.


func _comprobar_si_ya_fue_recogido() -> void:
	# Comprueba si el ID de esta llave está registrado como recogido.

	if id_unico in Guardado.objetos_recolectados:
		# Si la llave ya fue recogida:

		queue_free()
		# Elimina la llave del mapa.


func _on_body_entered(body):
	# Se ejecuta cuando un cuerpo entra en el área de la llave.

	if body.is_in_group("player"):
		# Comprueba si el cuerpo que entró pertenece al grupo "player".

		jugador_cerca = true
		# Indica que el jugador está cerca de la llave.


func _on_body_exited(body):
	# Se ejecuta cuando un cuerpo sale del área de la llave.

	if body.is_in_group("player"):
		# Comprueba si el cuerpo pertenece al grupo "player".

		jugador_cerca = false
		# Indica que el jugador ya no está cerca.


func _process(delta):
	# Se ejecuta continuamente para comprobar si el jugador
	# quiere recoger la llave.

	# Comprueba que el jugador esté cerca de la llave
	# y que haya presionado la tecla asignada (E).
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		# Si el jugador está cerca y presiona la tecla de interacción:

		_recolectar_llave()
		# Llama a la función encargada de recoger la llave.


func _recolectar_llave() -> void:
	# Función encargada de registrar y recoger la llave.


	# 1. Registrar que este ID ya fue recogido en los datos de guardado
	if not (id_unico in Guardado.objetos_recolectados):
		# Comprueba que esta llave todavía no esté registrada.

		Guardado.objetos_recolectados.append(id_unico)
		# Guarda el ID de la llave como un objeto ya recogido.


	# 2. Agregar la llave al inventario
	Inventario.agregar_llave(nombre_llave)
	# Añade la llave al inventario del jugador.


	queue_free()
	# Elimina la llave de la escena después de recogerla.
