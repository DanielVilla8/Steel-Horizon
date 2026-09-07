extends Control


@onready var texto = $PanelTexto/TextoFinal

var contenido_final = "El periodista logró salir con la evidencia que recolectó durante toda su aventura. Después de eso, la llevó a los medios de comunicación y los fundadores de la empresa Horizon fueron arrestados.

Finalmente, el periodista se pudo reencontrar con su amigo Silvestre, y ahora ambos trabajan juntos en su propia editorial."

func _ready() -> void:
	MusicaManager.reproducir("final")
	texto.text = contenido_final
