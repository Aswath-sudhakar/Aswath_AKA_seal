extends Sprite2D

var sticking_around = false

@onready var anim = $"AnimationPlayer"

func start():
	modulate = Color.from_hsv(0, 0, 1, 0)

func blink():
	if !sticking_around:
		anim.play("blink")

func stick_around():
	sticking_around = true
	anim.stop(true)
	anim.play("stick_around")
