# chest_site.gd
# ------------------------------------------------------------------
# Chest site screen. Randomly offers one relic the player doesn't own.
# Marks the originating roadmap node complete on exit.
# ------------------------------------------------------------------
extends Control

const RELIC_POOL = {
	"Bandage Roll": {
		"description": "Start each combat with 5 Block.",
	},
	"Iron Shield": {
		"description": "Start each combat with 3 Block.",
	},
	"Lucky Coin": {
		"description": "Gain +5 extra gold after normal combat.",
	},
}

var _take_btn: Button
var _chosen_relic: String = ""


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
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.size = Vector2(300, 30)
	subtitle.position = Vector2(426, 220)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	var relic_name_label = Label.new()
	relic_name_label.add_theme_font_size_override("font_size", 24)
	relic_name_label.size = Vector2(300, 40)
	relic_name_label.position = Vector2(426, 270)
	relic_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(relic_name_label)

	var relic_desc_label = Label.new()
	relic_desc_label.add_theme_font_size_override("font_size", 16)
	relic_desc_label.size = Vector2(400, 30)
	relic_desc_label.position = Vector2(376, 320)
	relic_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(relic_desc_label)

	# Pick a relic the player doesn't already own
	var available: Array = []
	for relic_name in RELIC_POOL.keys():
		if not GameState.relics.has(relic_name):
			available.append(relic_name)

	_take_btn = Button.new()
	_take_btn.name = "TakeButton"
	_take_btn.size = Vector2(200, 50)
	_take_btn.position = Vector2(476, 390)
	_take_btn.add_theme_font_size_override("font_size", 20)
	_take_btn.pressed.connect(_on_take_pressed)
	add_child(_take_btn)

	if available.is_empty():
		subtitle.text = "The chest is empty."
		relic_name_label.text = "No new relics"
		relic_desc_label.text = "You already own everything."
		_take_btn.text = "Nothing to Take"
		_take_btn.disabled = true
		_chosen_relic = ""
	else:
		_chosen_relic = available[randi() % available.size()]
		subtitle.text = "You found a relic"
		relic_name_label.text = _chosen_relic
		relic_desc_label.text = RELIC_POOL[_chosen_relic]["description"]
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
	if _chosen_relic == "":
		return
	GameState.relics.append(_chosen_relic)
	_take_btn.disabled = true
	_take_btn.text = "Taken"
	print("Relic acquired: ", _chosen_relic)


func _on_leave_pressed():
	if not GameState.nodes_completed.has(GameState.current_node):
		GameState.nodes_completed.append(GameState.current_node)
	print("Left chest site. Node ", GameState.current_node, " marked complete.")
	get_tree().change_scene_to_file("res://Scene/roadmap_scene.tscn")
