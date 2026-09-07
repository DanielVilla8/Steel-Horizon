extends Area2D
#Pertenece a un nodo2D

# Letra asignada
@export var letra = "J"
@export var id_unico: String = ""
# Indica si el jugador esta cerca de la letra
var jugador_cerca = false

func _ready() -> void:
	# Si al cargar la partida este ID ya fue recogido, desaparece del mapa automáticamente
	if id_unico != "" and id_unico in Guardado.objetos_recolectados:
		queue_free()
		
		call_deferred("_comprobar_si_ya_fue_recogido")
		
func _comprobar_si_ya_fue_recogido() -> void:
	if id_unico in Guardado.objetos_recolectados:
		queue_free()
		
func _on_body_entered(body):
	# Comprueba que el cuerpo que entra sea el jugador
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body):
	# Comprueba que el cuerpo que sale es el jugador
	if body.is_in_group("player"):
		jugador_cerca = false

func _process(delta):
	# Comprueba que el jugador este cerca de la letra y
	# que haya presionado la tecla asignada (E)
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		_recolectar_letra()
		
func _recolectar_letra() -> void:
	# 1. Registrar que este ID ya fue recogido en los datos de guardado
	if not (id_unico in Guardado.objetos_recolectados):
		Guardado.objetos_recolectados.append(id_unico)
	
	# 2. Agregar la letra al inventario
	Inventario.agregar_letra(letra)
	
		# Cuando se junta la última letra (las 5 en total: A, D, J, O, R),
		# Silvestre comenta sobre la contraseña
	if Inventario.letras.size() == 5:
		DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona1_letras", [
			"Con el tiempo la contraseña ha sido cambiada, así que algunas letras no serán necesarias."
			])
			
	queue_free()
