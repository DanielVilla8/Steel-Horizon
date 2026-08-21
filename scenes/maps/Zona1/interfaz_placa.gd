extends CanvasLayer

#Guarda las letras que el jugador coloca
var palabra = []

# Se obtiene el nodo donde aparecerán las letras
@onready var contenedor_letras = $Panel/Letras
#Referencias de los tres espacios de la placa 
@onready var espacio1 = $Panel/HBoxContainer/Label
@onready var espacio2 = $Panel/HBoxContainer/Label2
@onready var espacio3 = $Panel/HBoxContainer/Label3
#Referencia de la tarjeta
@onready var tarjeta = $"../Tarjeta"

func _ready():
	actualizar_letras()

func actualizar_letras():
	print("Entro actualizar_letras")
	# Elimina las letras viejas para no duplicarlas
	for hijo in contenedor_letras.get_children():
		hijo.queue_free()
	# Recorre todas las letras guardadas en el inventario
	for letra in Inventario.letras:
		print("Creando boton:", letra)
		# Crea un botón nuevo
		var boton = Button.new()
		# El texto del botón será la letra
		boton.text = letra
		
		#Cuando se haga clic en el boton manda a la letra
		boton.pressed.connect(func():
			colocar_letra(letra)
		)
		#Agrega al boton al GridContainer
		contenedor_letras.add_child(boton)
		
func colocar_letra(letra):
#Solo permite colocar 3 letras
	if palabra.size() >= 3:
		return
	#Guarda la letra
	palabra.append(letra)
	#Actualiza los 3 espacios de la placa
	if palabra.size() == 1:
		espacio1.text = letra
	if palabra.size() == 2:
		espacio2.text = letra
	if palabra.size() == 3:
		espacio3.text = letra

func abrir():
	visible = true
	print("Placa abierta")
	print("Invetario:", Inventario.letras)
	actualizar_letras()

func _on_Button_pressed():
	var resultado = "".join(palabra)
	if resultado == "DJA":
		print("Correcto")
	else:
		print("Incorrecto")
		#Vaciar la palabra
		palabra.clear()
		#Limpiar los espacios
		espacio1.text = "_"
		espacio2.text = "_"
		espacio3.text = "_"
		
func _on_Button_2_pressed():
	#Vaciar palabra
	palabra.clear()
	#Limpiar los espacis
	espacio1.text = "_"
	espacio2.text = "_"
	espacio3.text = "_"
	
	visible = false


func _on_button_pressed() -> void:
	var resultado = "".join(palabra)
	if resultado == "DJA":
		print("¡Correcto!")
		#Cierra la interfaz
		visible = false
		#Aparece la tarjeta
		print("Mostrando tarjeta")
		if is_instance_valid(tarjeta):
			tarjeta.show()
			print("Visible:", tarjeta.visible)
		else:
			print("Error: El nodo de la tajeta fue destruido anteriormente.")
			palabra.clear()
	else:
		print("¡Incorrecto!")
		#Vacia lista
		palabra.clear()
		#Limpia los espacios
		espacio1.text = "_"
		espacio2.text = "_"
		espacio3.text = "_"
