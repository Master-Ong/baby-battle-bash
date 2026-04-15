extends Node


func _ready():
	$CanvasLayer/StartButton.pressed.connect(_on_start_pressed)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scene/combat_scene.tscn")
