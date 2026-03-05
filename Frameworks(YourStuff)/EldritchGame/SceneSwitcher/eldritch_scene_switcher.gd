extends Node2D

const PLANET_GAME = preload("uid://wimvir2g37io")
const MOUSE_CURSOR = preload("uid://bog33u2o2xq6k")

var easy_levels : Array[PackedScene] = [PLANET_GAME]
var hard_levels : Array[PackedScene] = []
var time : float = 10.0
var max_time : float
var current_scene : PackedScene
var won_levels : int = 0
var levels_to_win : int = 3

@onready var disappear: Node2DEffect = %Disappear
@onready var appear: Node2DEffect = %Appear
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar as TextureProgressBar
@onready var timer: Timer = $Timer as Timer
@onready var time_left_notifier: ControlNodeEffectSequencer = $TextureProgressBar/TimeLeftNotifier as ControlNodeEffectSequencer
@onready var fade_player: Node2DEffectSequencer = %FadePlayer

func _ready() -> void:
	Input.set_custom_mouse_cursor(MOUSE_CURSOR)
	switch_scene(easy_levels.pick_random(), null)
	max_time = time * 100 * 2
	texture_progress_bar.max_value = max_time
	timer.start(time)

#region scene switching
func switch_scene(new_scene : PackedScene, old_scene : Node) -> bool:
	# fading out
	appear.do_tween()
	await appear.tween.finished
	# deleting old scene
	get_tree().paused = true
	if old_scene != null:
		old_scene.queue_free()
		if old_scene.is_inside_tree():
			await old_scene.tree_exited
	# adding new scene
	var eldritch_game : EldritchGame = new_scene.instantiate() as EldritchGame
	current_scene = new_scene
	# binding bubble_game to scene switching request so that we dont have to do signal.emit(self)
	eldritch_game.reload_scene.connect(_on_reload_scene_request.bind(eldritch_game))
	eldritch_game.switch_to_new_scene.connect(_on_switch_scene_request.bind(eldritch_game))
	add_child(eldritch_game)
	# fading in
	disappear.do_tween()
	await disappear.tween.finished
	get_tree().paused = false
	return true

func _on_reload_scene_request(old_scene : Node) -> void:
	timer.paused = true
	await switch_scene(current_scene, old_scene)
	timer.paused = false

func _on_switch_scene_request(old_scene : Node) -> void:
	hard_levels.shuffle()
	var new_scene : PackedScene = hard_levels.pop_front()
	timer.start(time)
	timer.paused = true
	won_levels += 1
	if won_levels >= levels_to_win:
		win_game()
		return
	await switch_scene(new_scene, old_scene)
	timer.paused = false
	timer.start(time)
	
#endregion

#region game win/lose state
func _process(_delta: float) -> void:
	texture_progress_bar.value = timer.time_left * 100 * 2
	if (
		int(texture_progress_bar.value) % int(max_time / 4) >= -10 and 
		int(texture_progress_bar.value) % int(max_time / 4) <= 10
		):
		if time_left_notifier.is_running:
			return
		time_left_notifier.do_effect_sequence()

func win_game():
	print("you won!")
	transition_out()

func lose_game():
	print("you lost!")
	transition_out()

func transition_out():
	
	get_tree().paused = true
	appear.do_tween()
	await appear.tween.finished
	get_tree().paused = false
	Input.set_custom_mouse_cursor(null)
	# TODO: Switch this out for emitting game lost
	get_tree().quit()

func _on_timer_timeout() -> void:
	lose_game()
#endregion
