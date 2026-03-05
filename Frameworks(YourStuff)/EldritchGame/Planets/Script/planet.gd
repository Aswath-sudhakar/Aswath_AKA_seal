class_name Planet extends Node2D

@warning_ignore('unused_signal') signal planet_eaten
@onready var node_2d_effect: Node2DEffect = %Node2DEffect
@onready var beat_effect: Node2DEffect = %BeatEffect

var already_eaten : bool = false

var texture_array : Array[Texture2D]

func do_beat_effect() -> void:
	beat_effect.do_tween()


func die() -> void:
	node_2d_effect.do_tween()
	await node_2d_effect.tween.finished
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is EatingZone and not already_eaten:
		(get_parent() as EldritchParticleFollow).is_being_eaten = true
		z_index += 2
		(area as EatingZone).planet_suck.emit(self)
		already_eaten = true
