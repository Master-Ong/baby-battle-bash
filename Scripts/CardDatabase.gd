extends Object

const CardClass = preload("res://Scripts/Card.gd")

static func get_all_cards() -> Array:
	var cards: Array = []
	cards.append_array(get_animals())
	cards.append_array(get_colors())
	cards.append_array(get_adjectives())
	cards.append_array(get_attacks())
	cards.append_array(get_skills())
	return cards

static func get_animals() -> Array:
	var pool: Array = []

	var bunny = CardClass.new()
	bunny.card_name = "Bunny"
	bunny.card_type = CardClass.CardType.ANIMAL
	bunny.energy_cost = 0
	bunny.animal_hp = 12
	bunny.animal_atk = 4
	bunny.animal_defense = 2
	bunny.card_description = "ATK: 4 | HP: 12"
	pool.append(bunny)

	var turtle = CardClass.new()
	turtle.card_name = "Turtle"
	turtle.card_type = CardClass.CardType.ANIMAL
	turtle.energy_cost = 0
	turtle.animal_hp = 20
	turtle.animal_atk = 2
	turtle.animal_defense = 5
	turtle.card_description = "ATK: 2 | HP: 20"
	pool.append(turtle)

	var dog = CardClass.new()
	dog.card_name = "Dog"
	dog.card_type = CardClass.CardType.ANIMAL
	dog.energy_cost = 0
	dog.animal_hp = 10
	dog.animal_atk = 8
	dog.animal_defense = 1
	dog.card_description = "ATK: 8 | HP: 10"
	pool.append(dog)

	return pool

static func get_upgraded_animals() -> Array:
	var pool: Array = []

	var bunny_plus = CardClass.new()
	bunny_plus.card_name = "Bunny+"
	bunny_plus.card_type = CardClass.CardType.ANIMAL
	bunny_plus.energy_cost = 0
	bunny_plus.animal_hp = 16
	bunny_plus.animal_atk = 6
	bunny_plus.animal_defense = 3
	bunny_plus.card_description = "ATK: 6 | HP: 16"
	pool.append(bunny_plus)

	var turtle_plus = CardClass.new()
	turtle_plus.card_name = "Turtle+"
	turtle_plus.card_type = CardClass.CardType.ANIMAL
	turtle_plus.energy_cost = 0
	turtle_plus.animal_hp = 28
	turtle_plus.animal_atk = 4
	turtle_plus.animal_defense = 7
	turtle_plus.card_description = "ATK: 4 | HP: 28"
	pool.append(turtle_plus)

	var dog_plus = CardClass.new()
	dog_plus.card_name = "Dog+"
	dog_plus.card_type = CardClass.CardType.ANIMAL
	dog_plus.energy_cost = 0
	dog_plus.animal_hp = 14
	dog_plus.animal_atk = 12
	dog_plus.animal_defense = 2
	dog_plus.card_description = "ATK: 12 | HP: 14"
	pool.append(dog_plus)

	return pool

static func get_colors() -> Array:
	var pool: Array = []

	var blue = CardClass.new()
	blue.card_name = "Blue"
	blue.card_type = CardClass.CardType.COLOR
	blue.energy_cost = 1
	blue.effect_value = 1
	blue.card_description = "Draw 1 card."
	pool.append(blue)

	var red = CardClass.new()
	red.card_name = "Red"
	red.card_type = CardClass.CardType.COLOR
	red.energy_cost = 1
	red.effect_value = 2
	red.card_description = "Buff field animals +2 ATK"
	pool.append(red)

	var green = CardClass.new()
	green.card_name = "Green"
	green.card_type = CardClass.CardType.COLOR
	green.energy_cost = 1
	green.effect_value = 3
	green.card_description = "Heal 3 HP."
	pool.append(green)

	var yellow = CardClass.new()
	yellow.card_name = "Yellow"
	yellow.card_type = CardClass.CardType.COLOR
	yellow.energy_cost = 1
	yellow.effect_value = 1
	yellow.card_description = "Gain 1 energy this turn."
	pool.append(yellow)

	var purple = CardClass.new()
	purple.card_name = "Purple"
	purple.card_type = CardClass.CardType.COLOR
	purple.energy_cost = 1
	purple.effect_value = 6
	purple.card_description = "Gain 6 Block."
	pool.append(purple)

	var white = CardClass.new()
	white.card_name = "White"
	white.card_type = CardClass.CardType.COLOR
	white.energy_cost = 1
	white.effect_value = 2
	white.card_description = "All field animals gain +2 ATK and +4 HP."
	pool.append(white)

	return pool

