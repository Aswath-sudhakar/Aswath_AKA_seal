extends Node

signal transition_finished

#WIN TRANSITIONS
const FIRST_WIN = preload("res://Misc/Transitions/WinScreens/FirstWin.tscn")

var win_transitions :Array[PackedScene] = [FIRST_WIN]

#LOSE TRANSITIONS
const LOSE_CHOMP = preload("res://Misc/Transitions/LoseScreens/LoseChomp.tscn")

var lost_transitions : Array[PackedScene] = [LOSE_CHOMP]

func transition(old_game:Game, new_game:Game, won : bool, score: int, lives : int):
	var trans_scene : Transition
	if won:
		trans_scene = win_transitions.pick_random().instantiate()
	else:
		trans_scene = lost_transitions.pick_random().instantiate()
	
	add_child.call_deferred(trans_scene)
	await trans_scene.ready
	trans_scene.set_new_scene_to_move(new_game)
	trans_scene.set_old_scene_to_move(old_game)
	trans_scene.transition_finished.connect(_transition_finished)  #signals up to game manager
	trans_scene._start_transition(score, lives)

func _transition_finished(): 
	transition_finished.emit() #signals up to game manager
	
