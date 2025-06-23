extends Control
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var v_box_container_2: VBoxContainer = $VBoxContainer2

var scene_tree := Engine.get_main_loop() as SceneTree

func _on_button_pressed() -> void:
	v_box_container.visible=false
	v_box_container_2.visible=true
	

func _on_button_pressed2() -> void:
	scene_tree.change_scene_to_file("res://node_2d.tscn")


func _on_button_3_pressed() -> void:
	scene_tree.quit()
