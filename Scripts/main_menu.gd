extends Node


func _ready():
	$CanvasLayer/PlayButton.pressed.connect(_on_play_pressed)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scene/animal_select.tscn")
