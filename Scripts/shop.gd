extends Control

const CardClass = preload("res://Scripts/Card.gd")
const CardDatabase = preload("res://Scripts/CardDatabase.gd")

const FUSION_MAP = {
	"Bunny":  "Bunny+",
	"Turtle": "Turtle+",
	"Dog":    "Dog+",
}

# Market
var _card_slots: Array = []
var _slot_buttons: Array = []
var _slot_labels: Array = []
var _slot_desc_labels: Array = []
var _reroll_buttons: Array = []
var _gold_label: Label

# Tabs
var _market_content: VBoxContainer
var _training_content: VBoxContainer
var _removal_content: VBoxContainer
var _market_btn: Button
var _training_btn: Button
var _removal_btn: Button
var _training_rows_vbox: VBoxContainer
var _current_tab: String = "market"

# Card Removal — selection state
var _selected_card = null
var _selected_card_index: int = -1
var _selected_card_button: Button = null

# Card Removal — UI references
var _stall_animals_vbox: VBoxContainer
var _stall_colors_vbox: VBoxContainer
var _stall_adjectives_vbox: VBoxContainer
var _stall_verbs_vbox: VBoxContainer
var _confirm_title: Label
var _confirm_desc: Label
var _confirm_btn: Button


func _ready():
	_build_ui()
	_pick_shop_cards()
	_refresh_buttons()
	_switch_tab("market")


func _build_ui():
	var bg = ColorRect.new()
	bg.color = Color(0.12, 0.1, 0.15)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 8)
	main_vbox.offset_left = 20
	main_vbox.offset_top = 10
	main_vbox.offset_right = -20
	main_vbox.offset_bottom = -10
	add_child(main_vbox)

	# --- Header ---
	var header_row = HBoxContainer.new()
	main_vbox.add_child(header_row)

	var title_label = Label.new()
	title_label.text = "Shop"
	title_label.add_theme_font_size_override("font_size", 32)
	header_row.add_child(title_label)

	var header_spacer = Control.new()
	header_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_child(header_spacer)

	_gold_label = Label.new()
	_gold_label.text = "Gold: " + str(GameState.gold)
	_gold_label.add_theme_font_size_override("font_size", 20)
	header_row.add_child(_gold_label)

	# --- Tab buttons ---
	var tab_row = HBoxContainer.new()
	tab_row.add_theme_constant_override("separation", 4)
	main_vbox.add_child(tab_row)

	_market_btn = Button.new()
	_market_btn.text = "Market"
	_market_btn.custom_minimum_size = Vector2(150, 36)
	_market_btn.add_theme_font_size_override("font_size", 16)
	_market_btn.pressed.connect(_switch_tab.bind("market"))
	tab_row.add_child(_market_btn)

	_training_btn = Button.new()
	_training_btn.text = "Training Camp"
	_training_btn.custom_minimum_size = Vector2(160, 36)
	_training_btn.add_theme_font_size_override("font_size", 16)
	_training_btn.pressed.connect(_switch_tab.bind("training"))
	tab_row.add_child(_training_btn)

	_removal_btn = Button.new()
	_removal_btn.text = "Card Removal"
	_removal_btn.custom_minimum_size = Vector2(150, 36)
	_removal_btn.add_theme_font_size_override("font_size", 16)
	_removal_btn.pressed.connect(_switch_tab.bind("removal"))
	tab_row.add_child(_removal_btn)

	# --- Content container (all three tabs overlap here, visibility toggled) ---
	var content_container = Control.new()
	content_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(content_container)

	_market_content = VBoxContainer.new()
	_market_content.set_anchors_preset(Control.PRESET_FULL_RECT)
	_market_content.add_theme_constant_override("separation", 8)
	content_container.add_child(_market_content)
	_build_market_content()

	_training_content = VBoxContainer.new()
	_training_content.set_anchors_preset(Control.PRESET_FULL_RECT)
	_training_content.add_theme_constant_override("separation", 8)
	content_container.add_child(_training_content)
	_build_training_content_initial()

	_removal_content = VBoxContainer.new()
	_removal_content.set_anchors_preset(Control.PRESET_FULL_RECT)
	_removal_content.add_theme_constant_override("separation", 8)
	content_container.add_child(_removal_content)
	_init_removal_content()

	# --- Footer ---
	var footer_row = HBoxContainer.new()
	main_vbox.add_child(footer_row)

	var footer_spacer = Control.new()
	footer_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer_row.add_child(footer_spacer)

	var leave_btn = Button.new()
	leave_btn.text = "Return to Roadmap"
	leave_btn.custom_minimum_size = Vector2(200, 44)
	leave_btn.add_theme_font_size_override("font_size", 16)
	leave_btn.pressed.connect(_on_leave_pressed)
	footer_row.add_child(leave_btn)


