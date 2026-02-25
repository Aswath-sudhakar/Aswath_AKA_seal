class_name EatingZone extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

@warning_ignore('unused_signal') signal planet_suck(planet : Planet)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):# and timer.is_stopped():
		set_toggle_zone(true)
		timer.start()
		await get_tree().create_timer(0.05).timeout
		set_toggle_zone(false)


func set_toggle_zone(toggle_mode : bool) -> void:
	collision_shape_2d.disabled = !toggle_mode
