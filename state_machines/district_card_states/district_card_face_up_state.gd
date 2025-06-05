extends State
class_name DistrictCardFaceUpState

@export var highlighted_state : State
@export var face_down_state : State


func enter() -> void:
	(parent as DistrictCard).enable_collider()


func process_physics(delta : float) -> State:
	(parent as DistrictCard).handle_tilt(delta)
	return null


func process_frame(delta : float) -> State:
	if (parent as DistrictCard).position_in_hand != parent.position:
		(parent as DistrictCard).is_highlighted = false
	if (parent as DistrictCard).is_highlighted:
		return highlighted_state
	elif (parent as DistrictCard).is_face_down:
		return face_down_state
	else:
		return null
