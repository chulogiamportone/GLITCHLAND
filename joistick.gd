# VirtualJoystick.gd
extends Control

@export var radius: float = 80.0   # radio de movimiento del knob en píxeles
@export var auto_hide_on_non_touch: bool = true

@onready var bg = $Background
@onready var knob = $Background/Knob

var pointer_index: int = -1
var stick_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Mostrar/ocultar según plataforma/táctil
	if auto_hide_on_non_touch:
		#var is_touch = OS.get_name() in ["Android", "iOS"]
		var is_touch = true
		visible = is_touch
		set_process(is_touch)

	

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventScreenTouch:
		var et = event as InputEventScreenTouch
		if et.pressed and pointer_index == -1:
			pointer_index = et.index
			_process_touch(et.position)
		elif (not et.pressed) and et.index == pointer_index:
			pointer_index = -1
			stick_dir = Vector2.ZERO
			knob.position = bg.size * 0.5

	elif event is InputEventScreenDrag:
		var ed = event as InputEventScreenDrag
		if ed.index == pointer_index:
			_process_touch(ed.position)

func _process_touch(global_pos: Vector2) -> void:
	# Convertir posición global a local del fondo
	var local = bg.to_local(global_pos)
	var center = bg.size * 0.5
	var offset = local - center
	if offset.length() > radius:
		offset = offset.normalized() * radius
	knob.position = center + offset
	stick_dir = (offset / radius).clamped(1.0)

func get_vector() -> Vector2:
	# Vector normalizado (-1..1) con dirección y fuerza
	return stick_dir
