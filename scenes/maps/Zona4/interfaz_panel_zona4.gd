extends CanvasLayer

# Guarda los números que el jugador va introduciendo.
var codigo = []

# Referencia al contenedor donde se crearán los botones numéricos.
@onready var contenedor_numeros = $Panel/Letras
# Referencias a los tres espacios donde se muestran
# los números introducidos por el jugador.
@onready var espacio1 = $Panel/HBoxContainer/Label
@onready var espacio2 = $Panel/HBoxContainer/Label2
@onready var espacio3 = $Panel/HBoxContainer/Label3
# Referencia al objeto bomba que se encuentra en la escena.
@onready var bomba = $"../../Bomba"
# Referencia a la tarjeta utilizada en esta zona.
@onready var tarjeta = $"../../Tarjeta"

func _ready():
	# Muestra un mensaje en la consola para comprobar
	# que la interfaz se ha cargado correctamente.
	print("Interfaz_pane _ready ejecutado")
	# Crea los botones numéricos de la interfaz.
	crear_botones()

# Crea automáticamente los botones del 1 al 9.
func crear_botones():
	# Elimina los botones que ya existan dentro del contenedor.
	for hijo in contenedor_numeros.get_children():
		hijo.queue_free()
	# Recorre los números del 1 al 9.
	for i in range(1, 10):
		# Crea un nuevo botón.
		var boton = Button.new()
		# Coloca el número correspondiente como texto del botón.
		boton.text = str(i)
		# Cuando se presiona el botón,
		# llama a la función colocar_numero() enviando el número.
		boton.pressed.connect(func():
			colocar_numero(i)
		)
		# Agrega el botón creado al contenedor de números.
		contenedor_numeros.add_child(boton)

# Agrega un número al código que está introduciendo el jugador.
func colocar_numero(numero):
	# Impide introducir más de tres números.
	if codigo.size() >= 3:
		return
	# Agrega el número seleccionado al arreglo del código.
	codigo.append(numero)
	# Si es el primer número, lo muestra en el primer espacio.
	if codigo.size() == 1:
		espacio1.text = str(numero)
	# Si es el segundo número, lo muestra en el segundo espacio.
	if codigo.size() == 2:
		espacio2.text = str(numero)
	# Si es el tercer número, lo muestra en el tercer espacio.
	if codigo.size() == 3:
		espacio3.text = str(numero)

# Muestra la interfaz del código en pantalla.
func abrir():
	visible = true

# Limpia el código introducido y restablece los espacios.
func limpiar():
	# Vacía el arreglo que contiene los números.
	codigo.clear()
	# Restablece los tres espacios a su estado inicial.
	espacio1.text = "_"
	espacio2.text = "_"
	espacio3.text = "_"

# Se ejecuta cuando el jugador presiona el botón para comprobar el código.
func _on_button_pressed() -> void:
	# Comprueba si el código introducido es exactamente 7, 8 y 5.
	if codigo == [7, 8, 5]:
		# Muestra en la consola que el código es correcto.
		print("Correcto")
		# Oculta la interfaz.
		visible = false

		# Comprueba que la bomba todavía exista
		# antes de intentar utilizarla.
		if is_instance_valid(bomba):
			# Desactiva la bomba.
			bomba.desactivar()

		# Accede a la escena de Zona4 y revela las piezas.
		get_node("/root/zona4").revelar_piezas()

		# Solo si el código fue correcto, comprueba que exista
		# la llave en la escena y la revela para que se pueda encontrar.
		if has_node("/root/zona4/llave"):
			get_node("/root/zona4/llave").revelar()

		# Silvestre indica al jugador cuál es el siguiente objetivo.
		# Al estar dentro del "if" del código correcto, este mensaje
		# solo aparece cuando el jugador realmente acertó.
		DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona4_acierto", [
			"Bien, ahora solo queda encontrar las últimas llaves para escapar de acá, ten cuidado."
		])
	else:
		# Informa en la consola que el código introducido es incorrecto.
		print("¡Incorrecto!")
		# Limpia el código para que el jugador pueda intentarlo nuevamente.
		limpiar()

# Se ejecuta cuando el jugador presiona el botón de cancelar.
func _on_button_2_pressed() -> void:
	# Borra los números introducidos.
	limpiar()
	# Oculta la interfaz.
	visible = false
