extends CanvasLayer

# Señal que se emite cuando el diálogo termina completamente.
signal dialogo_terminado


# Referencia a la caja principal donde se muestra el diálogo.
@onready var caja = $PanelDialogo/Caja

# Referencia al nodo de texto donde se muestran los mensajes.
@onready var texto = $PanelDialogo/Caja/TextoDialogo


# Guarda las líneas de diálogo que están pendientes de mostrar.
var cola: Array = []

# Indica si actualmente hay un diálogo activo.
var dialogo_activo = false

# Indica si el texto de la línea actual todavía se está escribiendo.
var escribiendo = false


# Se ejecuta cuando se inicia el nodo.
func _ready() -> void:

	# Oculta la caja de diálogo al comenzar el juego.
	caja.visible = false


# Función para mostrar un solo mensaje.
# Recibe el mensaje que se quiere mostrar.
func mostrar(mensaje: String) -> void:

	# Convierte el mensaje individual en una secuencia
	# para utilizar el mismo sistema de diálogos.
	mostrar_secuencia([mensaje])


# Función encargada de mostrar varios mensajes consecutivos.
func mostrar_secuencia(mensajes: Array) -> void:

	# Copia los mensajes recibidos a la cola de diálogos.
	cola = mensajes.duplicate()

	# Hace visible la caja de diálogo.
	caja.visible = true

	# Indica que existe un diálogo activo.
	dialogo_activo = true

	# Pausa el juego mientras se muestra el diálogo.
	get_tree().paused = true

	# Comienza mostrando la primera línea de la cola.
	_siguiente_linea()


# Función que muestra la siguiente línea del diálogo.
func _siguiente_linea() -> void:

	# Comprueba si ya no quedan mensajes en la cola.
	if cola.is_empty():

		# Si no quedan mensajes, cierra el diálogo.
		_cerrar()

		# Detiene la función.
		return

	# Obtiene y elimina el primer mensaje de la cola.
	var linea = cola.pop_front()

	# Coloca la línea obtenida dentro del cuadro de texto.
	texto.text = linea

	# Hace que inicialmente no se vea ningún carácter.
	texto.visible_ratio = 0.0

	# Indica que el texto está siendo escrito.
	escribiendo = true

	# Comienza la animación de escritura del texto.
	_animar_texto()


# Función que muestra el texto poco a poco,
# simulando el efecto de escritura.
func _animar_texto() -> void:

	# Obtiene la cantidad total de caracteres del mensaje.
	var total = texto.get_total_character_count()

	# Recorre todos los caracteres del mensaje.
	for i in range(total + 1):

		# Aumenta progresivamente la cantidad de texto visible.
		texto.visible_ratio = float(i) / total

		# Espera 0.02 segundos antes de mostrar el siguiente carácter.
		await get_tree().create_timer(0.02).timeout

	# Indica que la escritura de la línea ha terminado.
	escribiendo = false


# Se ejecuta continuamente mientras el juego está funcionando.
func _process(delta: float) -> void:

	# Comprueba si hay un diálogo activo y si el jugador presionó
	# la tecla o acción configurada como "interactuar".
	if dialogo_activo and Input.is_action_just_pressed("interactuar"):

		# Comprueba si el texto todavía se está escribiendo.
		if escribiendo:

			# Muestra inmediatamente todo el texto.
			texto.visible_ratio = 1.0

			# Indica que la escritura terminó.
			escribiendo = false

		else:

			# Si el texto ya terminó de escribirse,
			# muestra la siguiente línea.
			_siguiente_linea()


# Función encargada de cerrar completamente el diálogo.
func _cerrar() -> void:

	# Oculta la caja de diálogo.
	caja.visible = false

	# Indica que ya no hay un diálogo activo.
	dialogo_activo = false

	# Reanuda el juego después de terminar el diálogo.
	get_tree().paused = false

	# Emite la señal indicando que el diálogo terminó.
	dialogo_terminado.emit()
