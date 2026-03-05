extends Transition

@onready var start_point: Marker2D = $StartPoint
@onready var play_point: Marker2D = $PlayPoint
@onready var end_point: Marker2D = $EndPoint
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var lives_text: RichTextLabel = $Lives
@onready var score_text: RichTextLabel = $Score

func _start_transition(score, lives):
	if not is_inside_tree():
		await tree_entered
		
	score_text.text = "Score: " + str(score)
	lives_text.text = "Lives: " + str(lives)
	#new_scene_to_move.global_position = start_point.global_position
	#var tween_old = create_tween()
	#tween_old.tween_property(old_scene_to_move, 'global_position', end_point.global_position, 1.1)
	#
	#var tween_new = create_tween()
	#tween_new.tween_property(new_scene_to_move, 'global_position', play_point.global_position, 1.1)
	#await tween_old.finished
	animated_sprite_2d.play("default")
	await animated_sprite_2d.animation_finished
	safe_remove(old_scene_to_move)
	transition_finished.emit()


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.frame == 28:
		lives_text.show()
		score_text.show()
		old_scene_to_move.global_position = end_point.global_position
		new_scene_to_move.global_position = play_point.global_position
	
	if animated_sprite_2d.frame == 65:
		lives_text.hide()
		score_text.hide()
