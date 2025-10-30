extends Control

@export var radius: float = 80.0
@export var auto_hide_on_non_touch: bool = true
@export var deadzone: float = 0.12

# Zona de activación
enum ActMode { RECT, CIRCLE }
@export var activation_mode: ActMode = ActMode.RECT
# Rect local al Control del joystick (en px). Úsalo si activation_mode = RECT
@export var act_rect: Rect2 = Rect2(Vector2.ZERO, Vector2(300, 300))
# Círculo local al Control del joystick. Úsalo si activation_mode = CIRCLE
@export var act_center: Vector2 = Vector2(150, 150)
@export var act_radius: float = 160.0

# Si la zona de activación la quieres relativa al Background en vez del Joystick root
@export var act_on_bg: bool = false

@onready var bg: Control = $Background
@onready var knob: Control = $Background/Knob

var pointer_idx: int = -1
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	#if auto_hide_on_non_touch:
		#visible = DisplayServer.is_touchscreen_available()
	knob.position = bg.size * 0.5-(knob.size/2)
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventScreenTouch:
		var et: InputEventScreenTouch = event
		if et.pressed:
			# Solo captura si no hay pointer y el toque inicia dentro de la zona
			if pointer_idx == -1 and _screen_pos_inside_activation(et.position):
				pointer_idx = et.index
				_update_from_screen_pos(et.position)
		else:
			# Liberar si suelta el pointer que poseemos
			if et.index == pointer_idx:
				pointer_idx = -1
				dir = Vector2.ZERO
				knob.position = bg.size * 0.5-(knob.size/2)

	elif event is InputEventScreenDrag:
		var ed: InputEventScreenDrag = event
		if ed.index == pointer_idx:
			_update_from_screen_pos(ed.position)

func _screen_pos_inside_activation(screen_pos: Vector2) -> bool:
	# Convierte la pos de pantalla a local según quieras evaluar la zona en root o en bg
	if act_on_bg:
		var inv_bg: Transform2D = bg.get_global_transform_with_canvas().affine_inverse()
		var local_bg: Vector2 = inv_bg * screen_pos
		if activation_mode == ActMode.RECT:
			return act_rect.has_point(local_bg)
		else:
			return local_bg.distance_to(act_center) <= act_radius
	else:
		var inv_root: Transform2D = get_global_transform_with_canvas().affine_inverse()
		var local_root: Vector2 = inv_root * screen_pos
		if activation_mode == ActMode.RECT:
			return act_rect.has_point(local_root)
		else:
			return local_root.distance_to(act_center) <= act_radius

func _update_from_screen_pos(screen_pos: Vector2) -> void:
	# Transformar pantalla -> local del Background
	var inv: Transform2D = bg.get_global_transform_with_canvas().affine_inverse()
	var local: Vector2 = inv * screen_pos

	var center: Vector2 = bg.size * 0.5
	var offset: Vector2 = local - center

	if offset.length() > radius:
		offset = offset.normalized() * radius

	knob.position = center + offset

	var v: Vector2 = offset / max(radius, 0.001)
	if v.length() < deadzone:
		v = Vector2.ZERO
	else:
		var l: float = clamp((v.length() - deadzone) / (1.0 - deadzone), 0.0, 1.0)
		v = v.normalized() * l

	dir = v

func get_vector() -> Vector2:
	return dir
