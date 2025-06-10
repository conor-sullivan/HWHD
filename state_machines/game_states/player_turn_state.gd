class_name PlayerTurnState
extends State

var current_character_turn : CharacterData
var current_character_index : int = 0
@export var characters : Array[CharacterData]


func enter() -> void:
	print("player turn state")
	
	current_character_turn = characters[current_character_index]
	print("current character turn : ", current_character_turn.character_name)
	GameEvents.requested_character_take_turn.emit(current_character_turn)

# starting with the character with the lowest play order number (assassin)
# flip the character card in the player tracker


# change turn to that player id
# give player option to get 2 gold or 1 district card
# give player option to build a district
# give player the option to use their special ability
# pass the turn

## optional later feature
# players should have the ability to view the other players during their turn
