# card_display.gd
# ------------------------------------------------------------------
# Controls ONE visual card in the player's hand (or on the field).
# Jobs:
#   1. DISPLAY  — fill labels with card data when setup() is called.
#   2. HOVER    — scale up and lift the card when the mouse is over it.
#   3. CLICK    — play the card when the player left-clicks it.
# ------------------------------------------------------------------
extends Area2D


# =====================================================================
# PRELOADS
# =====================================================================
const CardClass = preload("res://Scripts/Card.gd")


# =====================================================================
# VARIABLES
# =====================================================================
var card_data = null

# Tracks whether the hover offset is currently applied so we can
# safely reverse it in _on_mouse_exited without drift.
var hover_active: bool = false

# Drag state — ANIMAL cards only
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var original_global_position: Vector2 = Vector2.ZERO
var original_parent: Node = null


@onready var name_label        = $CardBackground/CardName
@onready var cost_label        = $CardBackground/CardCost
@onready var type_label        = $CardBackground/CardType
@onready var description_label = $CardBackground/CardDescription


# =====================================================================
# _ready()
# =====================================================================
func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)


# =====================================================================
# setup(card) — fills in this card's visual labels
# =====================================================================
func setup(card):
	card_data = card

	name_label.text = card.card_name
	cost_label.text = str(card.energy_cost)

	match card.card_type:
		CardClass.CardType.ATTACK:
			type_label.text = "Attack"
			description_label.text = card.card_description
		CardClass.CardType.SKILL:
			type_label.text = "Skill"
			description_label.text = card.card_description
		CardClass.CardType.ANIMAL:
			type_label.text = "Animal"
			description_label.text = "ATK: " + str(card.animal_atk) + "  HP: " + str(card.animal_hp)
		_:
			type_label.text = "Unknown"
			description_label.text = card.card_description

	var style = StyleBoxFlat.new()
	match card.card_type:
		CardClass.CardType.ATTACK:
			style.bg_color = Color(0.25, 0.1, 0.1, 1)
		CardClass.CardType.SKILL:
			style.bg_color = Color(0.1, 0.15, 0.25, 1)
		CardClass.CardType.ANIMAL:
			style.bg_color = Color(0.1, 0.2, 0.12, 1)
		CardClass.CardType.COLOR:
			style.bg_color = Color(0.18, 0.1, 0.25, 1)
		_:
			style.bg_color = Color(0.15, 0.15, 0.15, 1)
	$CardBackground.add_theme_stylebox_override("panel", style)


# =====================================================================
# HOVER FUNCTIONS
# =====================================================================

func _on_mouse_entered():
	if is_dragging:
		return
	if not hover_active:
		scale = Vector2(1.1, 1.1)
		position.y -= 20
		hover_active = true

	if card_data != null:
		print("Card hovered: " + card_data.card_name)


func _on_mouse_exited():
	if is_dragging:
		return
	if hover_active:
		scale = Vector2(1.0, 1.0)
		position.y += 20
		hover_active = false


# =====================================================================
# CLICK HANDLER (press detection)
# =====================================================================

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		if card_data == null:
			return
		if card_data.card_type == CardClass.CardType.ANIMAL:
			# Cancel any active hover offset before dragging
			if hover_active:
				scale = Vector2(1.0, 1.0)
				position.y += 20
				hover_active = false
			is_dragging = true
			original_global_position = global_position
			drag_offset = global_position - get_global_mouse_position()
			original_parent = get_parent()
			z_index = 10
			get_viewport().set_input_as_handled()
		else:
			var manager = get_tree().root.get_node("CombatScene/GamerManager_Node")
			if card_data.card_type == CardClass.CardType.ATTACK:
				manager.play_attack_card(card_data, self)
			elif card_data.card_type == CardClass.CardType.SKILL:
				manager.play_skill_card(card_data, self)
			else:
				manager.play_color_or_word_card(card_data, self)


# =====================================================================
# DRAG MOVEMENT
# =====================================================================

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset


# =====================================================================
# DRAG RELEASE
# =====================================================================

func _unhandled_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed \
			and is_dragging:
		is_dragging = false
		z_index = 0
		_try_drop()


func _try_drop():
	var root    = get_tree().root.get_node("CombatScene")
	var manager = root.get_node("GamerManager_Node")

	# Slot index 0 = CardSlot1, 1 = CardSlot2, 2 = CardSlot3
	var slot_nodes = {
		0: root.get_node("PlayerField_Node2D/CardSlot1_Area2D"),
		1: root.get_node("PlayerField_Node2D/CardSlot2_Area2D"),
		2: root.get_node("PlayerField_Node2D/CardSlot3_Area2D"),
	}

	for slot_index in slot_nodes:
		var slot        = slot_nodes[slot_index]
		var slot_pos    = slot.global_position
		var card_center = get_global_mouse_position() + drag_offset + Vector2(60, 80)
		if card_center.distance_to(slot_pos) < 100.0 \
				and manager.is_slot_empty(slot_index):
			manager.play_animal_card(card_data, self, slot_index)
			get_parent().remove_child(self)
			slot.add_child(self)
			position = Vector2(-60, -80)
			set_process(false)
			input_pickable = false
			return

	_snap_back()


func _snap_back():
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_global_position, 0.2)
