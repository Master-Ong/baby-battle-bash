# gamer_manager_node.gd
# ------------------------------------------------------------------
# The brain of every combat encounter.
# Tracks player health, cards, energy, turn order, mob state,
# field animals, and spawns/manages visual card nodes on screen.
# ------------------------------------------------------------------
extends Node


# =====================================================================
# PRELOADS — files Godot loads before the game starts
# =====================================================================

const CardClass   = preload("res://Scripts/Card.gd")
const CardScene   = preload("res://Scene/card.tscn")
const RewardScene = preload("res://Scene/reward_screen.tscn")
const LoseScene   = preload("res://Scene/lose_screen.tscn")


# =====================================================================
# SECTION 1 — GAME STATE
# =====================================================================
var current_turn: int         = 0
var player_hp: int            = 50
var player_defense: int       = 0
var _opening_hand_dealt: bool = false   # ensures the turn-1 guarantee only fires once


# =====================================================================
# SECTION 2 — ENERGY
# =====================================================================
var max_energy: int     = 3
var current_energy: int = 3


# =====================================================================
# SECTION 3 — CARD PILES (data)
# =====================================================================
var deck:         Array = []
var hand:         Array = []
var graveyard:    Array = []
var played_cards: Array = []


# =====================================================================
# SECTION 4 — VISUAL CARD NODES
# =====================================================================
var hand_visuals:  Array = []
var field_visuals: Array = []


# =====================================================================
# SECTION 5 — MOB STATE
# =====================================================================
var mob_hp: int        = 0
var mob_max_hp: int    = 0
var mob_name: String   = ""
var mob_damage: int    = 0


# =====================================================================
# SECTION 6 — FIELD
# =====================================================================
var field_slots: Dictionary = { 0: null, 1: null, 2: null }
var max_field_slots: int    = 3


# =====================================================================
# SECTION 7 — TURN PHASES
# =====================================================================
enum Phase { DRAW, PLAYER_TURN, ENEMY_TURN, END_TURN }
var current_phase: Phase  = Phase.DRAW
var combat_ended: bool    = false


# =====================================================================
# SECTION 7b — FIELD HELPERS
# =====================================================================

func get_field_animals() -> Array:
	var result = []
	for i in field_slots:
		if field_slots[i] != null:
			result.append(field_slots[i])
	return result


func get_empty_slot() -> int:
	for i in field_slots:
		if field_slots[i] == null:
			return i
	return -1


func is_slot_empty(slot_index: int) -> bool:
	return field_slots[slot_index] == null


# =====================================================================
# SECTION 7c — MOB DATA LOADER
# =====================================================================
func load_mob_data():
	combat_ended = false
	match GameState.encounter_number:
		1:
			mob_name   = "Mr. Kiwi"
			mob_hp     = 40
			mob_max_hp = 40
			mob_damage = 10
		2:
			mob_name   = "Big Bear"
			mob_hp     = 65
			mob_max_hp = 65
			mob_damage = 14
		3:
			mob_name   = "Swift Fox"
			mob_hp     = 30
			mob_max_hp = 30
			mob_damage = 8
		4:
			mob_name   = "Stone Turtle"
			mob_hp     = 90
			mob_max_hp = 90
			mob_damage = 6
		_:
			mob_name   = "Stone Turtle"
			mob_hp     = 90
			mob_max_hp = 90
			mob_damage = 6


# =====================================================================
# SECTION 8 — _ready()
# =====================================================================
func _ready():
	if GameState.player_hp > 0:
		player_hp = GameState.player_hp
	else:
		player_hp = 50
		GameState.player_hp = 50
	_set_positions()
	load_mob_data()
	field_slots = {0: null, 1: null, 2: null}
	spawn_field_visuals()
	build_starting_deck()

	randomize()
	deck.shuffle()

	print("=== Baby Battle Bash — Combat Start ===")
	print("Deck built and shuffled. Total cards: ", deck.size())
	print("CardType enum values — ATTACK: ", CardClass.CardType.ATTACK, " SKILL: ", CardClass.CardType.SKILL, " ANIMAL: ", CardClass.CardType.ANIMAL)

	start_turn()


