class_name EldritchEndingScreen extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func do_ending() -> void:
	get_tree().paused = true
	animation_player.play("exit-jame")
	await animation_player.animation_finished
	get_tree().paused = false
