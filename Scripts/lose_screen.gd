# lose_screen.gd
# ------------------------------------------------------------------
# Overlay shown after a combat defeat.
# Displays a "Defeat!" message with New Run and Main Menu buttons.
# process_mode is PROCESS_MODE_WHEN_PAUSED (set in tscn) so the
# buttons stay responsive while get_tree().paused = true.
# ------------------------------------------------------------------
extends CanvasLayer


func _ready():
	$NewRunButton.pressed.connect(_on_new_run_pressed)
	$MainMenuButton.pressed.connect(_on_main_menu_pressed)


func _on_new_run_pressed():
	GameState.reset_run()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/animal_select.tscn")
	queue_free()


func _on_main_menu_pressed():
	GameState.reset_run()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	queue_free()