static func get_adjectives() -> Array:
	var pool: Array = []

	var big = CardClass.new()
	big.card_name = "BIG"
	big.card_type = CardClass.CardType.ADJECTIVE
	big.energy_cost = 1
	big.effect_value = 5
	big.card_description = "All field animals gain +5 ATK and +5 HP."
	pool.append(big)

	var fast = CardClass.new()
	fast.card_name = "FAST"
	fast.card_type = CardClass.CardType.ADJECTIVE
	fast.energy_cost = 1
	fast.effect_value = 3
	fast.card_description = "All field animals gain +3 ATK."
	pool.append(fast)

	var tough = CardClass.new()
	tough.card_name = "TOUGH"
	tough.card_type = CardClass.CardType.ADJECTIVE
	tough.energy_cost = 1
	tough.effect_value = 6
	tough.card_description = "All field animals gain +6 HP."
	pool.append(tough)

	var sharp = CardClass.new()
	sharp.card_name = "SHARP"
	sharp.card_type = CardClass.CardType.ADJECTIVE
	sharp.energy_cost = 1
	sharp.effect_value = 4
	sharp.card_description = "All field animals gain +4 ATK."
	pool.append(sharp)

	var smart = CardClass.new()
	smart.card_name = "SMART"
	smart.card_type = CardClass.CardType.ADJECTIVE
	smart.energy_cost = 1
	smart.effect_value = 2
	smart.card_description = "Draw 2 cards."
	pool.append(smart)

	var magic = CardClass.new()
	magic.card_name = "MAGIC"
	magic.card_type = CardClass.CardType.ADJECTIVE
	magic.energy_cost = 1
	magic.effect_value = 8
	magic.card_description = "Gain 8 Block."
	pool.append(magic)

	return pool

static func get_attacks() -> Array:
	var pool: Array = []

	var scratch = CardClass.new()
	scratch.card_name = "Scratch"
	scratch.card_type = CardClass.CardType.ATTACK
	scratch.energy_cost = 1
	scratch.effect_value = 6
	scratch.card_description = "Deal 6 damage."
	pool.append(scratch)

	var bite = CardClass.new()
	bite.card_name = "Bite"
	bite.card_type = CardClass.CardType.ATTACK
	bite.energy_cost = 1
	bite.effect_value = 8
	bite.card_description = "Deal 8 damage."
	pool.append(bite)

	var dash = CardClass.new()
	dash.card_name = "Dash"
	dash.card_type = CardClass.CardType.ATTACK
	dash.energy_cost = 1
	dash.effect_value = 4
	dash.card_description = "Deal 4 damage. Draw 1 card."
	pool.append(dash)

	var pounce = CardClass.new()
	pounce.card_name = "Pounce"
	pounce.card_type = CardClass.CardType.ATTACK
	pounce.energy_cost = 1
	pounce.effect_value = 8
	pounce.card_description = "Deal 8 damage."
	pool.append(pounce)

	var roar = CardClass.new()
	roar.card_name = "Roar"
	roar.card_type = CardClass.CardType.ATTACK
	roar.energy_cost = 2
	roar.effect_value = 14
	roar.card_description = "Deal 14 damage."
	pool.append(roar)

	return pool

static func get_skills() -> Array:
	var pool: Array = []

	var hide = CardClass.new()
	hide.card_name = "Hide"
	hide.card_type = CardClass.CardType.SKILL
	hide.energy_cost = 1
	hide.effect_value = 5
	hide.card_description = "Gain 5 Block."
	pool.append(hide)

	var run_away = CardClass.new()
	run_away.card_name = "Run Away"
	run_away.card_type = CardClass.CardType.SKILL
	run_away.energy_cost = 1
	run_away.effect_value = 2
	run_away.card_description = "Draw 1 card."
	pool.append(run_away)

	var block_card = CardClass.new()
	block_card.card_name = "Block"
	block_card.card_type = CardClass.CardType.SKILL
	block_card.energy_cost = 1
	block_card.effect_value = 8
	block_card.card_description = "Gain 8 Block."
	pool.append(block_card)

	var curl_up = CardClass.new()
	curl_up.card_name = "Curl Up"
	curl_up.card_type = CardClass.CardType.SKILL
	curl_up.energy_cost = 1
	curl_up.effect_value = 8
	curl_up.card_description = "Gain 8 Block."
	pool.append(curl_up)

	var guard = CardClass.new()
	guard.card_name = "Guard"
	guard.card_type = CardClass.CardType.SKILL
	guard.energy_cost = 2
	guard.effect_value = 15
	guard.card_description = "Gain 15 Block."
	pool.append(guard)

	var scout = CardClass.new()
	scout.card_name = "Scout"
	scout.card_type = CardClass.CardType.SKILL
	scout.energy_cost = 1
	scout.effect_value = 1
	scout.card_description = "Gain 1 Block. Draw 1 card."
	pool.append(scout)

	var sneak = CardClass.new()
	sneak.card_name = "Sneak"
	sneak.card_type = CardClass.CardType.SKILL
	sneak.energy_cost = 1
	sneak.effect_value = 4
	sneak.card_description = "Gain 4 Block. Draw 1 card."
	pool.append(sneak)

	return pool
