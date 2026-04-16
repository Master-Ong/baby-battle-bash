# Baby Battle Bash — Master Project Document
# This is the single source of truth for the entire project.
# Update this file whenever a major decision is made or a milestone is completed.
# Paste this at the top of any new Claude chat to resume instantly.

---

## Project Identity

- **Game name:** Baby Battle Bash
- **Engine:** Godot 4 (version 4.6.2 stable)
- **Genre:** 2D Card Deckbuilding Roguelike
- **Audience:** All ages — kids learn, adults strategize
- **Project path:** C:\Users\Nicky\Documents\baby-battle-bash
- **Developer:** Nicky (creative director) + Friend (technical lead)
- **Workflow:** Nicky designs with Claude.ai → Claude writes CC prompts → CC builds into Godot

---

## Art Style Direction

### Vision
A blend of chibi pixel art characters set inside a warm children's book world.
The game should feel like you are reading a storybook again as a child —
soft, inviting, easy on the eyes. Not harsh or overly saturated.

### Inspiration
- **Characters:** Chibi pixel art — round, expressive, cute
- **World/backgrounds:** Children's storybook aesthetic (inspired by Eric Carle's warmth and boldness but softer)
- **Color palette:** Warm pastels, muted tones, nothing neon or jarring
- **Feeling:** Cozy, safe, readable at a glance

### Style Rules
- Characters: chubby, round, chibi proportions
- Backgrounds: soft watercolor-like or flat color with texture suggestion
- Colors: desaturated enough to be easy on young eyes, warm enough to feel inviting
- Text on cards: clean, simple, readable at small sizes
- No dark or gritty themes — keep it bright and friendly

### Art Tool
- **Aseprite** with PixelLab AI generation
- Style reference: use previously generated chibi animal frames as reference for all new characters
- Remove background: always ON
- Output: New frames (4 frames per character for animation)
- Export: Sprite sheet PNG or individual PNGs

### Art Generated So Far
- Hamster variants: base (golden), red, blue, green — 4 frames each
- Gorilla mob boss: grey with sunglasses — 4 variants, idle animation with shoulder movement

### Save Location
```
C:\Users\Nicky\Documents\baby-battle-bash\assets\sprites\
```

---

## Technical Specifications

### Resolution
- **Game viewport:** 1152 x 648 (16:9 widescreen)
- **Godot coordinate center:** X=0, Y=0
- Left edge: X=-576 | Right edge: X=576 | Top: Y=-324 | Bottom: Y=324

### Layer System (Placeholder — confirm with friend)
- **Resolution target:** 320x180 base (scaled up)
- **Tile size:** 32x32 pixels
- **Layer order (back to front):**
  - Far background (sky, distant scenery)
  - Mid background (environment details)
  - Foreground (characters, cards, UI elements)

### File Structure
```
res://
├── Scene/
│   ├── combat_scene.tscn       ✓ Built
│   └── card.tscn               ← Next to build
├── Scripts/
│   ├── Card.gd                 ✓ Built (card data blueprint)
│   ├── gamer_manager_node.gd   ✓ Built (game brain)
│   └── card_display.gd         ← Next to build
└── assets/
    └── sprites/                ← Save all art here
```

---

## Game Design Summary

### Core Loop
1. Collect or draft animal cards
2. Modify animals with color cards (permanent for the run)
3. Upgrade with adjective cards for premium power spikes
4. Use verb cards during combat for active turn decisions
5. Evolve animals through stages (Bunny → Rabbit → Fluffle)

### The Four Card Layers

| Layer | Role | Rarity |
|-------|------|--------|
| Animal | The body — stats and stage identity | Most common |
| Color | Passive role modifier — permanent transformation | Common to Uncommon |
| Adjective | Premium modifier — redefines card identity | Slightly rarer than colors |
| Verb | Action card played each turn — the engine | Spread across all rarities |

### Turn Flow (Slay the Spire style)
- Draw 5 cards → Play cards → Enemy attacks → End turn → Repeat
- Energy: starts at 3, resets each turn
- Block/defense does NOT carry over between turns
- Hand cap: 10 cards maximum

### Rock-Paper-Scissors Type System
- Power beats Defense
- Defense beats Speed
- Speed beats Power
- Small edges, not hard counters

### Rarity
- Common 32% | Uncommon 26% | Rare 22% | Epic 12% | Mythic 8%
- 3 cards per reward group

