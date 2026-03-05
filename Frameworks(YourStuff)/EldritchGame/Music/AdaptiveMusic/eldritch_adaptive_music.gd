class_name EldritchAdaptiveMusic extends Node

signal half_bar
signal half_beat
signal beat
signal current_bar
signal current_four_bar
signal current_eight_bar
signal fuck
@export var master_track : AudioStreamPlayer
@export var intro : AudioStreamPlayer
@export var win_outro : AudioStreamPlayer
@export var lose_outro : AudioStreamPlayer

@export var bpm: float = 159.0

var beat_duration: float
var current_beat_index : int = 0 
var last_beat_index: int = 0
var bar_index: int = 0

var progress_bar_pos = Vector2(11,231)

func _ready() -> void:
	start()

func _process(_delta: float) -> void:

	
	if !master_track.playing:
		return
	
	current_beat_index = int(master_track.get_playback_position() / beat_duration)
	
	if !(current_beat_index > last_beat_index or current_beat_index == 0 and last_beat_index > current_beat_index):
		return
	
	half_beat.emit()
	last_beat_index = current_beat_index
	bar_index += 1
	if bar_index % 2 == 0:
		beat.emit()
	if bar_index % 4 == 2:
		fuck.emit()
	if bar_index % 4 == 0:
		half_bar.emit()
	if bar_index % 8 == 0:
		current_bar.emit()
	if bar_index % (8 * 4) == 0:
		current_four_bar.emit()
	if bar_index % (8 * 4 * 2) == 0:
		current_eight_bar.emit()

func start():
	beat_duration = 60.0 /bpm
	if !master_track.is_node_ready():
		await master_track.ready
	
	if !intro.is_node_ready():
		await intro.ready
	
	intro.play()
	await intro.finished
	master_track.play()
	
func lose():
	await current_bar
	master_track.stop()
	lose_outro.play()

func win():
	await current_bar
	master_track.stop()
	win_outro.play()
