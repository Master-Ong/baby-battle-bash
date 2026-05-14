extends Node

const CardClass = preload("res://Scripts/Card.gd")


func _ready():
	$CanvasLayer/BunnyPanel/BunnyButton.pressed.connect(_on_bunny_pressed)
	$CanvasLayer/TurtlePanel/TurtleButton.pressed.connect(_on_turtle_pressed)
	$CanvasLayer/DogPanel/DogButton.pressed.connect(_on_dog_pressed)


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


func _add_test_cards():
	var test_cards = {
		"BIG":     {"type": CardClass.CardType.ADJECTIVE, "cost": 1, "value": 5,  "desc": "All field animals gain +5 ATK and +5 HP."},
		"FAST":    {"type": CardClass.CardType.ADJECTIVE, "cost": 1, "value": 3,  "desc": "All field animals gain +3 ATK."},
		"TOUGH":   {"type": CardClass.CardType.ADJECTIVE, "cost": 1, "value": 6,  "desc": "All field animals gain +6 HP."},
		"SHARP":   {"type": CardClass.CardType.ADJECTIVE, "cost": 1, "value": 4,  "desc": "All field animals gain +4 ATK."},
		"SMART":   {"type": CardClass.CardType.ADJECTIVE, "cost": 1, "value": 2,  "desc": "Draw 2 cards."},
		"MAGIC":   {"type": CardClass.CardType.ADJECTIVE, "cost": 1, "value": 8,  "desc": "Gain 8 Block."},
		"Pounce":  {"type": CardClass.CardType.ATTACK,    "cost": 1, "value": 8,  "desc": "Deal 8 damage."},
		"Roar":    {"type": CardClass.CardType.ATTACK,    "cost": 2, "value": 14, "desc": "Deal 14 damage."},
		"Curl Up": {"type": CardClass.CardType.SKILL,     "cost": 1, "value": 8,  "desc": "Gain 8 Block."},
		"Guard":   {"type": CardClass.CardType.SKILL,     "cost": 2, "value": 15, "desc": "Gain 15 Block."},
	}
	var buttons = {
		"BIG":     $CanvasLayer/TestBIG,
		"FAST":    $CanvasLayer/TestFAST,
		"TOUGH":   $CanvasLayer/TestTOUGH,
		"SHARP":   $CanvasLayer/TestSHARP,
		"SMART":   $CanvasLayer/TestSMART,
		"MAGIC":   $CanvasLayer/TestMAGIC,
		"Pounce":  $CanvasLayer/TestPounce,
		"Roar":    $CanvasLayer/TestRoar,
		"Curl Up": $CanvasLayer/TestCurlUp,
		"Guard":   $CanvasLayer/TestGuard,
	}
	for card_name in buttons:
		if buttons[card_name].button_pressed:
			var info = test_cards[card_name]
			var card = CardClass.new()
			card.card_name        = card_name
			card.card_type        = info["type"]
			card.energy_cost      = info["cost"]
			card.effect_value     = info["value"]
			card.card_description = info["desc"]
			GameState.reward_cards.append(card)
			print("Test card added: ", card_name)