# =====================================================================
# SECTION 9 — _set_positions()
# =====================================================================
func _set_positions():
	var root = get_tree().root.get_node("CombatScene")

	# DG_Node2D at world origin so deck/graveyard positions are in pure world coords.
	root.get_node("DG_Node2D").position = Vector2(0, 0)

	# Mob at top center of screen.
	root.get_node("MobContainerNode2D").position = Vector2(0, -180)

	# Field slots — reset PlayerField_Node2D to origin first so CardSlot
	# local positions equal their world positions directly.
	root.get_node("PlayerField_Node2D").position = Vector2(0, 0)
	root.get_node("PlayerField_Node2D/CardSlot2_Area2D").position = Vector2(0, 80)
	root.get_node("PlayerField_Node2D/CardSlot1_Area2D").position = Vector2(-200, 80)
	root.get_node("PlayerField_Node2D/CardSlot3_Area2D").position = Vector2(200, 80)

	# Hand zone below field slots.
	root.get_node("HandZone_Area2D").position = Vector2(0, 280)


# =====================================================================
# SECTION 10 — HUD (Heads-Up Display)
# =====================================================================
func update_hud():
	GameState.player_hp = player_hp
	var root = get_tree().root.get_node("CombatScene")

	root.get_node("CanvasLayer/HUDRoot/PlayerHUD/PlayerStatsVBox/PlayerHPLabel").text = "HP: " + str(player_hp)
	root.get_node("CanvasLayer/HUDRoot/PlayerHUD/PlayerStatsVBox/EnergyLabel").text   = str(current_energy) + "/" + str(max_energy) + " Energy"
	var block_label = root.get_node("CanvasLayer/HUDRoot/PlayerHUD/PlayerStatsVBox/BlockLabel")
	if player_defense > 0:
		block_label.text    = "Block: " + str(player_defense)
		block_label.visible = true
	else:
		block_label.visible = false
	var relic_text = "Relics: " + ", ".join(GameState.relics) if GameState.relics.size() > 0 else "Relics: None"
	root.get_node("CanvasLayer/HUDRoot/PlayerHUD/PlayerStatsVBox/RelicLabel").text    = relic_text
	root.get_node("CanvasLayer/HUDRoot/MobHUD/MobStatsVBox/MobNameLabel").text        = mob_name
	root.get_node("CanvasLayer/HUDRoot/MobHUD/MobStatsVBox/MobHPLabel").text          = "HP: " + str(mob_hp) + "/" + str(mob_max_hp)
	root.get_node("CanvasLayer/HUDRoot/MobHUD/MobStatsVBox/MobATKLabel").text         = "ATK: " + str(mob_damage)
	root.get_node("CanvasLayer/HUDRoot/BottomLeftHUD/DeckLabel").text                  = "Deck: " + str(deck.size())
	root.get_node("CanvasLayer/HUDRoot/BottomRightHUD/GraveyardLabel").text            = "GY: " + str(graveyard.size())


# =====================================================================
# SECTION 11 — STARTING DECK
# =====================================================================
# TODO: expand these starters as the game grows
func build_starting_deck():
	deck.clear()
	match GameState.selected_starter:
		"Turtle":
			_build_turtle_deck()
		"Dog":
			_build_dog_deck()
		_:
			_build_bunny_deck()
	for card in GameState.reward_cards:
		deck.append(card)
	if GameState.reward_cards.size() > 0:
		print("Added ", GameState.reward_cards.size(), " reward cards to deck.")


func _build_bunny_deck():
	for i in 10:
		var strike = CardClass.new()
		strike.card_name = "Strike"
		strike.card_type = CardClass.CardType.ATTACK
		strike.energy_cost = 1
		strike.effect_value = 6
		strike.card_description = "Deal 6 damage."
		deck.append(strike)
	for i in 4:
		var defend = CardClass.new()
		defend.card_name = "Defend"
		defend.card_type = CardClass.CardType.SKILL
		defend.energy_cost = 1
		defend.effect_value = 5
		defend.card_description = "Gain 5 Block."
		deck.append(defend)
	for i in 3:
		var bunny = CardClass.new()
		bunny.card_name = "Bunny"
		bunny.card_type = CardClass.CardType.ANIMAL
		bunny.energy_cost = 0
		bunny.animal_hp = 12
		bunny.animal_atk = 4
		bunny.animal_defense = 2
		bunny.card_description = "ATK: 4 | HP: 12"
		deck.append(bunny)
	print("Deck built: Bunny starter")


