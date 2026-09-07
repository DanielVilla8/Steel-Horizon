extends Node2D

# Referencia al panel de interfaz que se encuentra dentro de este nodo.
@onready var interfaz = $Interfaz_panel

# Indica si el jugador se encuentra cerca del panel.
var jugador_cerca = false


func _ready():
	# Oculta el panel al comenzar el juego.
	interfaz.visible = false


# Se ejecuta cuando un cuerpo entra en el área de detección.
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Comprueba si el cuerpo que entró es el personaje principal.
	if body.name == "personaje principal":

		# Indica que el jugador está cerca del panel.
		jugador_cerca = true

		# Muestra en la consola un mensaje indicando
		# que se puede presionar E para abrir el panel.
		print("Presiona E para abrir el panel")


# Se ejecuta cuando un cuerpo sale del área de detección.
func _on_area_2d_body_exited(body: Node2D) -> void:
	# Comprueba si el cuerpo que salió es el personaje principal.
	if body.name == "personaje principal":

		# Indica que el jugador ya no está cerca del panel.
		jugador_cerca = false

		# Oculta automáticamente el panel cuando el jugador se aleja.
		interfaz.visible = false


# Se ejecuta constantemente mientras el juego está funcionando.
func _process(delta: float) -> void:
	# Comprueba si el jugador está cerca y presionó el botón de interactuar.
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):

		# Cambia el estado de visibilidad del panel.
		# Si está oculto, lo muestra.
		# Si está visible, lo oculta.
		interfaz.visible = not interfaz.visible
