extends CanvasLayer

# Guarda las letras que el jugador coloca
var palabra = []
# Indica si ya se mostró el diálogo de apertura del panel (para que no se repita cada vez)
var ya_hablo_apertura = false
# Cuenta los intentos fallidos para saber qué diálogo mostrar en cada error
var intentos_fallidos = 0

# Se obtiene el nodo donde aparecerán las letras
@onready var contenedor_letras = $Panel/Letras
# Referencias de los tres espacios de la placa
@onready var espacio1 = $Panel/HBoxContainer/Label
@onready var espacio2 = $Panel/HBoxContainer/Label2
@onready var espacio3 = $Panel/HBoxContainer/Label3
# Referencia de la tarjeta
@onready var tarjeta = $"../Tarjeta"

func _ready():
	actualizar_letras()

func actualizar_letras():
	# Elimina las letras viejas para no duplicarlas
	for hijo in contenedor_letras.get_children():
		hijo.queue_free()
	# Recorre todas las letras guardadas en el inventario
	for letra in Inventario.letras:
		# Crea un botón nuevo
		var boton = Button.new()
		# El texto del botón será la letra
		boton.text = letra
		# Cuando se haga clic en el botón manda la letra
		boton.pressed.connect(func():
			colocar_letra(letra)
		)
		# Agrega el botón al contenedor
		contenedor_letras.add_child(boton)

func colocar_letra(letra):
	# Solo permite colocar 3 letras
	if palabra.size() >= 3:
		return
	# Guarda la letra
	palabra.append(letra)
	# Actualiza los 3 espacios de la placa
	if palabra.size() == 1:
		espacio1.text = letra
	if palabra.size() == 2:
		espacio2.text = letra
	if palabra.size() == 3:
		espacio3.text = letra

func abrir():
	visible = true
	actualizar_letras()
	# Solo la primera vez que se abre el panel, Silvestre comenta y sugiere el primer intento
	if not ya_hablo_apertura:
		ya_hablo_apertura = true
		DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona1_apertura", [
			"Tómate el tiempo que necesites, si no quieres compartir cuerpo conmigo.",
			"No tengo ni la menor idea de cuál es el código, así que dejémoslo a la suerte.",
			"Prueba con DRO"
		])

func _on_button_2_pressed():
	# Vaciar palabra
	palabra.clear()
	visible = false

func _on_button_pressed() -> void:
	var resultado = "".join(palabra)
	if resultado == "DJA":
		# Cierra la interfaz
		visible = false
		# Aparece la tarjeta
		if is_instance_valid(tarjeta):
			tarjeta.show()
		# Silvestre celebra el acierto y da la siguiente instrucción
		DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona1_acierto", [
			"¡Qué buen trabajo hice!",
			"Ahora toma la tarjeta y dirígete a la puerta (Recoge con E y abre la puerta con E)"
		])
	else:
		# Vacía lista
		palabra.clear()
		# Limpia los espacios
		espacio1.text = "_"
		espacio2.text = "_"
		espacio3.text = "_"

		# Cuenta el intento fallido para mostrar el diálogo correspondiente
		intentos_fallidos += 1
		if intentos_fallidos == 1:
			# Primer intento fallido: Silvestre sugirió "DRO" y falló, ahora sugiere "JAR"
			DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona1_fallo1", [
				"UPSI, creo que ese no era.",
				"Prueba con JAR"
			])
		elif intentos_fallidos == 2:
			# Segundo intento fallido: Silvestre se disculpa y deja que el jugador siga solo
			DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona1_fallo2", [
				"Perdón, mala mía jeje.",
				"Pe-perdón, vo-vo-voy a de-DJA... rte hacerlo por tu cuenta desde ahora."
			])
		# A partir del tercer intento fallido, Silvestre ya no vuelve a hablar
