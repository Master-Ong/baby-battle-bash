extends Node

# Persists data between scenes (e.g., which starter the player chose).
var selected_starter: String = ""
var reward_cards: Array = []
var encounter_number: int = 1
var current_node: int = 0
var nodes_completed: Array = []
var player_hp: int = 50
var relics: Array = []