# =====================================================================
# TAB 1 — MARKET
# =====================================================================

func _build_market_content():
	var cards_row = HBoxContainer.new()
	cards_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cards_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cards_row.add_theme_constant_override("separation", 16)
	_market_content.add_child(cards_row)

	for i in 3:
		var panel = Panel.new()
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		cards_row.add_child(panel)

		var inner_vbox = VBoxContainer.new()
		inner_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		inner_vbox.add_theme_constant_override("separation", 8)
		inner_vbox.offset_left = 12
		inner_vbox.offset_top = 12
		inner_vbox.offset_right = -12
		inner_vbox.offset_bottom = -12
		panel.add_child(inner_vbox)

		var name_label = Label.new()
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 18)
		inner_vbox.add_child(name_label)
		_slot_labels.append(name_label)

		var desc_label = Label.new()
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		desc_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		desc_label.add_theme_font_size_override("font_size", 14)
		inner_vbox.add_child(desc_label)
		_slot_desc_labels.append(desc_label)

		var adopt_btn = Button.new()
		adopt_btn.text = "Adopt (10g)"
		adopt_btn.add_theme_font_size_override("font_size", 14)
		adopt_btn.pressed.connect(_on_adopt_pressed.bind(i))
		inner_vbox.add_child(adopt_btn)
		_slot_buttons.append(adopt_btn)

		var reroll_btn = Button.new()
		reroll_btn.text = "Reroll (1g)"
		reroll_btn.add_theme_font_size_override("font_size", 14)
		reroll_btn.pressed.connect(_on_reroll_pressed.bind(i))
		inner_vbox.add_child(reroll_btn)
		_reroll_buttons.append(reroll_btn)


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
		_slot_labels[i].text = card.card_name if card != null else "Empty"
		_slot_desc_labels[i].text = card.card_description if card != null else ""


func _refresh_buttons():
	_update_gold_label()
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


func _update_gold_label():
	_gold_label.text = "Gold: " + str(GameState.gold)


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

	var visible_names: Array = []
	for i in 3:
		if i != slot_idx and _card_slots[i] != null:
			visible_names.append(_card_slots[i].card_name)

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


# =====================================================================
# TAB 2 — TRAINING CAMP
# =====================================================================

func _build_training_content_initial():
	var title = Label.new()
	title.text = "Training Camp"
	title.add_theme_font_size_override("font_size", 22)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_training_content.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Combine 2 matching animals into a stronger form!"
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_training_content.add_child(subtitle)

	_training_rows_vbox = VBoxContainer.new()
	_training_rows_vbox.add_theme_constant_override("separation", 8)
	_training_content.add_child(_training_rows_vbox)

	_refresh_training_content()


func _refresh_training_content():
	for child in _training_rows_vbox.get_children():
		child.queue_free()

	var any_available = false
	for base_name in FUSION_MAP:
		var upgraded_name = FUSION_MAP[base_name]
		var count = _count_in_deck(base_name)

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		_training_rows_vbox.add_child(row)

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
		_training_rows_vbox.add_child(no_fuse)


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

	_refresh_training_content()


# =====================================================================
# TAB 3 — CARD REMOVAL
# =====================================================================

