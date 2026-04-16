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

	gold_label.text = "Gold: +" + str(gold_earned)

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
	# --- Animal pool ---
	var animal_pool: Array = []

	var bunny = CardClass.new()
	bunny.card_name        = "Bunny"
	bunny.card_type        = CardClass.CardType.ANIMAL
	bunny.energy_cost      = 0
	bunny.animal_hp        = 12
	bunny.animal_atk       = 4
	bunny.animal_defense   = 2
	bunny.card_description = "ATK: 4 | HP: 12"
	animal_pool.append(bunny)

	var turtle = CardClass.new()
	turtle.card_name        = "Turtle"
	turtle.card_type        = CardClass.CardType.ANIMAL
	turtle.energy_cost      = 0
	turtle.animal_hp        = 20
	turtle.animal_atk       = 2
	turtle.animal_defense   = 5
	turtle.card_description = "ATK: 2 | HP: 20"
	animal_pool.append(turtle)

	var dog = CardClass.new()
	dog.card_name        = "Dog"
	dog.card_type        = CardClass.CardType.ANIMAL
	dog.energy_cost      = 0
	dog.animal_hp        = 10
	dog.animal_atk       = 8
	dog.animal_defense   = 1
	dog.card_description = "ATK: 8 | HP: 10"
	animal_pool.append(dog)

	# --- Color pool ---
	# TODO — real color effects (draw/heal/energy) not built yet, using ATK buff as placeholder
	var color_pool: Array = []

	var blue = CardClass.new()
	blue.card_name        = "Blue"
	blue.card_type        = CardClass.CardType.COLOR
	blue.energy_cost      = 1
	blue.effect_value     = 1
	blue.card_description = "Buff field animals +1 ATK"
	color_pool.append(blue)

	var red = CardClass.new()
	red.card_name        = "Red"
	red.card_type        = CardClass.CardType.COLOR
	red.energy_cost      = 1
	red.effect_value     = 2
	red.card_description = "Buff field animals +2 ATK"
	color_pool.append(red)

	var green = CardClass.new()
	green.card_name        = "Green"
	green.card_type        = CardClass.CardType.COLOR
	green.energy_cost      = 1
	green.effect_value     = 1
	green.card_description = "Buff field animals +1 ATK"
	color_pool.append(green)

	# --- Word pool ---
	# TODO — full verb effects not built yet
	var word_pool: Array = []

	var scratch = CardClass.new()
	scratch.card_name        = "Scratch"
	scratch.card_type        = CardClass.CardType.ATTACK
	scratch.energy_cost      = 1
	scratch.effect_value     = 6
	scratch.card_description = "Deal 6 damage."
	word_pool.append(scratch)

	var hide = CardClass.new()
	hide.card_name        = "Hide"
	hide.card_type        = CardClass.CardType.SKILL
	hide.energy_cost      = 1
	hide.effect_value     = 5
	hide.card_description = "Gain 5 Block."
	word_pool.append(hide)

	var run_away = CardClass.new()
	run_away.card_name        = "Run Away"
	run_away.card_type        = CardClass.CardType.SKILL
	run_away.energy_cost      = 1
	run_away.effect_value     = 2
	run_away.card_description = "Gain 2 Block. Draw feel."
	word_pool.append(run_away)

	var bite = CardClass.new()
	bite.card_name        = "Bite"
	bite.card_type        = CardClass.CardType.ATTACK
	bite.energy_cost      = 1
	bite.effect_value     = 8
	bite.card_description = "Deal 8 damage."
	word_pool.append(bite)

	var block_card = CardClass.new()
	block_card.card_name        = "Block"
	block_card.card_type        = CardClass.CardType.SKILL
	block_card.energy_cost      = 1
	block_card.effect_value     = 8
	block_card.card_description = "Gain 8 Block."
	word_pool.append(block_card)

	var dash = CardClass.new()
	dash.card_name        = "Dash"
	dash.card_type        = CardClass.CardType.ATTACK
	dash.energy_cost      = 1
	dash.effect_value     = 4
	dash.card_description = "Deal 4 damage."
	word_pool.append(dash)

	var picked_animal = animal_pool[randi() % animal_pool.size()]
	var picked_color  = color_pool[randi() % color_pool.size()]
	var picked_word   = word_pool[randi() % word_pool.size()]

	show_rewards([picked_animal, picked_color, picked_word])


# =====================================================================
# _on_card_chosen — fires when a card button is clicked
# =====================================================================
func _on_card_chosen(index: int) -> void:
	var chosen_card = _card_options[index]

	GameState.reward_cards.append(chosen_card)
	print("Reward: stored '", chosen_card.card_name, "' in GameState. Total reward cards: ", GameState.reward_cards.size())

	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/combat_scene.tscn")
