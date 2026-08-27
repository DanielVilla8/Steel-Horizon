extends Area2D
#Pertenece a un nodo2D

@export var letra = "R"
#Letra asignada

var jugador_cerca = false
#Indica si el jugador esta cerca de la letra

func _on_body_entered(body):
#La funcion se ejecuta cuando el jugador entra al area
 if body.is_in_group("player"):
#Comprueba que el cuerpo que entra sea el jugador
  jugador_cerca = true
#Si es el jugador, se cambia la variable a true

func _on_body_exited(body):
#La funcion se ejecuta cuando el jugado sale del area
 if body.is_in_group("player"):
#Comprueba que el cuerpo que sale es el jugador
  jugador_cerca = false
#Al alejarse no podra recoger la letra

func _process(delta):
#Ejecuta cada fotograma del juego
 if jugador_cerca and Input.is_action_just_pressed("interactuar"):
#Comprueba que el jugador este cerca de la letra y
#que haiga presionado la tecla asignada (E).
  print("Recogio:", letra)
#Muestra a la consola que la tecla fue recogida
  queue_free()
#Elimina la letra de la escena
