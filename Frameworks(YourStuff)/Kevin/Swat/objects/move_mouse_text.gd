extends Sprite2D

@onready var anim = $"AnimationPlayer"

var shake_amount = 1

func _physics_process(_delta: float) -> void:
	offset = Vector2(randi_range(-shake_amount, shake_amount), randi_range(-shake_amount, shake_amount))

func start():
	anim.play("first_time")

func go_away():
	anim.play("go_away")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "first_time":
		anim.play("go_away")
