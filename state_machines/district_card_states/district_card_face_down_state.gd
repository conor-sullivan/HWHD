extends State
class_name DistrictCardFaceDownState

@export var face_up_state : State


func exit() -> void:
	(parent as DistrictCard).play_flip_animation()


func process_frame(delta : float) -> State:
	if not (parent as DistrictCard).is_face_down:
		return face_up_state
	else:
		return null