### Two Balance Modes (One Card Pool)
- **Kid mode:** Flat numbers, simple one-line effects, easy to read
- **Advanced mode:** Percentages, conditions, scaling, multi-card sequencing

---

## Animal Roster

### Speed Animals
Rabbit / Deer / Cat / Frog / Fox
Fast, draw/tempo, card velocity, evasion, combo turns

### Defense Animals
Turtle / Sheep / Cow / Chicken
High HP, healing, armor, stall, sustain loops

### Power Animals
Lion / Bear / Dog / Crow
Big hits, burst windows, attack multipliers, finishers

---

## Rabbit Family (First Family Designed)

### Bunny — Stage 1
| | Kid | Advanced |
|--|-----|----------|
| HP | 12 | 18 |
| ATK | 4 | 6 |
| DEF | 2 | 3 |
| Passive | Draw 1 when played | Draw 1. If 3+ cards in hand, +1 ATK this turn |

### Rabbit — Stage 2
| | Kid | Advanced |
|--|-----|----------|
| HP | 20 | 30 |
| ATK | 7 | 11 |
| DEF | 4 | 6 |
| Passive | Draw 1. +2 ATK if Verb played this turn | Draw 2. If last card was Verb, +15% ATK and draw again |

### Fluffle — Stage 3 (Merge: 3 Bunnies = 1 Fluffle)
| | Kid | Advanced |
|--|-----|----------|
| HP | 35 | 55 |
| ATK | 12 | 18 |
| DEF | 7 | 11 |
| Passive | Draw 2. All Speed animals +3 ATK | Draw 3. Speed animals +20% ATK. If hand hits 5+, deal 5 to all enemies |

**Merge rules:**
- Costs 0 energy (3 cards sacrificed is the cost)
- Fluffle stays in deck permanently for the rest of the run

### Rabbit Color Variants (Educational Hook)
| Color | Becomes | Real Animal | Passive Change |
|-------|---------|-------------|----------------|
| Blue | Snowshoe Hare | Real — North America | Draw 2 instead of 1 |
| Red | Volcano Rabbit | Real — endangered, Mexico | +4 ATK, loses draw |
| Green | European Hare | Real — Europe | Heal 3 HP when drawn |
| Yellow | Jackrabbit | Real — known for speed | Play extra Verb this turn |
| Purple | Himalayan Rabbit | Real breed | Gain 4 Shield when played |
| White | Angora Rabbit | Real breed | +2 to all stats |

---

## Color Card System

| Color | Effect | Role |
|-------|--------|------|
| Blue | Draw +X | Card velocity, consistency, combo enabling |
| Red | Rage / ATK boost | Aggression, damage conversion |
| Green | Heal +X | Sustain and survival |
| Yellow | Energy / extra actions | Tempo and sequencing |
| Purple | Shield | Protection, trickiness, safer setup turns |
| White | Balanced stat boost | Simple fallback, beginner friendly |

**Key rule:** Color transformation is PERMANENT for the run.

---

## Adjective Card System

| Adjective | Kid | Advanced | Purpose |
|-----------|-----|----------|---------|
| BIG | +5 ATK / +5 HP | +50% HP, premium growth | Dramatic payoff |
| FAST | +3 ATK, Dodge | +25% ATK, evasion | Combo and tempo |
| TOUGH | +6 HP | Heavy survivability | Carry units survive |
| SHARP | +4 ATK | Crit hooks | Clean aggression |
| SMART | Draw +2 | Engine acceleration | Skillful sequencing |
| MAGIC | Shield +2 | Block scaling | Defensive decks |

- Up to 3 adjectives can stack on one card
- 3 adjectives = legendary/mythic territory

---

## Verb Card System

| Category | Cards |
|----------|-------|
| Damage | Scratch, Bite, Pounce, Roar |
| Defense | Hide, Block, Curl Up, Guard |
| Draw/Speed | Run Away, Scout, Dash, Sneak |
| Tempo | Hurry, Swap, Call Friend, Quick Move |
| Magic/Trick | Trick, Confuse, Shield Spell, Copy |

---

## Combat Scene Structure

