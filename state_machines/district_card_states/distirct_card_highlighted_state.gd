extends State
class_name DistrictCardHighlightedState

@export var dragging_state : State
@export var face_up_state : State


func enter() -> void:
	super()
	(parent as DistrictCard).play_is_highlighted_animation()


func exit() -> void:
	super()
	(parent as DistrictCard).play_is_highlighted_animation_backwards()


func process_frame(delta : float) -> State:
	if (parent as DistrictCard).is_being_dragged:
		return dragging_state
	elif not (parent as DistrictCard).is_highlighted:
		return face_up_state
	else:
		return null
