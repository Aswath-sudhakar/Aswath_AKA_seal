extends RigidBody2D

enum PART_TYPES {eye, wing}

@onready var sprite = $"Sprite2D"

func spawn_by_parent(facing_right: bool, type: int):
	if type == PART_TYPES.eye:
		sprite.texture = load("res://Frameworks(YourStuff)/Kevin/Swat/assets/jerks/death_parts/eye.png")
		if facing_right:
			position.x += 6
			apply_impulse(Vector2(50, -300))
		else:
			position.x -= 6
			apply_impulse(Vector2(-50, -200))
	elif type == PART_TYPES.wing:
		sprite.texture = load("res://Frameworks(YourStuff)/Kevin/Swat/assets/jerks/death_parts/wing.png")
		position.y -= 2
		if facing_right:
			position.x += 9
			apply_impulse(Vector2(100, -200))
		else:
			position.x -= 9
			apply_impulse(Vector2(-100, -200))
	sprite.flip_h = facing_right
