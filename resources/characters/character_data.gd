extends Resource
class_name CharacterData


@export var character_name : String
@export var avatar_texture : Texture
@export var small_avatar : Texture
@export var front_material : Resource
@export var back_material : Resource
@export var play_order_number : int
@export var color : String
@export var special_ability_text : String
@export var is_face_down_and_not_in_deck : bool#- is face down and not in deck
@export var is_face_up_and_not_in_deck : bool#- is face up and not in deck
@export var is_in_deck : bool#- is in deck
@export var has_been_revealed_by_player : bool#- has been revealed by player
@export var controled_by_player_number : int#- is controlled by player number
@export var was_assassinated : bool#- has been assasinated
@export var will_be_assassinated : bool#- will be assasinated
@export var assassinated_by_player_number : int
@export var was_robbed_by_thief : bool#- has been stolen from
@export var will_be_robbed_by_thief : bool#- will be stolen from
@export var robbed_by_player_number: int
