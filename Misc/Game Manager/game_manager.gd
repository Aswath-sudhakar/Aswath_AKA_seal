class_name GameManager extends Node

const COVERUP = preload("res://Misc/Transitions/coverup/coverup.tscn")

@onready var start_point: Marker2D = $StartPoint
@onready var play_point: Marker2D = $PlayPoint
@onready var end_point: Marker2D = $EndPoint
#@onready var global_ui_container: GlobalUI = $GlobalUIContainer
@onready var global_ui_container: GlobalUI = $Control
@onready var transition_manager: TransitionManager = $TransitionManager


const TRANS_TIME = 1.0
## List of all available games to play
const BASEPLATE = preload("res://Frameworks(YourStuff)/BasePlate/Baseplate.tscn")
const VANDALISM_JUDE_ = preload("res://Frameworks(YourStuff)/Jude/ShakeColors/Vandalism(Jude).tscn")
const TRICK_TAPE = preload("res://Frameworks(YourStuff)/TrickTape/Main/game_main.tscn")
const TROLLEY_MAIN_SCENE = preload("res://Frameworks(YourStuff)/TrolleyProblem/trolley_main_scene.tscn")
const ROCK_SKIP = preload("res://Frameworks(YourStuff)/rock-skpping/ww_game.tscn")
const TYSON = preload("res://Frameworks(YourStuff)/Connor/main.tscn")
const FINISH_HIM = preload("res://Frameworks(YourStuff)/Kevin/FinishHim/scenes/game_container.tscn")
const REPAIR = preload("res://Frameworks(YourStuff)/Kevin/Repair/scenes/game_container.tscn")
const SWAT = preload("res://Frameworks(YourStuff)/Kevin/Swat/scenes/game.tscn")
const MIX_PAINT_JUDE_ = preload("res://Frameworks(YourStuff)/Jude/MixColors/MixPaint(Jude).tscn")
const EXAMPLE_SCENE_MUSIC = preload("res://ProoblesToys(PolishTools)/Music/ExampleSceneMusic.tscn")
const PONG = preload("res://Frameworks(YourStuff)/Pong;)/scenes/main.tscn")
const PLANET_GAME = preload("res://Frameworks(YourStuff)/EldritchGame/EldritchGameMain/planet_game.tscn")
const SEAL_GAME = preload("uid://bvuvngqyv3pri")
const SCARY_GAME = preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Main/Main.tscn")
const MALL = preload("res://Frameworks(YourStuff)/Mall/MainMallGame.tscn")

var all_games : Array[PackedScene] = [BASEPLATE, MALL, SWAT, REPAIR, PLANET_GAME, PONG, VANDALISM_JUDE_, ROCK_SKIP, TYSON,FINISH_HIM, MIX_PAINT_JUDE_, SCARY_GAME, SEAL_GAME]

## List of games left to play this stage before time scale increases
var games_to_play_this_stage : Array[PackedScene]
var score : int = 0
var lives = 3
var game_intensity : float = 1.0
const ENGINE_SPEED_INCREASE = 0.2
const SPEED_UP_POINT = 2

@onready var old_scene : Game = $TransitionManager/SubViewportContainer/SubViewport/Game
var new_scene : Game = null

func _ready() -> void:
	return
#region Loader of files in Games folder

	#var path = "res://Games(DragPlayableGamesHere)/"
	#var dir_access := DirAccess.open(path)
	#
	#dir_access.list_dir_begin()
	#var file_name := dir_access.get_next()
	#while file_name != "":
		#if not dir_access.current_is_dir() and file_name.get_extension() == "tscn":
			#var full_path := path.path_join(file_name)
			#
			#var scene: PackedScene = load(full_path)
			#if scene:
				#all_games.append(scene)
		#file_name = dir_access.get_next()
		#dir_access.list_dir_end()
	#games_to_play_this_stage = all_games.duplicate()
#endregion
	
	
	

func start_games():
	lives = 3
	score = 0
	games_to_play_this_stage = all_games.duplicate()
	switch_scene('won', false) ##TODO make a start scene
	global_ui_container.set_lives(lives)

func _on_game_ended(won : bool):
	var scene_to_switch = 'won'
	if won:
		score += 1
	else:
		scene_to_switch = 'lost'
		lives -= 1
		if lives <= 0:
			Director.highscore = score
			print('lost')
		global_ui_container.set_lives(lives)
	
	global_ui_container.show_win_status(won)
	global_ui_container.set_score(score)
	
	if games_to_play_this_stage.is_empty():
		global_ui_container.set_lvl_intensity(game_intensity)
		games_to_play_this_stage = all_games.duplicate()
	
	var intensity_up = false
	print(games_to_play_this_stage.size() % SPEED_UP_POINT)
	if games_to_play_this_stage.size() % SPEED_UP_POINT == 0:
		game_intensity += ENGINE_SPEED_INCREASE
		intensity_up = true
		
	
	old_scene.call_deferred("set_process_mode", 4)
	
	switch_scene(scene_to_switch, intensity_up)

func switch_scene(type: String, intensity_up : bool = false):
	await RenderingServer.frame_post_draw
	var view_texture = get_viewport().get_texture().get_image()
	var coverup :CoverUp = COVERUP.instantiate()
	coverup.coverup_image(view_texture)
	add_child(coverup)
	old_scene.queue_free()
	await old_scene.tree_exited
	old_scene = coverup
	
	var next_game : PackedScene = games_to_play_this_stage.pick_random()
	games_to_play_this_stage.erase(next_game)
	var new_game : Game = next_game.instantiate()
	add_child.call_deferred(new_game)

	await new_game.ready
	new_scene = new_game
	new_game.end_game.connect(_on_game_ended)
	transition_manager.transition(old_scene, new_game, type, score, lives, intensity_up)
	new_game.process_mode = Node.PROCESS_MODE_DISABLED

func _on_transition_manager_transition_finished() -> void:
	new_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
	new_scene._start_game()
	old_scene = new_scene
