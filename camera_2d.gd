extends Camera2D
class_name camera
@onready var character_body_2d: Player = $"../CharacterBody2D"
@onready var character_body_2d_2: Player = $"../CharacterBody2D2"

func _process(delta: float) -> void:
	if character_body_2d_2.visible:
		position.x=(character_body_2d.position.x+character_body_2d_2.position.x)/2
	else:
		position.x=character_body_2d.position.x
