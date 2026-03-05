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
@onready var adaptive_music: Node = $Buttons/AdaptiveMusic
@onready var lighton: AudioStreamPlayer = $StageBackground/lighton
@onready var lightoff: AudioStreamPlayer = $StageBackground/lightoff
@onready var stage_light: PointLight2D = $Bar/Light/PointLight2D

func _start_game():
	start_animation.play("start")
	await start_animation.animation_finished
	
	for i in clamp(roundi(get_intensity() + 1),0,all_players.size()): #the more intense it is the more people get selected
		var chosen_one = all_players.pick_random()
		needed_players += [chosen_one]#this function is automatically called when the scene transitions in
		chosen_one.show_circ()
		print(chosen_one)
	adaptive_music.start()
	
	await get_tree().create_timer(2.0).timeout
	$"Buttons/AdaptiveMusic/5".volume_db = -10
	lightoff.play(2.2)
	stage_light.show()
	background_darkness.show()
	light_character.show()
	$Bar.show()
	game_timer.start()

func _process(delta: float) -> void:
	if !game_timer.is_stopped():
		$GameTimer/TextureProgressBar.value = (10-game_timer.time_left)/10
	
func add_player(player):
	if !current_players.has(player):
		current_players += [player]


func _on_game_timer_timeout() -> void:
	$GameTimer/TextureProgressBar.hide()
	light_character.hide()
	buttons.hide()
	lightoff.pitch_scale = .8
	lightoff.play(2.2)
	$Bar.hide()
	await get_tree().create_timer(2.0).timeout
	lighton.play(2.1)
	background_darkness.hide()
	if needed_players == current_players:
		win_animation.show()
		win_animation.play("default")
	else:
		lose_animation.play("lose_anim")
		lose_animation.get_child(0).show()
	$Bar.show()

func _on__finished() -> void:
	end_game.emit((needed_players == current_players))
	print('done')
