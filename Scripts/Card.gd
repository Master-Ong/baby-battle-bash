# Card.gd
# ------------------------------------------------------------------
# What is a "Resource" in Godot?
#
# A Resource is a special Godot object designed to HOLD DATA.
# Think of it like a blank form you fill out. Every card in your
# game is one filled-out copy of this form.
#
# Why use a Resource instead of a plain variable?
#   - You can create as many cards as you want, each with different
#     values, all sharing the same structure.
#   - Resources can be saved to disk as .tres files later.
#   - Godot knows how to pass them around between scripts safely.
#
# "extends Resource" means: "this script IS a Resource".
# Godot gives us all the Resource superpowers automatically.
# ------------------------------------------------------------------
extends Resource

# --- What is a variable? ---
# A variable is a named box that holds a value.
# "var card_name: String" means:
#   - "var"      → create a variable
#   - "card_name" → that's its name (how we refer to it)
#   - ": String" → it must hold text (a String), not a number or anything else
#
# The value after "=" is what the variable starts as before we change it.

## The name printed on the card (e.g. "Strike", "Defend")
var card_name: String = ""

# --- What is an enum? ---
# An enum is a list of named options. Instead of using numbers (0, 1, 2)
# to mean Attack/Skill/Power — which is easy to forget — we give each
# option a readable name. Godot turns them into numbers internally.
enum CardType { ATTACK, SKILL, ANIMAL, COLOR, WORD, ADJECTIVE }

## Which category this card belongs to
var card_type: CardType = CardType.ATTACK

## How much energy it costs to play this card
var energy_cost: int = 1      # "int" means a whole number (integer), no decimals

## The main number the card uses (damage dealt, or block gained, etc.)
var effect_value: int = 0

## A short sentence describing what the card does
var card_description: String = ""

## The artwork shown on the card face (optional — can be left empty for now)
## Texture2D is Godot's type for images
var card_art: Texture2D = null   # "null" means "nothing assigned yet"

## Animal-specific stats (only used when card_type == CardType.ANIMAL)
var animal_hp: int       = 10
var animal_atk: int      = 5
var animal_defense: int  = 0
var is_on_field: bool    = false


# --- What is a function? ---
# A function is a named set of instructions you can run whenever you want.
# You define it once, then call it by name anywhere in your project.
#
# "func get_description() -> String:" means:
#   - "func"            → we are creating a function
#   - "get_description" → its name
#   - "()"              → it takes no inputs
#   - "-> String"       → it will RETURN a piece of text when finished
#
# "return" sends the value back to whoever called the function.

## Returns a human-readable summary of this card for debug printing
func get_description() -> String:
	# The "+" operator joins (concatenates) strings together into one.
	# str(energy_cost) converts the number into text so we can join it.
	# str(effect_value) does the same for the effect number.
	return card_name + " [Cost: " + str(energy_cost) + "] — " + card_description
