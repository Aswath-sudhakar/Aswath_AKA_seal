extends Game

@onready var drum_button: Button = $Buttons/DrumButton
@onready var guitar_button: Button = $Buttons/GuitarButton
@onready var horn_button: Button = $Buttons/HornButton
@onready var bass_button: Button = $Buttons/BassButton
@onready var piano_button: Button = $Buttons/PianoButton

@onready var all_players = [drum_button, guitar_button, horn_button, bass_button, piano_button]
@onready var background_darkness: DirectionalLight2D = $BackgroundDarkness

var needed_players = []
var current_players = []
@onready var buttons: Node2D = $Buttons
@onready var light_character: CharacterBody2D = $LightCharacter
@onready var game_timer: Timer = $GameTimer
@onready var win_animation: AnimatedSprite2D = $WinAnimation
@onready var lose_animation: AnimationPlayer = $LoseAnimation
@onready var start_animation: AnimationPlayer = $StartAnimation



func _start_game():
	start_animation.play("start")
	await start_animation.animation_finished
	
	for i in clamp(roundi(get_intensity()),0,all_players.size()): #the more intense it is the more people get selected
		var chosen_one = all_players.pick_random()
		needed_players += [chosen_one]#this function is automatically called when the scene transitions in
		chosen_one.show_circ()
		print(chosen_one)
	
	await get_tree().create_timer(2.0).timeout
	switch_the_lights()
	game_timer.start()

func switch_the_lights():
	var status = background_darkness.visible
	
	if status:
		background_darkness.hide()
		light_character.hide()
		$Bar.hide()
	else:
		background_darkness.show()
		light_character.show()
		$Bar.show()

func add_player(player):
	if !current_players.has(player):
		current_players += [player]


func _on_game_timer_timeout() -> void:
	print(needed_players, " ", current_players)
	light_character.hide()
	buttons.hide()
	$Bar.hide()
	await get_tree().create_timer(2.0).timeout
	background_darkness.hide()
	if needed_players == current_players:
		win_animation.show()
		win_animation.play("default")
	else:
		lose_animation.play("lose_anim")
		lose_animation.get_child(0).show()
	$Bar.show()
	
	await get_tree().create_timer(2.5).timeout
	end_game.emit((needed_players == current_players))
