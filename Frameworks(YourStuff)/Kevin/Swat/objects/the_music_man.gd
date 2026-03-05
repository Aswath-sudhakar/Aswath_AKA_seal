extends Node2D

@onready var audio = $"AudioStreamPlayer"

signal beat

var level: Node

var current_beat_index: int = 0
var last_beat_index: int = 0

func _ready() -> void:
	if get_parent():
		level = get_parent()
		connect("beat", level.swat)

func _process(_delta: float) -> void:
	current_beat_index = int(audio.get_playback_position() * 2)
	
	if current_beat_index > last_beat_index or current_beat_index == 0 and last_beat_index > current_beat_index:
		emit_signal("beat")
		last_beat_index = current_beat_index

func start():
	audio.play()

func stop():
	pass
	#audio.stop()