```
CombatScene              ← Node2D (root)
├── Camera2D             ← Fixed, position smoothing OFF
├── CanvasLayer          ← Layer 1, pins UI to screen always
│   └── HandZone_Area2D  ← Bottom center, where hand displays
│       └── Hand_CollisionShape2D
├── DG_Node2D            ← Deck and Graveyard container
│   ├── Deck_TextureRect ← Bottom left
│   └── Graveyard        ← Bottom right
├── PlayerField_Node2D   ← 3 card slots for played cards
│   ├── CardSlot1_Area2D ← Left
│   ├── CardSlot2_Area2D ← Center
│   └── CardSlot3_Area2D ← Right
├── MobContainerNode2D   ← Top right — ONLY node that changes per encounter
└── GamerManager_Node    ← Plain Node, game brain script attached
```

**Key rule:** MobContainer is the only thing swapped between encounters.
Everything else is reused for every combat scene.

---

## PixelLab Seeds

Seeds let you reproduce the exact same art style and character look.
Load the seed number in PixelLab to get consistent results across sessions.

| Seed | Character | Notes |
|------|-----------|-------|
| 3875616443.0 | Gorilla Mob Boss | Grey, sunglasses, arms crossed, chibi style |

---

## PixelLab Workflow Notes

### Generating Characters
1. Load 4 style reference frames from a previously approved character
2. Write description prompt (chibi, round, soft colors, side view, kid friendly)
3. Output method: New frames | Remove background: ON | Frame count: 4
4. Generate base character first, then use it as reference for color variants

### Generating Animations
1. Use Animate with Text feature
2. Load the character's base frame as First frame
3. Write action description (idle breathing, shoulder lift, body sway)
4. Output method: New frames | Frame count: 4
5. Save seed number after good generations for future consistency

### Prompt Tips
- Always include: chibi, round, pixel art, side view, kid friendly
- For bosses add: crown, arms crossed, boss energy
- For idle: slow breathing, chest rising, shoulder lift, body sway
- Keep descriptions under 30 words for best results

### Saving
- Export as sprite sheet: File > Export Sprite Sheet
- Individual frames: File > Export As > character_{frame}.png
- Always save to: C:\Users\Nicky\Documents\baby-battle-bash\assets\sprites\

---

## Progress Tracker

### MAJOR MILESTONE REACHED ✓
**Full game flow with real card effects — April 2026**
Main Menu → Animal Select → Combat → Victory/Defeat all working. Reward persistence fixed. Color and Word v1 effects implemented.

### Done ✓ (Complete list)
- [x] Combat scene node structure built in Godot
- [x] GameManager script — deck, energy, turn flow all working
- [x] Card.gd — enum is ATTACK(0), SKILL(1), ANIMAL(2), COLOR(3), WORD(4)
- [x] card.tscn and card_display.gd built
- [x] Cards spawning visually in hand zone — all 5 visible
- [x] HP, Energy, Mr. Kiwi name, HP, and ATK all showing on screen
- [x] End Turn button working and positioned bottom right
- [x] Card type routing — ATTACK/SKILL/ANIMAL/COLOR/WORD all handled
- [x] play_attack_card — deals damage to mob, costs energy
- [x] play_skill_card — gives player block, costs energy
- [x] play_animal_card — drag to field slot, free, no energy cost
- [x] play_color_or_word_card — Blue draws 1, Red buffs ATK, Green heals
- [x] Run Away — draws 1 card instead of giving block
- [x] field_slots Dictionary — tracks slot occupancy {0,1,2}
- [x] resolve_combat() — full combat loop working
- [x] win_combat() and lose_combat() — victory and defeat screens
- [x] draw_cards with graveyard shuffle refill
- [x] Opening hand guarantee — at least 2 starter animals on turn 1
- [x] spawn_field_visuals() — world space, no duplication
- [x] Card drag and drop — full working with snap back
- [x] Input fix — MOUSE_FILTER_IGNORE, physics picking enabled
- [x] Field animal input disabled after drop
- [x] reward_screen.tscn — shows 1 Animal + 1 Color + 1 Word after victory
- [x] Reward persistence — GameState.reward_cards carries cards between scenes
- [x] lose_screen.tscn — Defeat overlay with working Retry button
- [x] main_menu.tscn — title, Play, Exit
- [x] animal_select.tscn — real 3-choice screen: Bunny/Turtle/Dog
- [x] GameState autoload — selected_starter and reward_cards persist across scenes
- [x] build_starting_deck() branches on GameState.selected_starter
- [x] Turtle starter — HP 20, ATK 2, DEF 5
- [x] Dog starter — HP 10, ATK 8, DEF 1
- [x] MobATKLabel showing mob damage on screen
- [x] project.godot starts at main menu
- [x] Full scene flow: Main Menu → Animal Select → Combat → Victory/Defeat
- [x] GitHub at github.com/Master-Ong/baby-battle-bash
- [x] CLAUDE.md — CC reads rules automatically on startup
- [x] ChatGPT constraints block saved in master doc
- [x] prompt.txt workflow — paste long prompts via file

