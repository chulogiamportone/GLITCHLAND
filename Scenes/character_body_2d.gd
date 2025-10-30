extends CharacterBody2D

@export var player: int = 0
@export var speed: float = 220.0
@export var gravity: float = 1200.0
@export var jump_force: float = -450.0

# Umbrales para interpretar Y del joystick
@export var jump_thresh: float = -0.5   # arriba para saltar
@export var attack_thresh: float = 0.5   # abajo para atacar
@export var axis_dead: float = 0.06      # pequeño deadzone para ruido

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var empuje: CollisionShape2D = $Area2D/Empuje

# Ajusta estas rutas a tu escena real
@onready var joystick: Control
@onready var joistick_1: Control = $"../Camera2D/Joistick1"
@onready var joistick_2: Control = $"../Camera2D/Joistick2"

var is_attacking: bool = false
var is_action: bool = false

# InputMap de fallback/PC
var input_right := ""
var input_left := ""
var input_jump := ""
var input_attack := ""

var life:int=0;
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

func play_sound(path: String):
	sfx.stream = load(path)
	sfx.play()

func _ready() -> void:
	# Asignar joystick por jugador
	if player == 1:
		joystick = joistick_1
	elif player == 2:
		joystick = joistick_2

	# Mapas de entrada por jugador (fallback teclado/mandos)
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

func _physics_process(delta: float) -> void:
	
	is_action = false

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = max(velocity.y, 0.0)

	# Movimiento horizontal
	var move_x := _get_move_x()
	velocity.x = move_x * speed

	# Flip y caminar
	if move_x > 0.05:
		animated_sprite.flip_h = false
		empuje.disabled = true
		empuje.position.x = abs(empuje.position.x)
		_play_animation("Walk")
		is_action = true
	elif move_x < -0.05:
		animated_sprite.flip_h = true
		empuje.disabled = true
		empuje.position.x = -abs(empuje.position.x)
		_play_animation("Walk")
		is_action = true

	# Salto (stick arriba o InputMap)
	if _wants_jump():
		if is_on_floor():
			velocity.y = jump_force
			empuje.disabled = true
			_play_animation("Jump1")
			is_action = true

	# Ataque (stick abajo o InputMap)
	if not is_attacking and _wants_attack():
		empuje.disabled = false
		_play_animation("Attack")
		is_attacking = true
		is_action = true

	# Idle si no hay acción y está en piso
	if not is_action and not is_attacking and is_on_floor() and abs(move_x) <= 0.05 and velocity.y == 0.0:
		_play_animation("Idle")
		empuje.disabled = true
		
	
	

	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		# Si choca contra un RigidBody2D, aplicar fuerza
		if body is RigidBody2D:
			var push_dir = (body.global_position - global_position).normalized()
			body.apply_impulse(push_dir * 150)

func _get_move_x() -> float:
	# Prioriza joystick si visible y con método
	if joystick and joystick.visible and joystick.has_method("get_vector"):
		var v: Vector2 = joystick.get_vector()
		if absf(v.x) > axis_dead:
			return clamp(v.x, -1.0, 1.0)
	# Fallback a teclado/mandos
	var x := Input.get_action_strength(input_right) - Input.get_action_strength(input_left)
	return clamp(x, -1.0, 1.0)

func _get_axis_y() -> float:
	if joystick and joystick.visible and joystick.has_method("get_vector"):
		var v: Vector2 = joystick.get_vector()
		if absf(v.y) > axis_dead:
			return clamp(v.y, -1.0, 1.0)
	# Fallback a teclado/mandos (si quieres permitir W/S o up/down)
	var y := Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return clamp(y, -1.0, 1.0)

func _wants_jump() -> bool:
	# Joystick: arriba
	var y := _get_axis_y()
	if y < jump_thresh:
		return true
	# Fallback InputMap
	return Input.is_action_just_pressed(input_jump)

func _wants_attack() -> bool:
	# Joystick: abajo
	var y := _get_axis_y()
	if y > attack_thresh:
		return true
	# Fallback InputMap
	return Input.is_action_just_pressed(input_attack)

func _play_animation(name_animated: String) -> void:
	if is_attacking and name_animated != "Attack":
		return
	if animated_sprite.animation != name_animated:
		animated_sprite.play(name_animated)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Cuerpo":
		if not empuje.disabled:
			var p = area.get_parent()
			if p and p.has_node("AnimatedSprite2D"):
				p.animated_sprite.play("Hurt")
			p.global_position.x -= 50

func _on_animated_sprite_2d_animation_finished(body: Node2D) -> void:
	if animated_sprite.animation == "Attack":
		is_attacking = false
		empuje.disabled = true
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="CharacterBody2D" or body.name=="CharacterBody2D2":
		play_sound("res://Audio/822690__riippumattog__i-love-you-puppet-style.wav")
		body.life+=1
		body.position.x= 950
		body.position.y= 418
		
