# CLAUDE.md — Baby Battle Bash Project Rules
# Claude Code reads this file automatically at startup.
# Last updated: April 2026

---

## Project Identity

- Game: Baby Battle Bash
- Engine: Godot 4 (version 4.6.2 stable)
- Genre: 2D Card Deckbuilding Roguelike
- Project path: C:\Users\Nicky\Documents\baby-battle-bash
- Developer: Nicky (creative director) + Friend (technical lead)
- Workflow: Claude.ai plans → Claude Code builds

---

## First Thing Every Session

Use godot-mcp to read the current scene tree before making any changes.
Never assume node names — always verify them first.
Never assume file contents — always read the file before editing it.

---

## Coordinate System Rules

This is the most common source of bugs. Follow these exactly.

### CanvasLayer (screen space)
- Origin is TOP-LEFT corner of screen (0, 0)
- Used for: HP label, Energy label, Mob name/HP labels, Deck label, Graveyard label, End Turn button
- Positions use offset_left and offset_top
- These elements never move with the camera

### Node2D (world space)
- Origin is CENTER of screen (0, 0)
- Left edge X=-576, Right edge X=576, Top Y=-324, Bottom Y=324
- Used for: HandZone_Area2D, PlayerField_Node2D, CardSlots, MobContainerNode2D, DG_Node2D, all panels
- These elements exist in the game world

### During drag and drop
- Always use get_global_mouse_position() — never get_local_mouse_position()
- Always use global_position when moving a dragged card
- For slot detection use Rect2.has_point() on SlotPanel.get_global_rect() — never use overlaps_area() during drag as it requires a physics frame
- Use _input_event for press detection, _unhandled_input for release detection

---

## Scene Structure

```
CombatScene (Node2D root — position must always be Vector2(0,0), never offset)
├── Camera2D (fixed, position smoothing OFF)
├── MobZonePanel (Panel, world space, 130x170, centered above field)
├── FieldZonePanel (Panel, world space, behind field slots)
├── HandZone_Area2D (Node2D world space, set by _set_positions() at runtime)
│   └── Hand_CollisionShape2D
├── DG_Node2D (Deck and Graveyard container)
│   ├── Deck_TextureRect
│   ├── Graveyard
│   ├── DeckZone (Area2D with CollisionShape2D and DeckPanel child)
│   └── GraveyardZone (Area2D with CollisionShape2D and GraveyardPanel child)
├── PlayerField_Node2D (3 card slots)
│   ├── CardSlot1_Area2D (with Slot1Collision and SlotPanel1)
│   ├── CardSlot2_Area2D (CENTER ANCHOR at X=0 — everything mirrors from here)
│   └── CardSlot3_Area2D (with Slot3Collision and SlotPanel3)
├── MobContainerNode2D (mob sprite goes here — swap per encounter)
├── CanvasLayer (layer 1 — all UI labels and buttons live here)
│   ├── PlayerHPLabel (20, 20) font 16
│   ├── EnergyLabel (220, 20) font 16
│   ├── MobNameLabel (476, 20) font 16
│   ├── MobHPLabel (476, 44) font 13
│   ├── DeckLabel (24, 615) font 13
│   ├── GraveyardLabel (1012, 612) font 13
│   └── EndTurnButton (972, 530) size 160x36
└── GamerManager_Node (plain Node, game brain script)
```

---

## Card Scene Structure (res://Scene/card.tscn)

```
Card (Area2D root — card_display.gd attached)
├── CardCollision (CollisionShape2D, RectangleShape2D 120x160)
├── CardBackground (Panel 120x160)
├── CardName (Label position 8,8 size 104x24 font 14)
├── CardCost (Label position 88,8 size 24x24 font 14)
├── CardType (Label position 8,64 size 104x20 font 11)
└── CardDescription (Label position 8,90 size 104x60 font 11)
```

---

## Card Type Rules

| Type | On Click/Drop | Energy Cost | Destination |
|------|--------------|-------------|-------------|
| ANIMAL | Drag to field slot | 0 — FREE | Stays on field until defeated |
| ATTACK | Single click | 1 | Deals damage to mob, goes to graveyard |
| SKILL | Single click | 1 | Gives player defense, goes to graveyard |
| COLOR | Single click | 1 | Buffs all field animals ATK, goes to graveyard |
| WORD | Single click | 1 | Buffs all field animals ATK, goes to graveyard |

