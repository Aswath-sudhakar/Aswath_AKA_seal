extends Area2D

@onready var anim = $"AnimationPlayer"
@onready var audio_success = $"Fly Annihilator"
@onready var audio_failure = $"Swing and a Miss"
@onready var audio_bass_boost = $"Bass Boost"

var swatting = false

var got_them_flies = false

var started = false

func _ready():
	anim.play("fake_swat")
	audio_bass_boost.play()

func _physics_process(_delta: float) -> void:
	if !started:
		started = true
	position = get_global_mouse_position()
	if swatting:
		swatting = false
	elif monitoring:
		monitoring = false
		if got_them_flies:
			audio_success.play()
			audio_bass_boost.volume_db = 5
		else:
			audio_bass_boost.volume_linear = 0
		audio_failure.play()

func swat():
	got_them_flies = false
	monitoring = true
	swatting = true
	anim.stop(true)
	anim.play("swat")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("perish_violently"):
		body.perish_violently()
		got_them_flies = true
	elif body is RigidBody2D:
		body.apply_impulse(500 * Vector2(cos(get_angle_to(body.position)), -abs(sin(get_angle_to(body.position)))))
