extends State
class_name DistrictCardDraggingState

@export var face_up_state : State


func enter() -> void:
	super()
	(parent as DistrictCard).start_is_draggin_animation()


func exit() -> void:
	super()
	(parent as DistrictCard).reverse_is_draggin_animation()


func process_physics(delta : float) -> State:
	(parent as DistrictCard).handle_tilt(delta)
	return null


func process_frame(delta : float) -> State:
	if not (parent as DistrictCard).is_being_dragged:
		return face_up_state
	else:
		return null
