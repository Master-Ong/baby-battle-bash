# Baby Battle Bash — Master Project Document (Trimmed)
# This is the single source of truth for the current project state.
# Update this file whenever a major decision is made or a milestone is completed.
# Paste this at the top of any new Claude chat to resume instantly.

---

## Project Identity

- **Game name:** Baby Battle Bash
- **Engine:** Godot 4 (version 4.6.2 stable)
- **Genre:** 2D Card Deckbuilding Roguelike
- **Audience:** All ages — kids learn, adults strategize
- **Project path:** `C:\Users\Nicky\Documents\baby-battle-bash`
- **Developer:** Nicky (creative director) + Friend (technical lead)
- **Workflow:** ChatGPT drafts and simplifies → Claude.ai verifies against real files → Claude Code builds

---

## Art Style Direction

### Vision
A blend of chibi pixel art characters set inside a warm children's book world.
The game should feel like you are reading a storybook again as a child — soft, inviting, easy on the eyes. Not harsh or overly saturated.

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
`C:\Users\Nicky\Documents\baby-battle-bash\assets\sprites\`

---

## Technical Specifications

### Resolution
- **Game viewport:** 1152 x 648 (16:9 widescreen)
- **Godot coordinate center:** X=0, Y=0
- Left edge: X=-576 | Right edge: X=576 | Top: Y=-324 | Bottom: Y=324

### Layer System (placeholder — confirm later)
- **Resolution target:** 320x180 base (scaled up)
- **Tile size:** 32x32 pixels
- **Layer order (back to front):**
  - Far background (sky, distant scenery)
  - Mid background (environment details)
  - Foreground (characters, cards, UI elements)

### File Structure
```text
res://
├── Scene/
│   ├── combat_scene.tscn       ✓ Built
│   ├── card.tscn               ✓ Built
│   ├── reward_screen.tscn      ✓ Built
│   ├── lose_screen.tscn        ✓ Built
│   ├── main_menu.tscn          ✓ Built
│   ├── animal_select.tscn      ✓ Built
│   ├── roadmap_scene.tscn      ✓ Built
│   ├── rest_site.tscn          ✓ Built
│   └── chest_site.tscn         ✓ Built
├── Scripts/
│   ├── Card.gd                 ✓ Built
│   ├── gamer_manager_node.gd   ✓ Built
│   ├── card_display.gd         ✓ Built
│   ├── reward_screen.gd        ✓ Built
│   ├── lose_screen.gd          ✓ Built
│   ├── main_menu.gd            ✓ Built
│   ├── animal_select.gd        ✓ Built
│   ├── roadmap_scene.gd        ✓ Built
│   ├── rest_site.gd            ✓ Built
│   ├── chest_site.gd           ✓ Built
│   └── GameState.gd            ✓ Built (autoload singleton)
├── CLAUDE.md                   ✓ Created (CC reads on startup)
├── BABY_BATTLE_BASH_MASTER.md  ✓ Master reference doc
└── assets/
    └── sprites/                ← Save all art here
```

---

## Game Design Summary

### Core Loop
1. Choose a starter animal family
2. Travel the roadmap
3. Fight combats
4. Take rewards
5. Use rest/chest nodes
6. Continue progression through the run

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
- Block/defense does **not** carry over between turns
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

**Key rule:** Color transformation is **permanent for the run**.

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

```text
CombatScene              ← Node2D (root)
├── Camera2D             ← Fixed, position smoothing OFF
├── CanvasLayer          ← pins UI to screen
│   └── HandZone_Area2D  ← bottom center, hand display
├── DG_Node2D            ← deck + graveyard container
├── PlayerField_Node2D   ← 3 card slots for played cards
│   ├── CardSlot1_Area2D ← Left
│   ├── CardSlot2_Area2D ← Center
│   └── CardSlot3_Area2D ← Right
├── MobContainerNode2D   ← only node that changes per encounter
└── GamerManager_Node    ← game brain script
```

**Key rule:** `MobContainer` is the only thing swapped between encounters. Everything else is reused for every combat scene.

---

## PixelLab Seeds

| Seed | Character | Notes |
|------|-----------|-------|
| 3875616443.0 | Gorilla Mob Boss | Grey, sunglasses, arms crossed, chibi style |

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
- Individual frames: File > Export As > `character_{frame}.png`
- Always save to: `C:\Users\Nicky\Documents\baby-battle-bash\assets\sprites\`

---

## Current Next Step
- Decide whether to send the safe HUD restructure prompt
- Add card art sprites for animals
- Add more mob encounters beyond Big Bear
- Start a light balance pass

---

## Progress Tracker

### Major Milestone Reached ✓
**Full roguelike loop with roadmap, relics, and multiple encounters — April/May 2026**
Main Menu → Animal Select → Roadmap → Combat → Reward → Roadmap progression working end to end.

### Done ✓
- [x] Main Menu → Animal Select → Roadmap → Combat → Reward → Roadmap progression working end to end
- [x] Bunny / Turtle / Dog starter selection with different decks
- [x] GameState autoload tracks: `selected_starter`, `reward_cards`, `relics`, `player_hp`, `encounter_number`, `nodes_completed`
- [x] Card routing for ATTACK / SKILL / ANIMAL / COLOR / WORD
- [x] Blue draws 1 card
- [x] Red buffs all field animals +2 ATK and refreshes visuals immediately
- [x] Green heals player 3 HP
- [x] Run Away draws 1 card
- [x] Scratch / Bite / Dash deal correct damage
- [x] Hide / Block give correct block
- [x] `field_slots` Dictionary is source of truth
- [x] `field_animals` array removed
- [x] `get_field_animals()` helper exists
- [x] Card drag and drop fully working with snap back
- [x] Input fix: Control children use `MOUSE_FILTER_IGNORE`; physics picking enabled
- [x] Field slots clear between encounters
- [x] Reward screen shows 1 Animal + 1 Color + 1 Word after victory
- [x] Reward persistence via `GameState.reward_cards`
- [x] Lose screen with working Retry button
- [x] Two encounters: Mr. Kiwi (encounter 1) and Big Bear (encounter 2, HP 65, DMG 14)
- [x] Roadmap with Combat / Rest / Chest / Boss nodes
- [x] Temporary test route: Combat → Chest → Combat → Rest → Boss
- [x] Rest Site heals 15 HP and returns to roadmap
- [x] Chest Site gives Bandage Roll relic and returns to roadmap
- [x] Bandage Roll starts each combat with 5 Block on turn 1
- [x] RelicLabel shows owned relics on combat HUD
- [x] Visual polish started: card colors by type, dark background, mob zone tinted red
- [x] Roadmap node colors by type
- [x] `BackgroundRect` mouse_filter set to IGNORE so cards still work
- [x] CLAUDE.md reads on startup
- [x] prompt.txt workflow for long prompts
- [x] GitHub active at `github.com/Master-Ong/baby-battle-bash`
- [x] Obsidian second brain set up with templates

### In Progress 🔄
- [ ] HUD restructure — safe version prompt ready, not yet sent
- [ ] Visual polish — card art placeholders not yet added

### Up Next 📋
- [ ] Decide whether to send safe HUD restructure prompt
- [ ] Add card art sprites for animals
- [ ] More mob encounters beyond Big Bear
- [ ] Balance pass on mob HP and damage values
- [ ] Adjective cards
- [ ] More relics
- [ ] Map / roadmap procedural generation
- [ ] Playtesting

### Build Order (confirmed)
1. HUD restructure decision ← current
2. Card art sprites
3. More mob encounters
4. Balance pass
5. Adjective cards and more relics

### Current Scene Flow
```text
Main Menu → Animal Select → Roadmap → Combat → Victory → Reward → Roadmap
                                              ↓ Defeat → Lose Screen → Retry
                                    Rest Site (heal 15 HP)
                                    Chest Site (Bandage Roll relic)
