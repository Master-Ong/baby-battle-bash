extends Node


func _ready():
	$CanvasLayer/BunnyPanel/BunnyButton.pressed.connect(_on_bunny_pressed)
	$CanvasLayer/TurtlePanel/TurtleButton.pressed.connect(_on_turtle_pressed)
	$CanvasLayer/DogPanel/DogButton.pressed.connect(_on_dog_pressed)


func _on_bunny_pressed():
	GameState.selected_starter = "Bunny"
	get_tree().change_scene_to_file("res://Scene/roadmap.tscn")


func _on_turtle_pressed():
	GameState.selected_starter = "Turtle"
	get_tree().change_scene_to_file("res://Scene/roadmap.tscn")


func _on_dog_pressed():
	GameState.selected_starter = "Dog"
	get_tree().change_scene_to_file("res://Scene/roadmap.tscn")