func _build_turtle_deck():
	for i in 10:
		var strike = CardClass.new()
		strike.card_name = "Strike"
		strike.card_type = CardClass.CardType.ATTACK
		strike.energy_cost = 1
		strike.effect_value = 6
		strike.card_description = "Deal 6 damage."
		deck.append(strike)
	for i in 4:
		var defend = CardClass.new()
		defend.card_name = "Defend"
		defend.card_type = CardClass.CardType.SKILL
		defend.energy_cost = 1
		defend.effect_value = 5
		defend.card_description = "Gain 5 Block."
		deck.append(defend)
	for i in 3:
		var turtle = CardClass.new()
		turtle.card_name = "Turtle"
		turtle.card_type = CardClass.CardType.ANIMAL
		turtle.energy_cost = 0
		turtle.animal_hp = 20
		turtle.animal_atk = 2
		turtle.animal_defense = 5
		turtle.card_description = "ATK: 2 | HP: 20"
		deck.append(turtle)
	print("Deck built: Turtle starter")


func _build_dog_deck():
	for i in 10:
		var strike = CardClass.new()
		strike.card_name = "Strike"
		strike.card_type = CardClass.CardType.ATTACK
		strike.energy_cost = 1
		strike.effect_value = 6
		strike.card_description = "Deal 6 damage."
		deck.append(strike)
	for i in 4:
		var defend = CardClass.new()
		defend.card_name = "Defend"
		defend.card_type = CardClass.CardType.SKILL
		defend.energy_cost = 1
		defend.effect_value = 5
		defend.card_description = "Gain 5 Block."
		deck.append(defend)
	for i in 3:
		var dog = CardClass.new()
		dog.card_name = "Dog"
		dog.card_type = CardClass.CardType.ANIMAL
		dog.energy_cost = 0
		dog.animal_hp = 10
		dog.animal_atk = 8
		dog.animal_defense = 1
		dog.card_description = "ATK: 8 | HP: 10"
		deck.append(dog)
	print("Deck built: Dog starter")
# SECTION 12 — TURN FLOW
# =====================================================================

func start_turn():
	current_turn   += 1
	current_energy  = max_energy
	current_phase   = Phase.DRAW

	print("")
	print("--- Turn ", current_turn, " | Energy: ", current_energy, "/", max_energy, " ---")

	draw_cards(5)

	if current_turn == 1 and GameState.relics.has("Bandage Roll"):
		player_defense += 5
		print("Bandage Roll: started combat with 5 Block")
		update_hud()

	update_hud()


func end_turn():
	current_phase  = Phase.ENEMY_TURN
	player_defense = 0

	resolve_combat()


func discard_hand():
	for card in hand:
		graveyard.append(card)
	hand.clear()
	clear_hand_visuals()
	print("Hand discarded. Graveyard size: ", graveyard.size())


# =====================================================================
# SECTION 13 — DRAWING CARDS
# =====================================================================

# Draws up to `amount` cards. If the deck empties mid-draw, shuffles
# the graveyard back in and continues until the hand reaches `amount`
# or both deck and graveyard are exhausted.
func draw_cards(amount: int):
	var drawn = 0
	while drawn < amount:
		if deck.is_empty():
			if graveyard.is_empty():
				print("No cards left to draw!")
				break
			refill_deck_from_graveyard()
		if hand.size() >= 10:
			print("Hand is full! (10 card maximum)")
			break
		var card = deck.pop_front()
		hand.append(card)
		drawn += 1
		print("  Drew: ", card.get_description())

	# Opening hand guarantee — turn 1 only, fires exactly once.
	# If fewer than 2 animal cards ended up in hand, swap non-animals from
	# the back of the hand with animals from the deck until we have 2 or
	# no more animals remain in the deck.
	if current_turn == 1 and not _opening_hand_dealt:
		_opening_hand_dealt = true
		var animals_in_hand = 0
		for card in hand:
			if card.card_type == CardClass.CardType.ANIMAL:
				animals_in_hand += 1

		while animals_in_hand < 2:
			# Find the first animal still in the deck
			var animal_idx = -1
			for i in deck.size():
				if deck[i].card_type == CardClass.CardType.ANIMAL:
					animal_idx = i
					break
			if animal_idx == -1:
				print("  Opening hand: no more animals in deck to guarantee.")
				break

			# Find a non-animal at the back of the hand to swap out
			var swap_idx = -1
			for i in range(hand.size() - 1, -1, -1):
				if hand[i].card_type != CardClass.CardType.ANIMAL:
					swap_idx = i
					break
			if swap_idx == -1:
				print("  Opening hand: hand is already all animals.")
				break

			# Swap
			var animal_card     = deck[animal_idx]
			var non_animal_card = hand[swap_idx]
			deck.remove_at(animal_idx)
			hand.remove_at(swap_idx)
			hand.append(animal_card)
			deck.append(non_animal_card)
			animals_in_hand += 1
			print("  Opening hand guarantee: swapped ", non_animal_card.card_name,
				  " → ", animal_card.card_name)

	current_phase = Phase.PLAYER_TURN
	print("Hand size: ", hand.size(), " | Deck remaining: ", deck.size())
	spawn_hand_visuals()