```

### Known Remaining Issues 🔧
- HUD restructure is risky — breaks card input if `MOUSE_FILTER_IGNORE` is not set on all containers
- No card art yet — placeholder card visuals still in use
- Roadmap is a temporary test layout and needs rebalancing later
- No procedural map generation yet

### Warning — Do Not Do These Without Claude Review
- HUD restructure without `MOUSE_FILTER_IGNORE` on every container
- Any full-screen `Control` node without `MOUSE_FILTER_IGNORE`
- Adding `BackgroundRect` without `mouse_filter = IGNORE`

### Workflow
- ChatGPT — simplify, draft prompts, brainstorm
- Claude.ai — verify files, architect, debug, teach, maintain docs
- Claude Code — build only after Claude.ai approves
- Long prompts via `prompt.txt`
- GitHub push at end of every session
- Master doc and Obsidian updated at every save point

---

## ChatGPT Session Constraints Block

Paste this at the start of every ChatGPT session for Baby Battle Bash.

```text
Baby Battle Bash — Godot 4 project constraints.
Read this before helping with any prompts.

Tech rules:
- Engine: Godot 4.6.2 GDScript only
- Cards use Area2D not CharacterBody2D
- CanvasLayer uses top-left origin (0,0)
- Node2D world space uses center origin (0,0)
- Always use get_global_mouse_position() for drag
- Always use create_tween() not old Tween node
- process_mode must be PROCESS_MODE_WHEN_PAUSED for any UI that needs to work while game is paused
- queue_free() for normal deferred cleanup and hand visuals
- free() only for field visuals during immediate spawn cleanup when required
- change_scene_to_file() only unloads the current scene; anything added to get_tree().root survives scene changes
- Any full-screen Control node in combat_scene must use mouse_filter = MOUSE_FILTER_IGNORE
- CLAUDE.md in project root has full rules

Node naming:
- Root scene: CombatScene
- Game brain: GamerManager_Node
- Card script: card_display.gd on Area2D root
- Field tracking: field_slots Dictionary {0: left, 1: center, 2: right}
- Card enum: ATTACK(0) SKILL(1) ANIMAL(2) COLOR(3) WORD(4)
- Hand zone: HandZone_Area2D (world-space Node2D)
- Field slots: CardSlot1_Area2D, CardSlot2_Area2D, CardSlot3_Area2D inside PlayerField_Node2D

Key coordinate rules:
- CanvasLayer children use offset_left / offset_top (top-left origin)
- Node2D children use position Vector2 (center origin)
- Never mix coordinate systems between the two layers

Workflow rule:
- ChatGPT drafts prompts
- Claude.ai verifies against real files before CC builds
- Never send ChatGPT prompts directly to Claude Code
- Flag any Godot 4 specific terms you are unsure about so Claude.ai can verify before implementation
- Always state the most likely cause as a hypothesis, not as a confirmed diagnosis
```

---

## Important Design Rules

- No shirk (no false gods, idol worship, or polytheistic lore)
- Game must be playable by all ages — kid mode and advanced mode
- Educational hook must be present — animals, colors, vocabulary
- Cozy and collectible first, strategic second
- Colors are always permanent for the run when applied
- MobContainer is always the only thing swapped between encounters
- Cards use Area2D, not CharacterBody2D

