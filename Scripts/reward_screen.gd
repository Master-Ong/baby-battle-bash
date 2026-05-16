# reward_screen.gd
# ------------------------------------------------------------------
# Overlay shown after a combat win.
# Displays three card choices; clicking one adds it to the player's
# deck, then reloads the scene for the next encounter.
#
# NOTE: deck additions survive reload only if a persistent GameState
# autoload is later added. For now the card is appended to
# GamerManager's deck array before the reload triggers.
# ------------------------------------------------------------------
extends CanvasLayer

const CardClass = preload("res://Scripts/Card.gd")
const CardDatabase = preload("res://Scripts/CardDatabase.gd")

var gold_earned: int   = 10
var _card_options: Array = []


@onready var gold_label    = $Background/GoldLabel
@onready var card_option_0 = $Background/CardRow/CardOption0
@onready var card_option_1 = $Background/CardRow/CardOption1
@onready var card_option_2 = $Background/CardRow/CardOption2


# =====================================================================
# _ready
# =====================================================================
func _ready():
	# Run even while the tree is paused so buttons stay responsive.
	process_mode = Node.PROCESS_MODE_ALWAYS

	gold_label.text = "Gold: " + str(GameState.gold) + "  (+" + str(gold_earned) + ")"

	card_option_0.pressed.connect(_on_card_chosen.bind(0))
	card_option_1.pressed.connect(_on_card_chosen.bind(1))
	card_option_2.pressed.connect(_on_card_chosen.bind(2))


# =====================================================================
# show_rewards — called by win_combat() with exactly 3 Card objects
# =====================================================================
func show_rewards(card_options: Array) -> void:
	_card_options = card_options
	_fill_card(card_option_0, card_options[0])
	_fill_card(card_option_1, card_options[1])
	_fill_card(card_option_2, card_options[2])
	visible = true


# =====================================================================
# _fill_card — populates one Button's labels from a Card object
# =====================================================================
func _fill_card(button: Button, card) -> void:
	button.get_node("NameLabel").text = card.card_name

	match card.card_type:
		CardClass.CardType.ATTACK:
			button.get_node("TypeLabel").text = "Attack"
		CardClass.CardType.SKILL:
			button.get_node("TypeLabel").text = "Skill"
		CardClass.CardType.ANIMAL:
			button.get_node("TypeLabel").text = "Animal"
		CardClass.CardType.COLOR:
			button.get_node("TypeLabel").text = "Color"
		CardClass.CardType.WORD:
			button.get_node("TypeLabel").text = "Word"
		_:
			button.get_node("TypeLabel").text = "Card"

	button.get_node("DescLabel").text = card.card_description


# =====================================================================
# pick_rewards — builds three pools, picks one from each, calls show_rewards
# =====================================================================
func pick_rewards() -> void:
	var animal_pool = CardDatabase.get_animals()
	var color_pool = CardDatabase.get_colors()
	var adjective_pool = CardDatabase.get_adjectives()
	var word_pool: Array = []
	word_pool.append_array(CardDatabase.get_attacks())
	word_pool.append_array(CardDatabase.get_skills())

	var picked_animal = animal_pool[randi() % animal_pool.size()]
	var use_adjective = randf() < 0.3
	var modifier_card
	if use_adjective:
		modifier_card = adjective_pool.pick_random()
	else:
		modifier_card = color_pool.pick_random()
	var picked_word = word_pool[randi() % word_pool.size()]

	show_rewards([picked_animal, modifier_card, picked_word])


# =====================================================================
# _on_card_chosen — fires when a card button is clicked
# =====================================================================
func _on_card_chosen(index: int) -> void:
	var chosen_card = _card_options[index]

	GameState.gold += gold_earned
	print("Gold earned: ", gold_earned, " | Total gold: ", GameState.gold)

	GameState.reward_cards.append(chosen_card)
	print("Reward: stored '", chosen_card.card_name, "' in GameState. Total reward cards: ", GameState.reward_cards.size())

	GameState.nodes_completed.append(GameState.current_node)
	print("Node ", GameState.current_node, " marked complete.")

	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/roadmap.tscn")
