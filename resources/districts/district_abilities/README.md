# District Abilities System

This system provides a centralized way to manage all district abilities in the game, making it easy to add new abilities without scattered code changes.

## Architecture

### Core Components

1. **DistrictAbilitiesManager** (`scripts/singletons/district_abilities_manager.gd`)
   - Singleton that manages all district abilities
   - Automatically connects to game events
   - Triggers abilities at appropriate times
   - Provides query methods for ability effects

2. **BaseDistrictAbility** (`base_district_ability.gd`)
   - Base class for all district abilities
   - Defines common interface and default implementations
   - Provides utility methods for notifications

3. **Individual Ability Scripts**
   - Each district with special abilities has its own script
   - Extends BaseDistrictAbility
   - Implements specific ability logic

## How It Works

### Event-Based Triggers
The system automatically triggers abilities based on game events:
- `on_end_of_turn()` - Called when a player's turn ends
- `on_gold_gained()` - Called when player gains gold
- `on_district_played()` - Called when a district is played
- `on_robbed()` - Called when player is robbed
- And many more...

### Query-Based Methods
Some abilities need to be checked during game logic:
- `can_be_destroyed()` - Check if district can be destroyed (Keep)
- `get_warlord_cost_modifier()` - Get cost reduction for warlord (Armory)
- `get_end_game_bonus_points()` - Calculate bonus points (Imperial Treasure, Map Room, Bell Tower)
- `get_income_colors()` - Get colors for income calculation (School of Magic)

## Implemented Abilities

### Simple Abilities
- **Keep**: Cannot be destroyed
- **Armory**: Reduces warlord destruction cost by 1
- **Hospital**: Allows taking turn when assassinated
- **School of Magic**: Counts as any color during income phase

### End-of-Turn Abilities
- **Poor House**: Gain 1 gold if you have no gold at end of turn
- **Park**: Draw 2 cards if you have no cards in hand at end of turn

### End-Game Scoring Abilities
- **Imperial Treasure**: +1 point per gold at end of game
- **Map Room**: +1 point per card in hand at end of game
- **Bell Tower**: +4 points if only you have 7 districts, +2 if others also have 7

### Complex Abilities (Partial Implementation)
- **Lighthouse**: Look through deck, choose 1 card, shuffle deck
- **Necropolis**: Destroy one of your districts instead of paying cost

## Adding New Abilities

### Step 1: Create Ability Script
```gdscript
extends BaseDistrictAbility
class_name YourNewAbility

func on_end_of_turn(card: DistrictData, player: Player) -> void:
    # Your ability logic here
    emit_ability_notification(player, "ability activated")
```

### Step 2: Update District Resource
Add the ability script to your district's .tres file:
```gdresource
[ext_resource type="Script" path="res://resources/districts/district_abilities/your_new_ability.gd" id="5_new"]

[sub_resource type="Resource" id="Resource_new"]
script = ExtResource("5_new")

[resource]
# ... other properties ...
ability_script = SubResource("Resource_new")
```

### Step 3: No Additional Integration Required!
The DistrictAbilitiesManager will automatically:
- Detect the new ability
- Call it at appropriate times
- Handle all the event connections

## Integration Examples

### Check if District Can Be Destroyed
```gdscript
if DistrictAbilitiesManager.can_district_be_destroyed(district, owner):
    # Proceed with destruction
    pass
else:
    # District is protected (like Keep)
    pass
```

### Calculate Warlord Destruction Cost
```gdscript
var base_cost = district.cost - 1
var modifier = DistrictAbilitiesManager.get_warlord_destruction_cost_modifier(player)
var final_cost = max(0, base_cost + modifier)
```

### Calculate Final Score
```gdscript
var base_score = player.points_count
var bonus_points = DistrictAbilitiesManager.get_end_game_bonus_points(player)
var final_score = base_score + bonus_points
```

### Check Income Colors
```gdscript
var income = 0
for district in player.district_cards_in_play:
    var colors = DistrictAbilitiesManager.get_district_colors_for_income(player, district)
    if character_color in colors:
        income += 1
```

## Benefits

1. **Centralized Management**: All abilities are managed in one place
2. **Easy to Extend**: Adding new abilities requires minimal code changes
3. **Automatic Integration**: New abilities work automatically with existing game events
4. **Clean Separation**: Ability logic is separated from game logic
5. **Consistent Interface**: All abilities follow the same patterns
6. **Easy Testing**: Each ability can be tested independently

## Future Enhancements

- Add more event types as needed
- Implement UI for complex abilities (Lighthouse, Necropolis)
- Add ability priority system if needed
- Add ability interaction handling
- Add debugging/logging for ability triggers