func refill_deck_from_graveyard():
	print("Deck empty — shuffling graveyard back in.")
	deck = graveyard.duplicate()
	deck.shuffle()
	graveyard.clear()


# =====================================================================
# SECTION 14 — VISUAL CARD SPAWNING (HAND)
# =====================================================================

# Spawns one card visual per card in hand, fixed at the five hand slots.
# Cards are spaced evenly relative to HandZone center (world space).
# X: -220, -110, 0, 110, 220 — Y: 0 (cards sit at HandZone origin).
func spawn_hand_visuals():
	clear_hand_visuals()

	var hand_zone   = get_tree().root.get_node("CombatScene/HandZone_Area2D")
	var x_positions = [-220, -110, 0, 110, 220]

	for i in min(hand.size(), x_positions.size()):
		var card_node = CardScene.instantiate()
		hand_zone.add_child(card_node)
		card_node.setup(hand[i])
		card_node.position = Vector2(x_positions[i], -80)
		hand_visuals.append(card_node)

	print("Spawned ", hand_visuals.size(), " card visuals.")


func clear_hand_visuals():
	for visual in hand_visuals:
		visual.queue_free()
	hand_visuals.clear()


# =====================================================================
# SECTION 15 — VISUAL CARD SPAWNING (FIELD)
# =====================================================================

# Spawns one card visual per animal on the field.
# Cards are children of PlayerField_Node2D in world space.
# Slot 0 → Vector2(-200, 0), Slot 1 → Vector2(0, 0), Slot 2 → Vector2(200, 0).
func spawn_field_visuals():
	for visual in field_visuals:
		visual.queue_free()
	field_visuals.clear()

	# Clear any card visuals that were reparented into CardSlot nodes during drag-drop.
	# Permanent slot children (CollisionShape2D, Panel) are preserved; only dynamic card nodes are freed.
	var root = get_tree().root.get_node("CombatScene")
	for slot_node in [
		root.get_node("PlayerField_Node2D/CardSlot1_Area2D"),
		root.get_node("PlayerField_Node2D/CardSlot2_Area2D"),
		root.get_node("PlayerField_Node2D/CardSlot3_Area2D"),
	]:
		for child in slot_node.get_children():
			if not (child is CollisionShape2D or child is Panel):
				child.queue_free()

	var slot_nodes = {
		0: root.get_node("PlayerField_Node2D/CardSlot1_Area2D"),
		1: root.get_node("PlayerField_Node2D/CardSlot2_Area2D"),
		2: root.get_node("PlayerField_Node2D/CardSlot3_Area2D"),
	}

	for slot_key in field_slots:
		if field_slots[slot_key] != null:
			var card_node = CardScene.instantiate()
			slot_nodes[slot_key].add_child(card_node)
			card_node.setup(field_slots[slot_key])
			card_node.position = Vector2(-60, -80)
			field_visuals.append(card_node)


# =====================================================================
# SECTION 16 — ENERGY
# =====================================================================

func can_play_card(card) -> bool:
	return current_energy >= card.energy_cost


func spend_energy(amount: int):
	current_energy -= amount
	print("Energy spent: ", amount, " | Remaining: ", current_energy, "/", max_energy)
	update_hud()


# =====================================================================
# SECTION 17 — PLAYING CARDS
# =====================================================================

# Play an animal card to a specific field slot. No energy cost.
# card_visual is reparented to the target slot by card_display.gd — do not free it here.
func play_animal_card(card, card_visual, slot_index: int):
	if field_slots[slot_index] != null:
		print("Slot ", slot_index, " is occupied")
		return
	field_slots[slot_index] = card
	card.is_on_field = true
	hand.erase(card)
	hand_visuals.erase(card_visual)
	update_hud()


# Play an attack card: spend energy, deal effect_value damage to mob, send to graveyard.
func play_attack_card(card, card_visual):
	if not can_play_card(card):
		print("Not enough energy")
		return
	spend_energy(card.energy_cost)
	take_mob_damage(card.effect_value)
	graveyard.append(card)
	hand.erase(card)
	hand_visuals.erase(card_visual)
	card_visual.queue_free()
	update_hud()
	check_combat_outcome()


