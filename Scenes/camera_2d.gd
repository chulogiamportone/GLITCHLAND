extends Camera2D
class_name camera
@onready var character_body_2d = $"../CharacterBody2D"
@onready var character_body_2d_2= $"../CharacterBody2D2"
@onready var node_2d: Node2D = $".."

func _ready() -> void:
	position.x=420
	position.y=478
	
func _process(delta: float) -> void:
	
	if character_body_2d_2.visible :
		if (character_body_2d.position.x+character_body_2d_2.position.x)/2>420:
			if position.x < 1770:
				position.x=(character_body_2d.position.x+character_body_2d_2.position.x)/2
	else:
		if character_body_2d.position.x>420:
			if position.x < 1770:
				position.x=character_body_2d.position.x
	
	if position.x > 1770:
		position.x=1772
		node_2d.boss_init.emit()
	



	
