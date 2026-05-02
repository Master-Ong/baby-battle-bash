# rest_site.gd
# ------------------------------------------------------------------
# Rest site screen. Player may heal once, then leaves.
# Marks the originating roadmap node complete on exit.
# ------------------------------------------------------------------
extends Control

var _hp_label: Label
var _rest_btn: Button


func _ready():
	_build_background()
	_build_ui()


func _build_background():
	var bg = ColorRect.new()
	bg.color = Color(0.08, 0.13, 0.08)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)


func _build_ui():
	var title = Label.new()
	title.text = "Rest Site"
	title.add_theme_font_size_override("font_size", 32)
	title.size = Vector2(200, 50)
	title.position = Vector2(476, 160)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	_hp_label = Label.new()
	_hp_label.text = _hp_text()
	_hp_label.add_theme_font_size_override("font_size", 20)
	_hp_label.size = Vector2(300, 40)
	_hp_label.position = Vector2(426, 250)
	_hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_hp_label)

	_rest_btn = Button.new()
	_rest_btn.text = "Rest  (+10 HP)"
	_rest_btn.size = Vector2(200, 50)
	_rest_btn.position = Vector2(476, 320)
	_rest_btn.disabled = GameState.player_hp >= 50
	_rest_btn.pressed.connect(_on_rest_pressed)
	add_child(_rest_btn)

	var leave_btn = Button.new()
	leave_btn.text = "Leave"
	leave_btn.size = Vector2(200, 50)
	leave_btn.position = Vector2(476, 400)
	leave_btn.pressed.connect(_on_leave_pressed)
	add_child(leave_btn)


func _hp_text() -> String:
	return "HP: " + str(GameState.player_hp) + " / 50"


func _on_rest_pressed():
	GameState.player_hp = min(GameState.player_hp + 10, 50)
	_hp_label.text = _hp_text()
	_rest_btn.disabled = true
	print("Rested — HP now ", GameState.player_hp)


func _on_leave_pressed():
	if not GameState.nodes_completed.has(GameState.current_node):
		GameState.nodes_completed.append(GameState.current_node)
	print("Left rest site. Node ", GameState.current_node, " marked complete.")
	get_tree().change_scene_to_file("res://Scene/roadmap_scene.tscn")
