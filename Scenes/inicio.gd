extends Control
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var v_box_container_2: VBoxContainer = $VBoxContainer2


func _on_button_pressed() -> void:
	v_box_container.visible=false
	v_box_container_2.visible=true
	

func _on_button_pressed2() -> void:
	pass # Replace with function body.
