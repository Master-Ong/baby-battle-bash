# lose_screen.gd
# ------------------------------------------------------------------
# Overlay shown after a combat defeat.
# Displays a "Defeat!" message and a Retry button.
# process_mode is PROCESS_MODE_WHEN_PAUSED (set in tscn) so the
# button stays responsive while get_tree().paused = true.
# ------------------------------------------------------------------
extends CanvasLayer


func _ready():
	$RetryButton.pressed.connect(_on_retry_pressed)


func _on_retry_pressed():
	queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/combat_scene.tscn")
