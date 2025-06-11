extends CharacterBody2D
class_name Player

var motion = Vector2(0, 0)
var motion2 = Vector2(0, 0)
var gravity=10
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@export var player=0


func _physics_process(delta):
	if !animation_player.is_playing():
		animation_player.play("idle")
	motion.y += gravity
	motion2.y += gravity
	if player==1:
		if Input.is_anything_pressed():
			if Input.is_action_pressed("ui_right"):
				motion.x = 500
				animation_player.play("walk")
			if Input.is_action_pressed("ui_left"):
				motion.x = -500
				animation_player.play("walk_left")
			if Input.is_action_pressed("ui_accept"):
				if is_on_floor():
					motion.y = -400
		else:
			motion.x=0
			animation_player.play("idle")
		velocity=motion
		move_and_collide(velocity*delta)
		move_and_slide()

	if player==2:
		if Input.is_anything_pressed():
			if Input.is_action_pressed("j_right"):
				motion2.x = 500
			if Input.is_action_pressed("j_left"):
				motion2.x = -500
			if Input.is_action_pressed("j_jump"):
				if is_on_floor():
					motion2.y = -400
		else:
			motion2.x=0
			animation_player.play("idle")
		velocity=motion2
		move_and_collide(velocity*delta)
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.player==1:
		body.position.x= $"../CharacterBody2D2".position.x-50
		body.position.y= $"../CharacterBody2D2".position.y-500
	else:
		body.position.x= $"../CharacterBody2D".position.x-50
		body.position.y= $"../CharacterBody2D".position.y-500
