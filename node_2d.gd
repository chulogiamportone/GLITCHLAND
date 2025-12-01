extends Node2D
@onready var character_body_2d_2 = $CharacterBody2D2
@onready var joistick_2: Control = $Camera2D/Joistick2
@onready var door: StaticBody2D = $Door
@onready var panel_2: Panel = $Camera2D/Panel2

signal boss_init

@onready var label_p_1: Label = $Camera2D/Panel/LabelP1
@onready var label_p_2: Label = $Camera2D/Panel2/LabelP2

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D

@onready var hammer_11: AnimatedSprite2D = $NavigationObstacle2D/Hammer11
@onready var hammer_12: AnimatedSprite2D = $NavigationObstacle2D/Hammer12
@onready var hammer_13: AnimatedSprite2D = $NavigationObstacle2D/Hammer13
@onready var hammer_14: AnimatedSprite2D = $NavigationObstacle2D/Hammer14
@onready var hammer_15: AnimatedSprite2D = $NavigationObstacle2D/Hammer15

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var animation_camera: AnimationPlayer = $Camera2D/AnimationPlayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var scene_tree := Engine.get_main_loop() as SceneTree
@onready var timer: Timer = $Timer
var creditos=0
var counter=0
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var daltonism: ColorRect = $Daltonism
@onready var mando: Label = $Camera2D/Mando
@onready var timer_2: Timer = $Timer2

var cartel_1:bool=false
var cartel_2:bool=false
var cartel_3:bool=false
@onready var label_cartel: Label = $Camera2D/Cartel/LabelCartel



func play_sound(path: String):
	sfx.stream = load(path)
	sfx.play()


func _ready() -> void:
	daltonism.material.set_shader_parameter("daltonism_type",Global.tipo_colores)
	boss_init.connect(close_boss)
	if Global.cantidad_players==2:
		character_body_2d_2.visible=true
		if DisplayServer.is_touchscreen_available():
			joistick_2.visible=true
	else:
		if joistick_2:
			joistick_2.visible=false
		if character_body_2d_2:
			character_body_2d_2.visible=false
			character_body_2d_2.position.x=-840
		if panel_2:
			panel_2.visible=false

	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	# Opcional: verificar mandos conectados al inicio
	print("Mandos conectados al inicio:")
	for device in Input.get_connected_joypads():
		print("  - Dispositivo ", device, ": ", Input.get_joy_name(device))

func _on_joy_connection_changed(device: int, connected: bool):
	if connected:
		print("Mando conectado - ID: ", device)
		print("Nombre: ", Input.get_joy_name(device))
		mando.visible=true
		mando.text=str("Mando conectado: ", Input.get_joy_name(device))
		timer_2.start()
		# Aquí puedes mostrar un mensaje en pantalla, actualizar UI, etc.
	else:
		print("Mando desconectado - ID: ", device)
		mando.text=str("Mando desconectado: ", Input.get_joy_name(device))
		mando.visible=true
		timer_2.start()
		# Aquí puedes pausar el juego, mostrar advertencia, etc.





func close_boss()->void:
	door.position.x=1385.0
	door.position.y=491.0
	
func _process(delta: float) -> void:
	label_p_1.text=str(character_body_2d.life)
	if label_p_2:
		label_p_2.text=str(character_body_2d_2.life)
		
		

		
		
		


func _on_timer_timeout() -> void:
	counter+=1
	if counter%4==0:
		hammer_11.play("Hammer_1")
	if counter%5==0:
		hammer_12.play("Hammer_1")
	if counter%6==0:
		hammer_13.play("Hammer_1")
	if counter%5==0:
		hammer_14.play("Hammer_1")
	if counter%7==0:
		hammer_15.play("Hammer_1")
	timer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	play_sound("res://Audio/822690__riippumattog__i-love-you-puppet-style.wav")
	if body.name=="CharacterBody2D" or body.name=="CharacterBody2D2":
		creditos+=1
		print("pasa"+body.name)
		print(character_body_2d_2.visible)
		print(creditos)
		if character_body_2d_2.visible:
			if creditos==2:
				print(creditos)
				animation_player.play("creditos")
				animation_player_2.play("new_animation")
		else:
			if creditos==1:
				print(creditos)
				animation_player.play("creditos")
				animation_player_2.play("new_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	scene_tree.change_scene_to_file("res://Scenes/inicio.tscn")
	


func _on_timer_2_timeout() -> void:
	mando.visible=false


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if !cartel_1:
		animation_camera.play("Cartel")
		cartel_1=true
		


func _on_hammer_body_entered(body: Node2D) -> void:
	if !cartel_2:
		label_cartel.text="Ten cuidado con los martillos"
		animation_camera.play("Cartel")
		cartel_2=true


func _on_cartel_collision_2_body_entered(body: Node2D) -> void:
	if !cartel_3 and body.get_class()=="CharacterBody2D":
		label_cartel.text="Empuja la caja"
		animation_camera.play("Cartel")
		cartel_3=true
