extends Control

const CardClass = preload("res://Scripts/Card.gd")
const CardDatabase = preload("res://Scripts/CardDatabase.gd")

const FUSION_MAP = {
	"Bunny":  "Bunny+",
	"Turtle": "Turtle+",
	"Dog":    "Dog+",
}

var _card_slots: Array = []       # 3 Card objects
var _slot_buttons: Array = []     # 3 "Adopt" Button nodes
var _slot_labels: Array = []      # 3 Label nodes showing card name
var _reroll_buttons: Array = []
var _gold_label: Label
var _training_panel: PanelContainer = null


func _ready():
	_build_background()
	_build_ui()
	_pick_shop_cards()
	_refresh_buttons()


func _build_background():
	var bg = ColorRect.new()
	bg.color = Color(0.12, 0.1, 0.15)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)


func _build_ui():
	var title = Label.new()
	title.text = "Market"
	title.add_theme_font_size_override("font_size", 32)
	title.size = Vector2(200, 50)
	title.position = Vector2(476, 40)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	_gold_label = Label.new()
	_gold_label.text = "Gold: " + str(GameState.gold)
	_gold_label.add_theme_font_size_override("font_size", 20)
	_gold_label.size = Vector2(200, 40)
	_gold_label.position = Vector2(900, 40)
	_gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	add_child(_gold_label)

	# 3 card slots in a row
	var slot_x_positions = [150, 450, 750]
	for i in 3:
		var panel = Panel.new()
		panel.size = Vector2(250, 370)
		panel.position = Vector2(slot_x_positions[i], 150)
		add_child(panel)

		var name_label = Label.new()
		name_label.size = Vector2(230, 30)
		name_label.position = Vector2(10, 10)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 18)
		panel.add_child(name_label)
		_slot_labels.append(name_label)

		var desc_label = Label.new()
		desc_label.size = Vector2(230, 200)
		desc_label.position = Vector2(10, 50)
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		desc_label.add_theme_font_size_override("font_size", 14)
		panel.add_child(desc_label)

		var btn = Button.new()
		btn.text = "Adopt (10g)"
		btn.size = Vector2(200, 40)
		btn.position = Vector2(25, 260)
		btn.pressed.connect(_on_adopt_pressed.bind(i))
		panel.add_child(btn)
		_slot_buttons.append(btn)

		var reroll_btn = Button.new()
		reroll_btn.text = "Reroll (1g)"
		reroll_btn.size = Vector2(200, 40)
		reroll_btn.position = Vector2(25, 310)
		reroll_btn.pressed.connect(_on_reroll_pressed.bind(i))
		panel.add_child(reroll_btn)
		_reroll_buttons.append(reroll_btn)

	var training_btn = Button.new()
	training_btn.text = "Training Camp"
	training_btn.size = Vector2(200, 50)
	training_btn.position = Vector2(250, 570)
	training_btn.pressed.connect(_show_training)
	add_child(training_btn)

	var leave_btn = Button.new()
	leave_btn.text = "Return to Roadmap"
	leave_btn.size = Vector2(200, 50)
	leave_btn.position = Vector2(700, 570)
	leave_btn.pressed.connect(_on_leave_pressed)
	add_child(leave_btn)


func _build_full_card_pool() -> Array:
	return CardDatabase.get_all_cards()


func _pick_shop_cards():
	var pool = _build_full_card_pool()
	_card_slots.clear()

	for i in 3:
		if pool.size() == 0:
			break
		var idx = randi() % pool.size()
		_card_slots.append(pool[idx])
		pool.remove_at(idx)

	_update_slot_display()


func _update_slot_display():
	for i in _card_slots.size():
		var card = _card_slots[i]
		var panel = _slot_labels[i].get_parent()
		_slot_labels[i].text = card.card_name if card != null else "Empty"
		var desc_label = panel.get_child(1)
		desc_label.text = card.card_description if card != null else ""


func _refresh_buttons():
	_gold_label.text = "Gold: " + str(GameState.gold)
	for i in 3:
		var adopt_btn = _slot_buttons[i]
		var reroll_btn = _reroll_buttons[i]

		if _card_slots[i] == null:
			adopt_btn.text = "Sold Out"
			adopt_btn.disabled = true
			reroll_btn.disabled = true
		else:
			adopt_btn.text = "Adopt (10g)"
			adopt_btn.disabled = (GameState.gold < 10)
			reroll_btn.text = "Reroll (1g)"
			reroll_btn.disabled = (GameState.gold < 1)