---

## Combat Flow Rules

Turn order every End Turn:
1. Each field animal attacks mob — take_mob_damage(animal.animal_atk)
2. Mob attacks each field animal — animal.animal_hp -= mob_damage
3. Dead animals removed from field_animals, sent to graveyard
4. If field is empty after mob attacks — take_player_damage(mob_damage)
5. spawn_field_visuals() to refresh display
6. discard_hand() — all hand cards go to graveyard
7. draw_cards(5) — draw new hand

Energy resets to max_energy at start of each turn.
Defense resets to 0 at start of enemy turn.
Defense absorbs damage before HP.
Block does NOT carry over between turns.

---

## Starting Deck Composition

- 10 Strike cards (ATTACK, cost 1, deal 6 damage)
- 4 Defend cards (SKILL, cost 1, gain 5 block)
- 3 Bunny cards (ANIMAL, cost 0, ATK 4, HP 12, DEF 2)
- Total: 17 cards
- Opening hand guarantee: at least 2 ANIMAL cards on turn 1

---

## Mob State (Current Placeholder)

- mob_name = "Mr. Kiwi"
- mob_hp = 40
- mob_max_hp = 40
- mob_damage = 8 (deals to each field animal per turn)

---

## Key Variables in gamer_manager_node.gd

- player_hp = 50
- player_defense = 0
- max_energy = 3
- current_energy = 3
- deck, hand, graveyard, played_cards (Arrays of Card objects)
- hand_visuals, field_visuals (Arrays of card scene nodes)
- field_animals (Array of Card objects currently on field)
- max_field_slots = 3
- current_turn, current_phase

---

## Critical Rules — Never Break These

1. CombatScene root Node2D position must always be Vector2(0,0). Never offset it. Editor drift causes all world positions to shift.
2. Cards use Area2D not CharacterBody2D — they detect mouse input not physics collisions.
3. MobContainerNode2D is the ONLY node swapped between encounters. Everything else is reused.
4. When drag and drop places a card in a slot — remove spawn_field_visuals() call from play_animal_card(). The card visual places itself.
5. Use create_tween() for all animations — never the old Tween node.
6. Hand cap is 10 cards maximum.
7. Graveyard shuffles back into deck when deck runs empty mid-draw.
8. No shirk in game lore — no false gods, idol worship, or polytheistic themes.

---

## Tween Syntax (Godot 4)

Always use this pattern:
```gdscript
var tween = create_tween()
tween.tween_property(node, "global_position", target_position, duration)
```

Never use the old $Tween node — it does not exist in Godot 4.

---

## HUD Update Pattern

Always call update_hud() after any change to:
- player_hp
- player_defense
- current_energy
- mob_hp
- deck.size()
- graveyard.size()

---

## File Locations

- res://Scripts/Card.gd — card data blueprint
- res://Scripts/gamer_manager_node.gd — game brain
- res://Scripts/card_display.gd — card visual and interaction
- res://Scene/combat_scene.tscn — main combat scene
- res://Scene/card.tscn — single card visual scene
- C:\Users\Nicky\Documents\baby-battle-bash\assets\sprites\ — all art files

---

## MCP Servers Available

- godot-mcp — read scene tree, modify nodes live in Godot editor
- filesystem — read and write project files
- memory — store and recall session notes
- memory-keeper — persistent project memory across sessions
- thinking — use for complex problems before writing code

Always use godot-mcp to verify scene tree before editing tscn files.
Always use thinking for complex multi-system changes.

---

## Art Style Reference

- Style: Chibi pixel art with children's storybook warmth
- Colors: Soft pastels, warm tones, nothing harsh or neon
- Characters: Chubby, round, expressive, kid friendly
- Tool: Aseprite with PixelLab AI generation
- Gorilla mob boss seed: 3875616443.0

---

## End of Session Reminder

Before closing Claude Code always save progress to memory:
"Summarize today's progress, current issues, and what to tackle next session. Save to project memory."