# Play a skill card: spend energy, apply effect, send to graveyard.
func play_skill_card(card, card_visual):
	if not can_play_card(card):
		print("Not enough energy")
		return
	spend_energy(card.energy_cost)
	graveyard.append(card)
	hand.erase(card)
	hand_visuals.erase(card_visual)
	card_visual.queue_free()
	if card.card_name == "Run Away":
		draw_cards(1)
		update_hud()
	else:
		player_defense += card.effect_value
		print("Gained " + str(card.effect_value) + " block")
		update_hud()


# Play a color or word card: spend energy, apply effect, send to graveyard.
func play_color_or_word_card(card, card_visual):
	if not can_play_card(card):
		print("Not enough energy")
		return
	spend_energy(card.energy_cost)
	graveyard.append(card)
	hand.erase(card)
	hand_visuals.erase(card_visual)
	card_visual.queue_free()
	if card.card_name == "Blue":
		draw_cards(1)
		update_hud()
	elif card.card_name == "Green":
		player_hp = min(player_hp + card.effect_value, 50)
		print("Healed ", card.effect_value, " HP — HP: ", player_hp)
		update_hud()
	elif card.card_name == "BIG":
		for animal in get_field_animals():
			animal.animal_atk += 5
			animal.animal_hp += 5
		spawn_field_visuals()
		update_hud()
	elif card.card_name == "FAST":
		for animal in get_field_animals():
			animal.animal_atk += 3
		spawn_field_visuals()
		update_hud()
	elif card.card_name == "TOUGH":
		for animal in get_field_animals():
			animal.animal_hp += 6
		spawn_field_visuals()
		update_hud()
	else:
		for animal in get_field_animals():
			animal.animal_atk += card.effect_value
		spawn_field_visuals()
		update_hud()


# =====================================================================
# SECTION 18 — COMBAT RESOLUTION
# =====================================================================

func check_combat_outcome():
	if player_hp <= 0:
		lose_combat()
	elif mob_hp <= 0:
		win_combat()


func take_mob_damage(amount: int):
	mob_hp -= amount
	mob_hp  = max(mob_hp, 0)
	update_hud()
	print("Mob takes ", amount, " damage — HP: ", mob_hp, "/", mob_max_hp)


func win_combat():
	if combat_ended:
		return
	combat_ended = true
	print("You defeated ", mob_name, "!")

	# Spawn the reward screen — it builds its own pools and picks 3 cards
	var reward = RewardScene.instantiate()
	get_tree().root.get_node("CombatScene").add_child(reward)
	reward.pick_rewards()

	get_tree().paused = true


func lose_combat():
	if combat_ended:
		return
	combat_ended = true
	print("You were defeated!")
	var lose_screen = LoseScene.instantiate()
	get_tree().root.add_child(lose_screen)
	get_tree().paused = true


func take_player_damage(amount: int):
	var blocked   = min(player_defense, amount)
	var remainder = amount - blocked
	player_defense = 0
	player_hp -= remainder
	player_hp  = max(player_hp, 0)
	GameState.player_hp = player_hp
	update_hud()
	print("Player takes ", remainder, " damage (", blocked, " blocked) — HP: ", player_hp)


# Combat sequence called at the end of each player turn:
#   1. Each field animal attacks the mob.
#   2. Mob attacks each field animal for mob_damage; defeated animals go to graveyard
#      and their slot is set to null.
#   3. If all slots are null after mob attacks, the mob hits the player.
#   4. Refresh field visuals, discard hand, draw 5 new cards.
func resolve_combat():
	# 1. Animals attack mob
	for i in field_slots:
		if field_slots[i] != null:
			take_mob_damage(field_slots[i].animal_atk)

	# 2. Mob attacks each animal
	for i in field_slots:
		if field_slots[i] != null:
			var animal = field_slots[i]
			animal.animal_hp -= mob_damage
			print(animal.card_name, " takes ", mob_damage, " — HP: ", animal.animal_hp)
			if animal.animal_hp <= 0:
				graveyard.append(animal)
				field_slots[i] = null
				print(animal.card_name, " was defeated and sent to graveyard.")

	# 3. No animals left = mob damages player
	var all_empty = true
	for i in field_slots:
		if field_slots[i] != null:
			all_empty = false
			break
	if all_empty:
		take_player_damage(mob_damage)

	# --- Terminal outcome check (defeat wins ties) ---
	check_combat_outcome()
	if combat_ended:
		return

	# 4. Refresh field, discard hand, start the next turn
	spawn_field_visuals()
	update_hud()
	discard_hand()
	start_turn()