### In Progress 🔄
- [ ] Color/Word v1 effects — prompt ready, not yet confirmed working

### Up Next 📋
- [ ] Test and confirm Blue/Green/Run Away effects work correctly
- [ ] Second mob encounter after Mr. Kiwi
- [ ] Map/roadmap — node types: mob, elite, shop, rest, chest, boss
- [ ] Turtle and Dog deeper card identity (unique verb packages)
- [ ] Visual polish — card art, backgrounds, UI styling
- [ ] Rarity system for reward pool
- [ ] Adjective cards
- [ ] Playtesting

### Build Order (confirmed)
1. Confirm v1 Color/Word effects ← current
2. Second mob encounter
3. Map/roadmap
4. Visual polish
5. Adjective cards and rarity

### Current Scene Flow
```
Main Menu → Animal Select → Combat → Victory/Defeat
                Bunny/Turtle/Dog        Reward screen (1 Animal + 1 Color + 1 Word)
```

### Known Remaining Issues 🔧
- Blue/Green/Run Away effects not yet confirmed working
- Reward pool limited to v1 set only
- No second mob yet — same Mr. Kiwi every run
- Visual polish not started

### Workflow
- ChatGPT — simplify, draft prompts, brainstorm
- Claude.ai — verify files, architect, debug, teach, maintain docs
- Claude Code — build only after Claude.ai approves
- Long prompts via prompt.txt file
- GitHub push at end of every session
- Master doc updated at every save point

### Done ✓ (Complete list)
- [x] Combat scene node structure built in Godot
- [x] GameManager script — deck, energy, turn flow all working
- [x] Card.gd — enum is ATTACK(0), SKILL(1), ANIMAL(2), COLOR(3), WORD(4)
- [x] card.tscn and card_display.gd built
- [x] Cards spawning visually in hand zone — all 5 visible
- [x] HP, Energy, Mr. Kiwi name and HP all showing on screen
- [x] End Turn button working and positioned bottom right
- [x] Card type routing — ATTACK/SKILL/ANIMAL/COLOR all handled
- [x] play_attack_card — deals 6 damage to mob, costs 1 energy
- [x] play_skill_card — gives player 5 block, costs 1 energy
- [x] play_animal_card — drag to field slot, free, no energy cost
- [x] field_slots Dictionary — tracks slot occupancy {0: left, 1: center, 2: right}
- [x] resolve_combat() — animals attack mob, mob deals 10 dmg, player takes damage if field empty
- [x] win_combat() — fires victory screen when mob HP hits 0
- [x] lose_combat() — fires lose screen when player HP hits 0
- [x] draw_cards with graveyard shuffle refill
- [x] Opening hand guarantee — at least 2 Bunny cards on turn 1
- [x] Bunny animal cards in starting deck (3 Bunnies, ATK 4, HP 12)
- [x] spawn_field_visuals() — world space, no duplication, preserves slot panels
- [x] Card drag and drop — grabs from center, drops centered in slot, snaps back if invalid
- [x] Input fix — MOUSE_FILTER_IGNORE on Control children, physics picking enabled
- [x] Field animal input disabled after drop — set_process(false) + input_pickable = false
- [x] Debug print spam removed
- [x] Card enum mismatch fixed — setup() uses enum names
- [x] Field duplication bug fixed, slot panels preserved
- [x] mob_damage = 10, double turn increment fixed
- [x] reward_screen.tscn and reward_screen.gd — shows 3 card options after victory
- [x] lose_screen.tscn and lose_screen.gd — Defeat overlay with Retry button
- [x] Retry fix — queue_free() before scene reload, process_mode WHEN_PAUSED
- [x] main_menu.tscn and main_menu.gd — title, Play, Exit buttons
- [x] animal_select.tscn and animal_select.gd — stub scene with Start button
- [x] project.godot — game starts at main menu
- [x] Full scene flow connected end to end
- [x] GitHub repository at github.com/Master-Ong/baby-battle-bash
- [x] .gitignore configured for Godot cache files
- [x] CLAUDE.md — CC reads rules automatically on every startup
- [x] ChatGPT constraints block saved in master doc
- [x] Art pipeline — Hamster variants, Gorilla mob boss with idle animation
- [x] Rabbit family designed — Bunny/Rabbit/Fluffle stats and color variants

