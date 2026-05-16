extends Node

const CardClass = preload("res://Scripts/Card.gd")

const TEST_CARD_DATA = {
	"Bunny":   {"type": "ANIMAL",    "cost": 0, "value": 0,  "desc": "ATK: 4 | HP: 12",  "hp": 12, "atk": 4,  "def": 2},
	"Turtle":  {"type": "ANIMAL",    "cost": 0, "value": 0,  "desc": "ATK: 2 | HP: 20",  "hp": 20, "atk": 2,  "def": 5},
	"Dog":     {"type": "ANIMAL",    "cost": 0, "value": 0,  "desc": "ATK: 8 | HP: 10",  "hp": 10, "atk": 8,  "def": 1},
	"Bunny+":  {"type": "ANIMAL",    "cost": 0, "value": 0,  "desc": "ATK: 6 | HP: 16",  "hp": 16, "atk": 6,  "def": 3},
	"Turtle+": {"type": "ANIMAL",    "cost": 0, "value": 0,  "desc": "ATK: 4 | HP: 28",  "hp": 28, "atk": 4,  "def": 7},
	"Dog+":    {"type": "ANIMAL",    "cost": 0, "value": 0,  "desc": "ATK: 12 | HP: 14", "hp": 14, "atk": 12, "def": 2},
	"BIG":     {"type": "ADJECTIVE", "cost": 1, "value": 5,  "desc": "All field animals gain +5 ATK and +5 HP."},
	"FAST":    {"type": "ADJECTIVE", "cost": 1, "value": 3,  "desc": "All field animals gain +3 ATK."},
	"TOUGH":   {"type": "ADJECTIVE", "cost": 1, "value": 6,  "desc": "All field animals gain +6 HP."},
	"SHARP":   {"type": "ADJECTIVE", "cost": 1, "value": 4,  "desc": "All field animals gain +4 ATK."},
	"SMART":   {"type": "ADJECTIVE", "cost": 1, "value": 2,  "desc": "Draw 2 cards."},
	"MAGIC":   {"type": "ADJECTIVE", "cost": 1, "value": 8,  "desc": "Gain 8 Block."},
	"Pounce":  {"type": "ATTACK",    "cost": 1, "value": 8,  "desc": "Deal 8 damage."},
	"Roar":    {"type": "ATTACK",    "cost": 2, "value": 14, "desc": "Deal 14 damage."},
	"Curl Up": {"type": "SKILL",     "cost": 1, "value": 8,  "desc": "Gain 8 Block."},
	"Guard":   {"type": "SKILL",     "cost": 2, "value": 15, "desc": "Gain 15 Block."},
	"Dash":    {"type": "ATTACK",    "cost": 1, "value": 4,  "desc": "Deal 4 damage. Draw 1 card."},
	"Scout":   {"type": "SKILL",     "cost": 1, "value": 1,  "desc": "Gain 1 Block. Draw 1 card."},
	"Sneak":   {"type": "SKILL",     "cost": 1, "value": 4,  "desc": "Gain 4 Block. Draw 1 card."},
}

const TYPE_MAP = {
	"ANIMAL":    CardClass.CardType.ANIMAL,
	"ADJECTIVE": CardClass.CardType.ADJECTIVE,
	"ATTACK":    CardClass.CardType.ATTACK,
	"SKILL":     CardClass.CardType.SKILL,
}

@onready var _button_containers: Array = [
	$CanvasLayer/DevDock/Margin/VBox/AnimalsRow/AnimalsButtons,
	$CanvasLayer/DevDock/Margin/VBox/AdjRow/AdjectivesButtons,
	$CanvasLayer/DevDock/Margin/VBox/VerbRow/VerbsButtons,
]


func _ready():
	$CanvasLayer/BunnyPanel/BunnyButton.pressed.connect(_on_bunny_pressed)
	$CanvasLayer/TurtlePanel/TurtleButton.pressed.connect(_on_turtle_pressed)
	$CanvasLayer/DogPanel/DogButton.pressed.connect(_on_dog_pressed)
	for container in _button_containers:
		for child in container.get_children():
			if child is Button and TEST_CARD_DATA.has(child.text):
				child.tooltip_text = TEST_CARD_DATA[child.text]["desc"]


func _on_bunny_pressed():
	GameState.selected_starter = "Bunny"
	_add_test_cards()
	get_tree().change_scene_to_file("res://Scene/roadmap.tscn")


func _on_turtle_pressed():
	GameState.selected_starter = "Turtle"
	_add_test_cards()
	get_tree().change_scene_to_file("res://Scene/roadmap.tscn")


func _on_dog_pressed():
	GameState.selected_starter = "Dog"
	_add_test_cards()
	get_tree().change_scene_to_file("res://Scene/roadmap.tscn")


func _get_selected_dev_cards() -> Array:
	var selected: Array = []
	for container in _button_containers:
		for child in container.get_children():
			if child is Button and child.button_pressed:
				selected.append(child.text)
	return selected


func _add_test_cards():
	var selected = _get_selected_dev_cards()
	for card_name in selected:
		if not TEST_CARD_DATA.has(card_name):
			push_warning("Unknown test card: " + card_name)
			continue
		var info = TEST_CARD_DATA[card_name]
		var card = CardClass.new()
		card.card_name        = card_name
		card.card_type        = TYPE_MAP[info["type"]]
		card.energy_cost      = info["cost"]
		card.effect_value     = info["value"]
		card.card_description = info["desc"]
		if info.has("hp"):
			card.animal_hp = info["hp"]
		if info.has("atk"):
			card.animal_atk = info["atk"]
		if info.has("def"):
			card.animal_defense = info["def"]
		GameState.reward_cards.append(card)
		print("Test card added: ", card_name)