func _on_adopt_pressed(slot_idx: int):
	if _card_slots[slot_idx] == null:
		return
	if GameState.gold < 10:
		return

	var card = _card_slots[slot_idx]
	GameState.gold -= 10
	GameState.reward_cards.append(card)
	print("Bought ", card.card_name, " for 10 gold. Total gold: ", GameState.gold)

	_card_slots[slot_idx] = null
	_update_slot_display()
	_refresh_buttons()


func _on_reroll_pressed(slot_idx: int):
	if _card_slots[slot_idx] == null:
		return
	if GameState.gold < 1:
		return

	var pool = _build_full_card_pool()

	# Collect names of other visible (unsold) cards
	var visible_names: Array = []
	for i in 3:
		if i != slot_idx and _card_slots[i] != null:
			visible_names.append(_card_slots[i].card_name)

	# Filter out visible cards to avoid duplicates
	var filtered: Array = []
	for card in pool:
		if not visible_names.has(card.card_name):
			filtered.append(card)

	if filtered.size() == 0:
		print("No unique cards available for reroll")
		return

	var new_card = filtered[randi() % filtered.size()]
	_card_slots[slot_idx] = new_card
	GameState.gold -= 1
	print("Rerolled slot ", slot_idx, " to ", new_card.card_name, ". Gold: ", GameState.gold)

	_update_slot_display()
	_refresh_buttons()


func _on_leave_pressed():
	if not GameState.nodes_completed.has(GameState.current_node):
		GameState.nodes_completed.append(GameState.current_node)
	print("Left shop. Node ", GameState.current_node, " marked complete.")
	get_tree().change_scene_to_file("res://Scene/roadmap_scene.tscn")


func _show_training():
	if _training_panel != null:
		_training_panel.queue_free()

	_training_panel = PanelContainer.new()
	_training_panel.size = Vector2(500, 300)
	_training_panel.position = Vector2(326, 174)
	add_child(_training_panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_right", 15)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	_training_panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	var title = Label.new()
	title.text = "Training Camp"
	title.add_theme_font_size_override("font_size", 22)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Combine 2 matching animals into a stronger form!"
	subtitle.add_theme_font_size_override("font_size", 13)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)

	var any_available = false
	for base_name in FUSION_MAP:
		var upgraded_name = FUSION_MAP[base_name]
		var count = _count_in_deck(base_name)

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		vbox.add_child(row)

		var label = Label.new()
		label.text = base_name + " x" + str(count) + " → " + upgraded_name
		label.add_theme_font_size_override("font_size", 15)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)

		var fuse_btn = Button.new()
		fuse_btn.text = "Fuse"
		fuse_btn.custom_minimum_size = Vector2(80, 30)
		if count >= 2:
			fuse_btn.pressed.connect(_do_fuse.bind(base_name, upgraded_name))
			any_available = true
		else:
			fuse_btn.disabled = true
		row.add_child(fuse_btn)

	if not any_available:
		var no_fuse = Label.new()
		no_fuse.text = "No fusions available. Need 2 of the same animal!"
		no_fuse.add_theme_font_size_override("font_size", 13)
		no_fuse.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(no_fuse)

	var close_btn = Button.new()
	close_btn.text = "Close"
	close_btn.custom_minimum_size = Vector2(100, 35)
	close_btn.pressed.connect(_close_training)
	vbox.add_child(close_btn)


func _count_in_deck(card_name: String) -> int:
	var count = 0
	for card in GameState.reward_cards:
		if card.card_name == card_name:
			count += 1
	return count


func _do_fuse(base_name: String, upgraded_name: String):
	var removed = 0
	var to_remove: Array = []
	for i in range(GameState.reward_cards.size()):
		if GameState.reward_cards[i].card_name == base_name and removed < 2:
			to_remove.append(i)
			removed += 1

	if removed < 2:
		print("Not enough ", base_name, " cards to fuse")
		return

	to_remove.reverse()
	for idx in to_remove:
		GameState.reward_cards.remove_at(idx)

	var upgraded_pool = CardDatabase.get_upgraded_animals()
	for card in upgraded_pool:
		if card.card_name == upgraded_name:
			GameState.reward_cards.append(card)
			print("Fused 2x ", base_name, " into ", upgraded_name, "!")
			break

	_show_training()


func _close_training():
	if _training_panel != null:
		_training_panel.queue_free()
		_training_panel = null
