extends Node
class_name StateMachine

@export var starting_state : State

var current_state : State


func _ready() -> void:
	init(get_parent())
	

func init(parent : Node) -> void:
	for child in get_children():
		child.parent = parent
	
	change_state(starting_state)


func change_state(new_state : State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	#print(current_state)

func _physics_process(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
	

func _input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		

func _process(delta : float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
