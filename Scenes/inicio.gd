extends Control
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var v_box_container_2: VBoxContainer = $VBoxContainer2
@onready var v_box_container_3: VBoxContainer = $VBoxContainer3
@onready var daltonism: ColorRect = $Daltonism

var scene_tree := Engine.get_main_loop() as SceneTree






func _on_button_pressed() -> void:
	v_box_container.visible=false
	v_box_container_2.visible=true
	v_box_container_3.visible=false

func _process(delta: float) -> void:
	daltonism.material.set_shader_parameter("daltonism_type",Global.tipo_colores)

func _on_button_3_pressed() -> void:
	scene_tree.quit()


func _on_1p_pressed() -> void:
	Global.cantidad_players=1
	scene_tree.change_scene_to_file("res://node_2d.tscn")
	


func _on_2p_pressed() -> void:
	Global.cantidad_players=2
	scene_tree.change_scene_to_file("res://node_2d.tscn")


func _on_3p_pressed() -> void:
	Global.cantidad_players=3
	scene_tree.change_scene_to_file("res://node_2d.tscn")


func _on_button_2_pressed() -> void:
	v_box_container.visible=false
	v_box_container_2.visible=false
	v_box_container_3.visible=true


func _on_comun_pressed() -> void:
	Global.tipo_colores=0
	volver()




func volver()->void:
	v_box_container.visible=true
	v_box_container_2.visible=false
	v_box_container_3.visible=false
	


func _on_t_1_pressed() -> void:
	Global.tipo_colores=1
	volver()

func _on_t_2_pressed() -> void:
	Global.tipo_colores=2
	volver()

func _on_t_3_pressed() -> void:
	Global.tipo_colores=3
	volver()