func _init_removal_content():
	var instruction = Label.new()
	instruction.text = "Click a card to examine it, then confirm removal below."
	instruction.add_theme_font_size_override("font_size", 14)
	instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_removal_content.add_child(instruction)

	# --- 4 stall columns ---
	var stalls_wrapper = HBoxContainer.new()
	stalls_wrapper.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stalls_wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stalls_wrapper.add_theme_constant_override("separation", 8)
	_removal_content.add_child(stalls_wrapper)

	_stall_animals_vbox    = _create_stall(stalls_wrapper, "Animals")
	_stall_colors_vbox     = _create_stall(stalls_wrapper, "Colors")
	_stall_adjectives_vbox = _create_stall(stalls_wrapper, "Adjectives")
	_stall_verbs_vbox      = _create_stall(stalls_wrapper, "Verbs / Skills")

	# --- Master confirmation box ---
	var confirm_panel = PanelContainer.new()
	confirm_panel.custom_minimum_size = Vector2(0, 80)
	_removal_content.add_child(confirm_panel)

	var confirm_hbox = HBoxContainer.new()
	confirm_hbox.add_theme_constant_override("separation", 16)
	confirm_panel.add_child(confirm_hbox)

	var confirm_info_vbox = VBoxContainer.new()
	confirm_info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	confirm_hbox.add_child(confirm_info_vbox)

	_confirm_title = Label.new()
	_confirm_title.text = "No card selected"
	_confirm_title.add_theme_font_size_override("font_size", 16)
	confirm_info_vbox.add_child(_confirm_title)

	_confirm_desc = Label.new()
	_confirm_desc.text = "Choose a card from the stalls above."
	_confirm_desc.add_theme_font_size_override("font_size", 13)
	_confirm_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	confirm_info_vbox.add_child(_confirm_desc)

	_confirm_btn = Button.new()
	_confirm_btn.text = "Select a Card to Remove"
	_confirm_btn.custom_minimum_size = Vector2(220, 50)
	_confirm_btn.add_theme_font_size_override("font_size", 15)
	_confirm_btn.disabled = true
	_confirm_btn.pressed.connect(_remove_selected_card)
	confirm_hbox.add_child(_confirm_btn)


func _create_stall(parent: HBoxContainer, header_text: String) -> VBoxContainer:
	var stall_panel = PanelContainer.new()
	stall_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stall_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(stall_panel)

	var stall_vbox = VBoxContainer.new()
	stall_vbox.add_theme_constant_override("separation", 4)
	stall_panel.add_child(stall_vbox)

	var header = Label.new()
	header.text = header_text
	header.add_theme_font_size_override("font_size", 15)
	header.add_theme_color_override("font_color", Color(0.7, 0.7, 0.4))
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stall_vbox.add_child(header)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stall_vbox.add_child(scroll)

	var list_vbox = VBoxContainer.new()
	list_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_vbox.add_theme_constant_override("separation", 3)
	scroll.add_child(list_vbox)

	return list_vbox


func _build_removal_content():
	for vbox in [_stall_animals_vbox, _stall_colors_vbox, _stall_adjectives_vbox, _stall_verbs_vbox]:
		for child in vbox.get_children():
			child.queue_free()

	_clear_selection()

	var groups = {
		"animals":    [],
		"colors":     [],
		"adjectives": [],
		"verbs":      [],
	}

	for i in GameState.reward_cards.size():
		var card = GameState.reward_cards[i]
		var entry = {"index": i, "card": card}
		match card.card_type:
			CardClass.CardType.ANIMAL:
				groups["animals"].append(entry)
			CardClass.CardType.COLOR:
				groups["colors"].append(entry)
			CardClass.CardType.ADJECTIVE:
				groups["adjectives"].append(entry)
			CardClass.CardType.ATTACK, CardClass.CardType.SKILL, CardClass.CardType.WORD:
				groups["verbs"].append(entry)
			_:
				groups["verbs"].append(entry)

	for key in groups:
		groups[key].sort_custom(func(a, b): return a["card"].card_name < b["card"].card_name)

	_populate_stall(_stall_animals_vbox,    groups["animals"])
	_populate_stall(_stall_colors_vbox,     groups["colors"])
	_populate_stall(_stall_adjectives_vbox, groups["adjectives"])
	_populate_stall(_stall_verbs_vbox,      groups["verbs"])


