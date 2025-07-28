class_name EarthAttackOpponent extends Node3D

@onready var spikes: GPUParticles3D = $Spikes
@onready var sparks: GPUParticles3D = $Sparks
@onready var crack: Decal = $Crack
@onready var blood : BloodSpash = $Blood


func _ready() -> void:
	GameEvents.do_opponent_assassinate_vfx.connect(new_ground_attack)


func ground_attack():
	spikes.emitting = true
	sparks.emitting = true
	crack.emission_energy = 0.0

	GameEvents.requested_camera_shake.emit(0.2, 0.2)
	await get_tree().create_timer(0.2).timeout
	crack.emission_energy = 16.0


	await get_tree().create_timer(1.0).timeout

	var duration := 2.0
	var steps := 20
	for i in range(steps + 1):
		var t := i / float(steps)
		crack.emission_energy = lerp(16.0, 0.0, t)
		await get_tree().create_timer(duration / steps).timeout


func new_ground_attack():
	spikes.emitting = true
	sparks.emitting = true

	GameEvents.requested_camera_shake.emit(0.3, 0.3)

	blood.activate_effects()
