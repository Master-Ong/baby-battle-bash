# chest_site.gd
# ------------------------------------------------------------------
# Chest site screen. Player can take the Bandage Roll relic once,
# then leave. Marks the originating roadmap node complete on exit.
# ------------------------------------------------------------------
extends Control

var _take_btn: Button


func _ready():
	_build_background()
	_build_ui()


func _build_background():
	var bg = ColorRect.new()
	bg.color = Color(0.12, 0.10, 0.06)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)


func _build_ui():
	var title = Label.new()
	title.text = "Treasure Chest"
	title.add_theme_font_size_override("font_size", 36)
	title.size = Vector2(340, 60)
	title.position = Vector2(406, 140)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var subtitle = Label.new()
	subtitle.text = "You found a relic"
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.size = Vector2(300, 30)
	subtitle.position = Vector2(426, 220)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	var relic_name = Label.new()
	relic_name.text = "Bandage Roll"
	relic_name.add_theme_font_size_override("font_size", 24)
	relic_name.size = Vector2(300, 40)
	relic_name.position = Vector2(426, 270)
	relic_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(relic_name)

	var relic_desc = Label.new()
	relic_desc.text = "Start each combat with 5 Block."
	relic_desc.add_theme_font_size_override("font_size", 16)
	relic_desc.size = Vector2(400, 30)
	relic_desc.position = Vector2(376, 320)
	relic_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(relic_desc)

	_take_btn = Button.new()
	_take_btn.name = "TakeButton"
	_take_btn.size = Vector2(200, 50)
	_take_btn.position = Vector2(476, 390)
	_take_btn.add_theme_font_size_override("font_size", 20)
	_take_btn.pressed.connect(_on_take_pressed)
	add_child(_take_btn)

	if GameState.relics.has("Bandage Roll"):
		_take_btn.disabled = true
		_take_btn.text = "Already Taken"
	else:
		_take_btn.text = "Take Relic"

	var leave_btn = Button.new()
	leave_btn.name = "LeaveButton"
	leave_btn.text = "Leave"
	leave_btn.size = Vector2(200, 40)
	leave_btn.position = Vector2(476, 460)
	leave_btn.add_theme_font_size_override("font_size", 16)
	leave_btn.pressed.connect(_on_leave_pressed)
	add_child(leave_btn)


func _on_take_pressed():
	GameState.relics.append("Bandage Roll")
	_take_btn.disabled = true
	_take_btn.text = "Taken"
	print("Relic acquired: Bandage Roll")


func _on_leave_pressed():
	if not GameState.nodes_completed.has(GameState.current_node):
		GameState.nodes_completed.append(GameState.current_node)
	print("Left chest site. Node ", GameState.current_node, " marked complete.")
	get_tree().change_scene_to_file("res://Scene/roadmap_scene.tscn")
