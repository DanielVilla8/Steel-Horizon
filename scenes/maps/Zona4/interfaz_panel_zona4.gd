extends CanvasLayer


var codigo = []
@onready var contenedor_numeros = $Panel/Letras
@onready var espacio1 = $Panel/HBoxContainer/Label
@onready var espacio2 = $Panel/HBoxContainer/Label2
@onready var espacio3 = $Panel/HBoxContainer/Label3
@onready var bomba = $"../../Bomba"
@onready var tarjeta = $"../../Tarjeta"

func _ready():
	print("Interfaz_pane _ready ejecutado")
	crear_botones()

func crear_botones():
	for hijo in contenedor_numeros.get_children():
		hijo.queue_free()
	for i in range(1, 10):
		var boton = Button.new()
		boton.text = str(i)
		boton.pressed.connect(func():
			colocar_numero(i)
		)
		contenedor_numeros.add_child(boton)

func colocar_numero(numero):
	if codigo.size() >= 3:
		return
	codigo.append(numero)
	if codigo.size() == 1:
		espacio1.text = str(numero)
	if codigo.size() == 2:
		espacio2.text = str(numero)
	if codigo.size() == 3:
		espacio3.text = str(numero)

func abrir():
	visible = true

func limpiar():
	codigo.clear()
	espacio1.text = "_"
	espacio2.text = "_"
	espacio3.text = "_"

func _on_button_pressed() -> void:
	if codigo == [7, 8, 5]:
		print("Correcto")
		visible = false
		if is_instance_valid(bomba):
			bomba.desactivar()
		get_node("/root/zona4").revelar_piezas() 
		get_node("/root/zona4/llave").revelar()
	else:
		print("¡Incorrecto!")
		limpiar()

func _on_button_2_pressed() -> void:
	limpiar()
	visible = false
