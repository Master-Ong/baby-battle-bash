# roadmap.gd
# ------------------------------------------------------------------
# Fixed 5-node roadmap. All buttons and lines are built procedurally
# in _ready() so the tscn stays minimal.
# ------------------------------------------------------------------
extends Control

const NODE_TYPES  = ["Combat", "Rest",   "Combat",  "Combat",  "Shop",   "Chest",  "Boss"]
const NODE_LABELS = ["Fight 1", "Rest",  "Fight 2", "Fight 3", "Shop",   "Chest",  "Boss"]

# Any one completed prereq unlocks the node.
const UNLOCK_AFTER = {
	0: [],
	1: [0],
	2: [0],
	3: [1, 2],
	4: [3],      # Shop unlocks after Fight 3
	5: [4],      # Chest unlocks after Shop
	6: [5],      # Boss unlocks after Chest
}

# Button center positions in 1152x648 space, bottom-to-top.
const NODE_POSITIONS = [
	Vector2(576, 550),   # 0 Fight 1 — bottom center
	Vector2(288, 400),   # 1 Rest    — left
	Vector2(864, 400),   # 2 Fight 2 — right
	Vector2(576, 270),   # 3 Fight 3 — center
	Vector2(300, 180),   # 4 Shop    — left of center
	Vector2(850, 180),   # 5 Chest   — right of center
	Vector2(576, 70),    # 6 Boss    — top center
]

# Lines to draw between node indices.
const CONNECTIONS = [
	[0, 1],
	[0, 2],
	[1, 3],
	[2, 3],
	[3, 4],      # Fight 3 → Shop
	[3, 5],      # Fight 3 → Chest
	[4, 6],      # Shop → Boss
	[5, 6],      # Chest → Boss
]

var _node_buttons: Array = []


func _ready():
	_build_background()
	_build_lines()
	_build_buttons()
	refresh_nodes()


func _build_background():
	var bg = ColorRect.new()
	bg.color = Color(0.1, 0.08, 0.15)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	move_child(bg, 0)


func _build_lines():
	for conn in CONNECTIONS:
		var line = Line2D.new()
		line.width = 3.0
		line.default_color = Color(0.5, 0.5, 0.5)
		line.add_point(NODE_POSITIONS[conn[0]])
		line.add_point(NODE_POSITIONS[conn[1]])
		add_child(line)


func _build_buttons():
	_node_buttons.clear()
	for i in NODE_POSITIONS.size():
		var btn = Button.new()
		btn.text = NODE_LABELS[i] + "\n[" + NODE_TYPES[i] + "]"
		btn.size = Vector2(120, 60)
		btn.position = NODE_POSITIONS[i] - Vector2(60, 30)
		btn.pressed.connect(_on_node_pressed.bind(i))
		add_child(btn)
		_node_buttons.append(btn)


func refresh_nodes():
	for i in _node_buttons.size():
		var btn       = _node_buttons[i]
		var completed = GameState.nodes_completed.has(i)
		var unlocked  = _is_unlocked(i)

		btn.disabled = not unlocked or completed

		var style = StyleBoxFlat.new()
		if completed:
			style.bg_color = Color(0.2, 0.2, 0.2, 1)
			btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
		elif unlocked:
			style.bg_color = _bright_type_color(i)
			btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			style.bg_color = _base_type_color(i)
			btn.modulate = Color(0.4, 0.4, 0.4, 1.0)
		btn.add_theme_stylebox_override("normal", style)


func _base_type_color(node_idx: int) -> Color:
	match NODE_TYPES[node_idx]:
		"Combat": return Color(0.35, 0.1, 0.1, 1)
		"Rest":   return Color(0.1, 0.25, 0.1, 1)
		"Chest":  return Color(0.3, 0.25, 0.05, 1)
		"Shop":   return Color(0.15, 0.2, 0.25, 1)
		"Boss":   return Color(0.25, 0.05, 0.3, 1)
		_:        return Color(0.2, 0.2, 0.2, 1)


func _bright_type_color(node_idx: int) -> Color:
	var c = _base_type_color(node_idx)
	return Color(min(c.r + 0.1, 1.0), min(c.g + 0.1, 1.0), min(c.b + 0.1, 1.0), 1.0)


func _is_unlocked(node_idx: int) -> bool:
	if node_idx == 0:
		return true
	for prereq in UNLOCK_AFTER[node_idx]:
		if GameState.nodes_completed.has(prereq):
			return true
	return false


func _on_node_pressed(node_idx: int) -> void:
	GameState.current_node = node_idx
	var type = NODE_TYPES[node_idx]

	match type:
		"Combat":
			GameState.is_boss_fight = false
			match node_idx:
				0: GameState.encounter_number = 1
				2: GameState.encounter_number = 2
				3: GameState.encounter_number = 3
				_: GameState.encounter_number = 1
			get_tree().change_scene_to_file("res://Scene/combat_scene.tscn")
		"Rest":
			get_tree().change_scene_to_file("res://Scene/rest_site.tscn")
		"Shop":
			get_tree().change_scene_to_file("res://Scene/shop_scene.tscn")
		"Chest":
			get_tree().change_scene_to_file("res://Scene/chest_site.tscn")
		"Boss":
			GameState.is_boss_fight = true
			GameState.encounter_number = 4
			get_tree().change_scene_to_file("res://Scene/combat_scene.tscn")
