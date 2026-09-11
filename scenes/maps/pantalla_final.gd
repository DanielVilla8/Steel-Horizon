extends Control


@onready var texto = $PanelTexto/TextoFinal
@onready var aviso = $AvisoContinuar

var contenido_final = "El periodista logró salir con la evidencia que recolectó durante toda su aventura. Después de eso, la llevó a los medios de comunicación y los fundadores de la empresa Horizon fueron arrestados.

Finalmente, el periodista se pudo reencontrar con su amigo Silvestre, y ahora ambos trabajan juntos en su propia editorial."

func _ready() -> void:
	MusicaManager.reproducir("final")
	texto.text = contenido_final

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("continuar"):
		get_tree().change_scene_to_file("res://scenes/credits_screen.tscn")

func _on_timer_timeout() -> void:
	aviso.visible = !aviso.visible