func _populate_stall(stall_vbox: VBoxContainer, entries: Array):
	if entries.size() == 0:
		var empty_lbl = Label.new()
		empty_lbl.text = "(empty)"
		empty_lbl.add_theme_font_size_override("font_size", 12)
		empty_lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		stall_vbox.add_child(empty_lbl)
		return

	for entry in entries:
		var card = entry["card"]
		var original_index = entry["index"]

		var btn = Button.new()
		btn.text = card.card_name
		btn.add_theme_font_size_override("font_size", 13)
		btn.custom_minimum_size = Vector2(0, 28)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(_select_card.bind(card, original_index, btn))
		stall_vbox.add_child(btn)


func _select_card(card, original_index: int, btn: Button):
	if _selected_card_button != null:
		_selected_card_button.modulate = Color.WHITE

	_selected_card = card
	_selected_card_index = original_index
	_selected_card_button = btn

	btn.modulate = Color(0.5, 1.0, 0.5)
	_update_confirmation_box()


func _clear_selection():
	if _selected_card_button != null:
		_selected_card_button.modulate = Color.WHITE
	_selected_card = null
	_selected_card_index = -1
	_selected_card_button = null
	_update_confirmation_box()


func _update_confirmation_box():
	if _confirm_title == null:
		return
	if _selected_card == null:
		_confirm_title.text = "No card selected"
		_confirm_desc.text = "Choose a card from the stalls above."
		_confirm_btn.text = "Select a Card to Remove"
		_confirm_btn.disabled = true
		return

	var type_str = _card_type_string(_selected_card)
	_confirm_title.text = "SELECTED: " + _selected_card.card_name + " (" + type_str + ")"
	_confirm_desc.text = _selected_card.card_description

	if GameState.gold >= 3:
		_confirm_btn.text = "REMOVE CARD (3g)"
		_confirm_btn.disabled = false
	else:
		_confirm_btn.text = "NOT ENOUGH GOLD (3g)"
		_confirm_btn.disabled = true


func _remove_selected_card():
	if _selected_card == null:
		return
	if _selected_card_index < 0 or _selected_card_index >= GameState.reward_cards.size():
		print("Invalid removal index: ", _selected_card_index)
		_clear_selection()
		return
	if GameState.gold < 3:
		print("Not enough gold to remove a card")
		return

	var card = GameState.reward_cards[_selected_card_index]
	GameState.gold -= 3
	GameState.reward_cards.remove_at(_selected_card_index)
	print("Removed '", card.card_name, "' from collection. Gold: ", GameState.gold)

	_build_removal_content()
	_refresh_training_content()
	_refresh_buttons()


func _card_type_string(card) -> String:
	match card.card_type:
		CardClass.CardType.ANIMAL:    return "Animal"
		CardClass.CardType.ATTACK:    return "Attack"
		CardClass.CardType.SKILL:     return "Skill"
		CardClass.CardType.COLOR:     return "Color"
		CardClass.CardType.WORD:      return "Word"
		CardClass.CardType.ADJECTIVE: return "Adjective"
		_: return "???"


# =====================================================================
# TAB SWITCHING
# =====================================================================

func _switch_tab(tab_name: String):
	_current_tab = tab_name
	_market_content.visible   = (tab_name == "market")
	_training_content.visible = (tab_name == "training")
	_removal_content.visible  = (tab_name == "removal")

	_market_btn.disabled   = (tab_name == "market")
	_training_btn.disabled = (tab_name == "training")
	_removal_btn.disabled  = (tab_name == "removal")

	if tab_name == "training":
		_refresh_training_content()
	elif tab_name == "removal":
		_build_removal_content()


# =====================================================================
# LEAVE
# =====================================================================

func _on_leave_pressed():
	if not GameState.nodes_completed.has(GameState.current_node):
		GameState.nodes_completed.append(GameState.current_node)
	print("Left shop. Node ", GameState.current_node, " marked complete.")
	get_tree().change_scene_to_file("res://Scene/roadmap_scene.tscn")
