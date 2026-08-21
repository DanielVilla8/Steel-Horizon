extends StaticBody2D

#Referencia de la interfaz
@onready var interfaz = $"../Interfaz_placa"

#Indica si el jugador esta cerca de la placa
var jugador_cerca = false

#Se ejecuta cuando el jugador entra al Area2D
func _on_body_entered(body):
#Comprueba si quien entro pertenece al grupo player
 if body.is_in_group("player"):
  jugador_cerca = true

#Se ejecuta cuando el jugador sale del Area2D
func _on_body_exited(body):
#Si salio ya no podra interactuar con la placa
 if body.is_in_group("player"):
  jugador_cerca = false

#Se ejecuta cada frame
func _process(delta):
#Si el jugador esta cerca presiona la tecla interactuar
 if jugador_cerca and Input.is_action_just_pressed("interactuar"):
  interfaz.abrir()
  print("Placa activada")
#Muestra las letras recogidas por el jugador
  print("Letras disponibles:", Inventario.letras)

func _on_area_2d_body_entered(body: Node2D) -> void:
 if body.is_in_group("player"):
  jugador_cerca = true

func _on_area_2d_body_exited(body: Node2D) -> void:
 if body.is_in_group("player"):
  jugador_cerca = false
