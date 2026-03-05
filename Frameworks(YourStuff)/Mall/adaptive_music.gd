extends Node

#these are what you are going to use
signal current_beat
signal current_bar
signal current_four_bar
signal current_eight_bar

@export var tracks : Array[AudioStreamPlayer]
@export var bpm: float = 159.0

var progress_bar: ProgressBar 
@onready var master_track = tracks[0]

var beat_duration: float # per second number
var current_beat_index = 0 #current beat during the song
var last_beat_index: int = 0
var bar_index: int = 0

var progress_bar_pos = Vector2(11,231)
func _ready() -> void:
	progress_bar = ProgressBar.new()
	add_child(progress_bar)
	progress_bar.fill_mode = ProgressBar.FILL_TOP_TO_BOTTOM
	progress_bar.position = progress_bar_pos
	progress_bar.size = Vector2(20,300)
	
	beat_duration = 60.0 /bpm

func _process(_delta: float) -> void:
	if !master_track.playing: return
	
	current_beat_index = int(master_track.get_playback_position() / beat_duration)
	
	if current_beat_index > last_beat_index or current_beat_index == 0 and last_beat_index > current_beat_index:
		emit_signal("current_beat")
		last_beat_index = current_beat_index
		bar_index += 1
		if bar_index % 4 == 0: emit_signal("current_bar")
		if bar_index % (4 * 4) == 0:emit_signal("current_four_bar")
		if bar_index % (4 * 4 * 2) == 0:emit_signal("current_eight_bar")

func start(time_to_start : float = 0.0):
	for i in tracks:
		i.play(time_to_start)
	
	master_track = tracks[0]
	
	await master_track.ready
	
	var measure_duration = 4.0 * beat_duration #assuming 4/4 time
	var current_time = master_track.get_playback_position()
	var sync_time = fmod(current_time, measure_duration)
	
	for i in range(1, tracks.size()):
		var follower_track = tracks[i]
		follower_track.seek(sync_time)

func stop():
	for i in tracks:
		i.stop()
	
func increase_volume(idx: int, volume : float, fade_duration: float, on_beat :float):
	if !master_track.playing: return
	
	if idx >= tracks.size(): 
		print("AINT NO DAMN TRACK EXISTS")
		return
	
	var current_time = master_track.get_playback_position()
	var measure_duration = beat_duration * on_beat
	
	var time_untill_sync = measure_duration - fmod(current_time, measure_duration)
	
	if progress_bar:
		var tween_bar = get_tree().create_tween()
		tween_bar.tween_property(progress_bar, "value", 100.0, time_untill_sync) #debug
		
		await tween_bar.finished
		var tween = get_tree().create_tween()
		tween.tween_property(tracks[idx], "volume_db", volume, fade_duration)
		
		progress_bar.position.y += 5
		var twee = get_tree().create_tween().tween_property(progress_bar,'position', progress_bar_pos, 1.0).set_trans(tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		var fina_rot = progress_bar.rotation
		progress_bar.rotation += .05
		var twee2 = get_tree().create_tween().tween_property(progress_bar,'rotation', 0.0, 2.0).set_trans(tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		progress_bar.value = 0.0