### In Progress 🔄
- [ ] Animal select — stub exists, real selection logic not built
- [ ] Reward card pool — placeholder only

### Up Next 📋
- [ ] Real animal select — 3 starters: Bunny/Turtle/Dog with GameState autoload
- [ ] Turtle family card data (Defense type)
- [ ] Dog family card data (Power type)
- [ ] Expand reward card pool
- [ ] Second mob encounter after Mr. Kiwi
- [ ] Map/roadmap — node types: mob, elite, shop, rest, chest, boss
- [ ] Visual polish — card art, backgrounds, UI styling
- [ ] Playtesting

### Build Order (confirmed)
1. Real animal select + GameState autoload ← next
2. Turtle and Dog card data
3. Expand reward pool
4. Second mob encounter
5. Map/roadmap (last)

### Current Scene Flow
```
Main Menu → Animal Select (stub) → Combat → Victory/Defeat
```

### Known Remaining Issues 🔧
- Animal select is stub only
- Reward card pool is placeholder only
- UID warnings on some scenes — harmless

### Current Scene Layout (confirmed working)
- HP and Energy — top left
- Mr. Kiwi — top center
- Field zone — 3 slots centered
- Hand zone — bottom center
- Deck/GY — bottom corners
- End Turn — bottom right

### Workflow
- ChatGPT — simplify, draft prompts, brainstorm
- Claude.ai — verify files, architect, debug, teach, maintain docs
- Claude Code — build only after Claude.ai approves
- GitHub push at end of every session with git add . / git commit / git push

### Done ✓ (Complete list)
- [x] Combat scene node structure built in Godot
- [x] GameManager script — deck, energy, turn flow all working
- [x] Card.gd — enum is ATTACK(0), SKILL(1), ANIMAL(2), COLOR(3), WORD(4)
- [x] card.tscn and card_display.gd built
- [x] Cards spawning visually in hand zone — all 5 visible
- [x] HP, Energy, Mr. Kiwi name and HP all showing on screen
- [x] End Turn button working and positioned bottom right
- [x] Card type routing — ATTACK/SKILL/ANIMAL/COLOR all handled
- [x] play_attack_card — deals 6 damage to mob, costs 1 energy
- [x] play_skill_card — gives player 5 block, costs 1 energy
- [x] play_animal_card — drag to field slot, free, no energy cost
- [x] field_slots Dictionary — tracks slot occupancy {0: left, 1: center, 2: right}
- [x] resolve_combat() — animals attack mob, mob deals 10 dmg to animals, player takes damage if field empty
- [x] win_combat() — fires victory screen when mob HP hits 0
- [x] lose_combat() — pauses game when player HP hits 0
- [x] draw_cards with graveyard shuffle refill
- [x] Opening hand guarantee — at least 2 Bunny cards on turn 1
- [x] Bunny animal cards in starting deck (3 Bunnies, ATK 4, HP 12)
- [x] spawn_field_visuals() — world space, no duplication, preserves slot panels
- [x] Card drag and drop — grabs from center, drops centered in slot, snaps back if invalid
- [x] Input fix — MOUSE_FILTER_IGNORE on Control children, physics picking enabled
- [x] Field animal input disabled after drop — set_process(false) + input_pickable = false
- [x] Debug print spam removed from _on_input_event
- [x] Card enum mismatch fixed — setup() uses enum names
- [x] Field duplication bug fixed
- [x] Slot panels preserved through spawn cycles
- [x] mob_damage = 10, double turn increment fixed
- [x] reward_screen.tscn and reward_screen.gd — shows 3 card options after victory
- [x] Layout — HP/Energy top left, Mr. Kiwi top center, 3 field slots, hand bottom, deck/GY corners
- [x] CLAUDE.md — CC reads rules automatically on every startup
- [x] godot-mcp connected and working live
- [x] Master document and CLAUDE.md maintained
- [x] Art pipeline — Hamster variants, Gorilla mob boss with idle animation
- [x] Rabbit family designed — Bunny/Rabbit/Fluffle stats and color variants

