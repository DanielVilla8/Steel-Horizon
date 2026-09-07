extends Node2D



func _ready() -> void:
	MusicaManager.reproducir("zona1")
	DialogoSilvestre.mostrar_secuencia_unica("dialogo_zona1_intro", [
		"Oh, quién está ahí?",
		"Nunca pensé que volvería a ver a un humano de nuevo.",
		"¡ES DEMASIADO FRÍO AQUÍ!",
		"Disculpa mis modales, por la emoción olvidé presentarme.",
		"Hola, mi nombre es Silvestre, ¿entendiste? Es como Silver jajaja",
		"¿Tú también debes ser un periodista, verdad?",
		"Yo fui uno de los primeros en investigar a la compañía, y fui enviado a este lugar. En donde me convirtieron en esta cosa.",
		"Sin embargo se les olvidó que era el único conectado al experimento, así que prácticamente conservo toda mi cordura (Casi).",
		"Voy a ayudarte a escapar de aquí, sin embargo no será muy sencillo.",
		"Deberás atravesar a toda la custodia de robots sin ser detectado.",
		"Yo te ayudaré en lo que sea posible.",
		"Busca en TODAS las habitaciones las piezas del código para continuar a la siguiente zona.",
		
	])
