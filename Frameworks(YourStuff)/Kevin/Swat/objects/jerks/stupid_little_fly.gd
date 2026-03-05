extends CharacterBody2D

@onready var body = $"Body"
@onready var eyes = $"Body/Eyes"
@onready var mouth = $"Body/Mouth"
@onready var anim = $"AnimationPlayer"
@onready var instrument = $"Instrument"

@onready var switch_timer = $"Direction Switch Timer"

var level: Node

var body_colors = [
	"gold", "silver", "green", "red"
]

var fly_intsrument_paths = [
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - Shiver me flies.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - Wavering Fly.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - Ambient Fly.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - Backup Fly.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - Tootfly.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - Tomflyery.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - Based Fly.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Swat/audio/jerks_with_instruments/Flight of the Dumblefly - jfoijairogergoireajgoireajg.wav")
]

var speed = 100 #100 # scales with difficulty
var rotation_momentum_max = 0.05 #0.05 # scales with difficulty

var traveling_rot: float = 0
var rotation_momentum: float = 0

func _ready():
	body.texture = load("res://Frameworks(YourStuff)/Kevin/Swat/assets/jerks/bodies/fly_" + body_colors[randi_range(0, body_colors.size() - 1)] + ".png")
	eyes.frame = randi_range(0, 3)
	mouth.frame = randi_range(0, 3)
	anim.play("grow")
	if get_parent():
		level = get_parent()
		receive_difficulty(level.ultra_hardcore_difficulty)
	_on_direction_switch_timer_timeout()

func play_instrument(flyd: int, wacky: bool):
	instrument.stream = fly_intsrument_paths[flyd]
	if wacky:
		instrument.pitch_scale = randf_range(0.5, 1.5)
		instrument.seek(randf_range(0, 4))
	instrument.play()

func receive_difficulty(new_diff: float):
	#new_diff = clamp(new_diff, 1, 3)
	speed *= new_diff
	rotation_momentum_max *= new_diff

func _physics_process(_delta: float) -> void:
	traveling_rot += rotation_momentum
	velocity = Vector2(speed * sin(traveling_rot), speed * -cos(traveling_rot))
	move_and_slide()

func perish_violently():
	instrument.stop()
	if level != null:
		level.shake_camera()
		level.lose_fly(position)
	queue_free()


func _on_direction_switch_timer_timeout() -> void:
	rotation_momentum = randf_range(-rotation_momentum_max, rotation_momentum_max)
	switch_timer.wait_time = randf_range(0.25, 0.75)
	switch_timer.start()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	anim.play("fly")