### In Progress 🔄
- [ ] Reward screen — functional but card pool is placeholder only
- [ ] Lose screen — game pauses silently, no visual feedback

### Up Next 📋
- [ ] Lose screen — visible You Lose message when player HP hits 0
- [ ] Reward card pool — expand beyond Strike/Blue/Bunny placeholders
- [ ] Main menu — Play and Exit buttons
- [ ] Animal select screen — choose Bunny/Turtle/Dog starter
- [ ] GameState autoload — carries player data between scenes
- [ ] Second mob encounter after Mr. Kiwi
- [ ] Design Turtle family (Defense type)
- [ ] Design Lion family (Power type)
- [ ] Map/roadmap — node types: mob, elite, shop, rest, chest, boss
- [ ] Visual polish — card art placeholders, backgrounds
- [ ] Playtesting

### Build Order (confirmed)
1. Reward screen polish ← current
2. Lose screen
3. Main menu
4. Animal select + GameState autoload
5. Map/roadmap (last — needs all destinations first)

### Known Remaining Issues 🔧
- UID mismatch warnings on card.tscn and reward_screen.tscn — harmless, from project.godot recreation
- Lose screen not built — game pauses silently on defeat
- Reward card pool is placeholder only

### Current Scene Layout (confirmed working)
- HP and Energy — top left, side by side
- Mr. Kiwi name and HP — top center above mob zone panel
- Field zone — 3 slots centered, CardSlot2 is X=0 anchor
- Hand zone — bottom center, 5 cards at X=-220,-110,0,110,220
- Deck panel and label — bottom left
- Graveyard panel and label — bottom right
- End Turn button — bottom right

### Workflow
- ChatGPT — simplify problems, draft rough prompts, brainstorm
- Claude.ai — verify against real files, architect, debug, teach, maintain docs
- Claude Code — build only after Claude.ai approves prompt
- All ChatGPT drafts reviewed by Claude.ai before going to CC
- Save to CC memory at end of every session
- Master doc updated at every major milestone or save point

---

## ChatGPT Session Constraints Block

Paste this at the start of every ChatGPT session for Baby Battle Bash.
This keeps ChatGPT aligned with the real project rules and reduces mistakes.

```
Baby Battle Bash — Godot 4 project constraints.
Read this before helping with any prompts.

Tech rules:
- Engine: Godot 4.6.2 GDScript only
- Cards use Area2D not CharacterBody2D
- CanvasLayer uses top-left origin (0,0)
- Node2D world space uses center origin (0,0)
- Always use get_global_mouse_position() for drag
- Always use create_tween() not old Tween node
- process_mode must be PROCESS_MODE_WHEN_PAUSED
  for any UI that needs to work while game is paused
- queue_free() is always used to delete nodes — never free()
- change_scene_to_file() only unloads the current scene
  anything added to get_tree().root survives scene changes
- CLAUDE.md in project root has full rules

Node naming:
- Root scene: CombatScene
- Game brain: GamerManager_Node
- Card script: card_display.gd on Area2D root
- Field tracking: field_slots Dictionary {0: left, 1: center, 2: right}
- Card enum: ATTACK(0) SKILL(1) ANIMAL(2) COLOR(3) WORD(4)
- Hand zone: HandZone_Area2D (world space Node2D)
- Field slots: CardSlot1_Area2D, CardSlot2_Area2D, CardSlot3_Area2D
  inside PlayerField_Node2D

Key coordinate rules:
- CanvasLayer children use offset_left / offset_top (top-left origin)
- Node2D children use position Vector2 (center origin)
- Never mix coordinate systems between the two layers

Workflow rule:
- ChatGPT drafts prompts
- Claude.ai verifies against real files before CC builds
- Never send ChatGPT prompts directly to Claude Code
- Flag any Godot 4 specific terms you are unsure about
  so Claude.ai can verify before implementation
- Always state the most likely cause as a hypothesis
  not as a confirmed diagnosis
```

---

## Important Design Rules

- No shirk (no false gods, idol worship, or polytheistic lore)
- Game must be playable by all ages — kid mode and advanced mode
- Educational hook must be present — animals, colors, vocabulary
- Cozy and collectible first, strategic second
- Colors are always permanent for the run when applied
- MobContainer is always the only thing swapped between encounters
- Cards use Area2D not CharacterBody2D

---

## CC Prompt Ready — Layout Fix

