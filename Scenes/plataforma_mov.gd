extends CharacterBody2D

@export var velocidad: float = 50.0
@export var punto_a: Vector2
@export var punto_b: Vector2

var direccion: Vector2 = Vector2.ZERO
var destino_actual: Vector2

func _ready():
	global_position = punto_a
	destino_actual = punto_b

func _physics_process(delta):
	direccion = (destino_actual - position).normalized()
	velocity = direccion * velocidad
	move_and_slide()

	# Cuando se acerca al destino, lo cambia
	if position.distance_to(destino_actual) < 2.0:
		destino_actual = punto_a if destino_actual == punto_b else punto_b
