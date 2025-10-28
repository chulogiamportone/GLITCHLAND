extends CharacterBody2D
class_name Player

var motion := Vector2.ZERO
var gravity := 15
var jump_strength := -450
var is_attacking := false

@export var player := 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var empuje: CollisionShape2D = $Area2D/Empuje


# Player.gd (fragmento)
@onready var joystick: Node = $"../Control"  # ruta a tu joystick
# Define controles por jugador
var input_right := ""
var input_left := ""
var input_jump := ""
var input_attack := ""

func _ready():
	if player == 1:
		input_right = "ui_right"
		input_left = "ui_left"
		input_jump = "ui_accept"
		input_attack = "i_attack"
	elif player == 2:
		input_right = "j_right"
		input_left = "j_left"
		input_jump = "j_jump"
		input_attack = "j_attack"



func joistick_mov():
	var move_vec = Vector2.ZERO

	if joystick and joystick.visible:
		move_vec = joystick.get_vector()
	else:
		# Entrada por teclado/ratón (ejemplo con acciones ui_* configuradas en InputMap)
		var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		move_vec = Vector2(x, y)
		if move_vec.length() > 0:
			move_vec = move_vec.normalized()

	# aplicar movimiento al cuerpo, e.g. velocity = move_vec * speed
	

func _physics_process(delta):
	motion.y += gravity
	var is_action := false
	
	# Movimiento derecha
	if Input.is_action_pressed(input_right):

		motion.x = 100

		animated_sprite.flip_h = false
		empuje.disabled = true
		empuje.position.x = abs(empuje.position.x)
		_play_animation("Walk")
		is_action = true

	# Movimiento izquierda
	elif Input.is_action_pressed(input_left):

		motion.x = -100

		animated_sprite.flip_h = true
		empuje.disabled = true
		empuje.position.x = -abs(empuje.position.x)
		_play_animation("Walk")
		is_action = true

	else:
		motion.x = 0

	# Salto
	if Input.is_action_just_pressed(input_jump) and is_on_floor():
		motion.y = jump_strength
		empuje.disabled = true
		_play_animation("Jump1")
		is_action = true

	# Ataque
	if not is_attacking and Input.is_action_just_pressed(input_attack):
		empuje.disabled = false
		_play_animation("Attack")
		is_attacking = true
	

	# Si no se realizó ninguna acción, pasamos a Idle
	if not is_action and not is_attacking:
		_play_animation("Idle")
		empuje.disabled = true
	joistick_mov()

	velocity = motion
	move_and_slide()
	

		
func _play_animation(name: String):
	# Si estoy atacando, solo permito seguir con "Attack"
	if is_attacking and name != "Attack":
		return

	if animated_sprite.animation != name:
		animated_sprite.play(name)





func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name=="Cuerpo" :
		if !empuje.disabled:
			area.get_parent().animated_sprite.play("Hurt")
			area.get_parent().global_position.x=area.get_parent().global_position.x-50

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "Attack":
		is_attacking = false


func _on_animated_sprite_2d_animation_finished_2() -> void:
	if animated_sprite.animation == "Attack":
		is_attacking = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="CharacterBody2D" or body.name=="CharacterBody2D2":
		if body.player==1:
			body.position.x= $"../CharacterBody2D2".position.x-50
			body.position.y= $"../CharacterBody2D2".position.y-20
		else:
			body.position.x= $"../CharacterBody2D".position.x-50
			body.position.y= $"../CharacterBody2D2".position.y-20