In Baby Battle Bash at C:\Users\Nicky\Documents\baby-battle-bash. Viewport is 1152x648. CanvasLayer uses top-left origin so 0,0 is top-left.

Please make the following layout changes:

1. Update res://Scene/combat_scene.tscn

Move PlayerHPLabel to position (20, 20) font size 16.
Move EnergyLabel to position (160, 20) font size 16. Right beside HP.
Move MobNameLabel to position (496, 20) font size 16 centered at top middle.
Move MobHPLabel to position (496, 40) font size 13 centered below mob name.
Move DeckLabel to position (36, 570) font size 13.
Move GraveyardLabel to position (1050, 570) font size 13.
Move EndTurnButton to position (980, 600) size 160x36 font size 14.

Add a Panel node called MobZonePanel inside root Node2D at position (-192, -280) size 384x180. Visible background for mob area top center.

Add a Panel node called FieldZonePanel inside root Node2D at position (-576, -80) size 1152x180. Visible background strip for field slots across the middle.

Add Panel nodes SlotPanel1 SlotPanel2 SlotPanel3 inside PlayerField_Node2D, size 130x170 each, centered inside each CardSlot Area2D.

Add Panel called DeckPanel inside DG_Node2D at position (-540, 530) size 100x80.
Add Panel called GraveyardPanel inside DG_Node2D at position (1042, 530) size 100x80.

2. Update res://Scripts/gamer_manager_node.gd

In _set_positions() update HandZone_Area2D position to Vector2(0, 580).
Update spawn_hand_visuals() to space cards at X=-220, -110, 0, 110, 220 relative to HandZone. Set card Y to -80 relative to HandZone.

---

## CC Prompt Ready — Card Scene

```
I am building a 2D card roguelike game in Godot 4 called Baby Battle Bash.
My project is at C:\Users\Nicky\Documents\baby-battle-bash

Create two files:

1. res://Scene/card.tscn
Node structure:
- Area2D root named Card with script attached
- CollisionShape2D named CardCollision with RectangleShape2D size 120x160
- Panel named CardBackground sized 120x160 position 0,0
- Label named CardName position 8,8 size 104x24 font size 14
- Label named CardCost position 88,8 size 24x24 font size 14
- Label named CardDescription position 8,90 size 104x60 font size 11
- Label named CardType position 8,64 size 104x20 font size 11

2. res://Scripts/card_display.gd
Script attached to Card Area2D that:
- Has variable card_data holding a Card object
- Has function setup(card) filling all labels from card.card_name,
  card.energy_cost, card.card_description, card.card_type
- mouse_entered signal: scale card to Vector2(1.1, 1.1)
- mouse_exited signal: scale card back to Vector2(1.0, 1.0)
- Print Card hovered: + card_name on mouse enter

Existing card script at res://Scripts/Card.gd has:
card_name, card_type, energy_cost, effect_value, card_description
```

---

## CC Prompt Ready — Card Drag and Drop Movement

In Baby Battle Bash at C:\Users\Nicky\Documents\baby-battle-bash. Use godot-mcp to read the current scene tree first.

Build drag and drop card movement with these rules:

ANIMAL cards — player picks up from hand, drags to a field slot, drops it there. Card stays on field until defeated. Free, no energy cost.

ATTACK and SKILL cards — single click plays them instantly. No dragging needed. ATTACK deals damage to mob. SKILL gives player defense.

COLOR and WORD cards — single click applies effect to all field animals. No dragging.

If player picks up a card and drops it somewhere invalid, card snaps back to its original hand position with a smooth tween animation.

Update res://Scripts/card_display.gd:
- Add variable original_position to store where the card started
- Add variable is_dragging = false
- On mouse button down: if ANIMAL type set is_dragging = true, store original_position, bring card to top of draw order
- On mouse motion: if is_dragging = true move card to follow mouse position
- On mouse button up: if is_dragging = true check if card is hovering over a valid CardSlot Area2D. If yes call play_animal_card. If no tween card back to original_position over 0.2 seconds. Set is_dragging = false.
- For ATTACK SKILL COLOR WORD types keep single click behavior as is

Update res://Scripts/gamer_manager_node.gd:
- Add function get_hovered_slot() that checks if any CardSlot Area2D overlaps the current mouse position and returns the slot index (0, 1, or 2) or -1 if none

*Last updated: April 2026*
*Always update the Progress Tracker when milestones are completed.*
