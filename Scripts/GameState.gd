extends Node

# Persists data between scenes (e.g., which starter the player chose).
var selected_starter: String = ""
var reward_cards: Array = []
var encounter_number: int = 1
var current_node: int = 0
var nodes_completed: Array = []
var player_hp: int = 50
var relics: Array = []
var last_mob_name: String = ""
var is_boss_fight: bool = false
var gold: int = 0


func reset_run():
	selected_starter  = ""
	reward_cards      = []
	relics            = []
	player_hp         = 50
	encounter_number  = 1
	nodes_completed   = []
	current_node      = 0
	last_mob_name     = ""
	is_boss_fight     = false
	gold              = 0
