extends CanvasLayer


func _ready():
	$VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu)


func _on_main_menu():
	GameState.reset_run()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	queue_free()
