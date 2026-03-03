class_name EldritchInstructionScreen extends Node2D
@onready var dissapear: Node2DEffect = $Dissapear
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	get_tree().paused = true
	animated_sprite_2d.play('new_animation')
	#animation_player.play("intro")



func do_introduction() -> void:
	await get_tree().create_timer(2.0).timeout
	dissapear.do_tween()
	await dissapear.tween.finished
	get_tree().paused = false
