class_name CoinEmitterOpponent extends GPUParticles3D


func _ready() -> void:
	GameEvents.do_opponent_steal_vfx.connect(show_coins)


func show_coins(count : int) -> void:
	amount = count
	emitting = true
