extends AnimatedSprite2D

@onready var hammer_animation: AnimatedSprite2D = $"../Hammer1"

var trap_hurt:=false
var is_body_inside:=false
var body_inside

func _physics_process(delta: float) -> void:
	if frame==1 or frame==2 or frame==3 or frame==4:
		trap_hurt=true
	else:
		trap_hurt=false
	if trap_hurt and is_body_inside:
			body_inside.animated_sprite.play("Hurt")
			if body_inside.player==1:
				body_inside.position.x= $"../../CharacterBody2D2".position.x-20
				body_inside.position.y= 50
			else:
				body_inside.position.x= $"../../CharacterBody2D".position.x-20
				body_inside.position.y= 50

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name=="CharacterBody2D" or body.name=="CharacterBody2D2":
		is_body_inside=true
		body_inside=body
		

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	is_body_inside=false
