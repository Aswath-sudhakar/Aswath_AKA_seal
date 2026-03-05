extends Game

const GOODMONSTERS = 17
const good_monster_inst = preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Monsters/good_monster.tscn")
const bad_monster_inst = preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Monsters/bad_monster.tscn")
@onready var player_light: CharacterBody2D = $player_light
@onready var time_label: Label = $TimeLabel
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var jumpscare: Sprite2D = $Jumpscare
@onready var jumpscare_timer: Timer = $JumpscareTimer
@onready var winning_timer: Timer = $WinningTimer
@onready var lose_timer: Timer = $LoseTimer
@onready var drum_music: AudioStreamPlayer = $DrumMusic
@onready var bass_music: AudioStreamPlayer = $BassMusic
@onready var jump_scare_music: AudioStreamPlayer = $JumpScareMusic
@onready var flash_light: AudioStreamPlayer = $FlashLight
@onready var winning_music: AudioStreamPlayer = $WinningMusic
@onready var ui_timer: Timer = $UI/UITimer


var tile_positions : Array = [[580.945556640625, 367.124969482422], 
[612.945556640625, 351.124969482422], [644.945556640625, 335.124969482422], 
[676.945556640625, 319.124969482422], [708.945556640625, 303.124969482422], 
[676.945556640625, 287.124969482422], [644.945556640625, 271.124969482422], 
[612.945556640625, 255.124969482422], [580.945556640625, 239.124969482422], 
[548.945556640625, 223.124969482422], [516.945556640625, 239.124969482422], 
[484.945556640625, 255.124969482422], [452.945556640625, 271.124969482422], 
[420.945556640625, 287.124969482422], [388.945556640625, 303.124969482422], 
[356.945556640625, 319.124969482422], [324.945556640625, 335.124969482422], 
[292.945556640625, 351.124969482422], [260.945556640625, 367.124969482422], 
[228.945556640625, 383.124969482422], [260.945556640625, 399.124969482422], 
[292.945556640625, 383.124969482422], [324.945556640625, 367.124969482422], 
[356.945556640625, 351.124969482422], [388.945556640625, 335.124969482422], 
[420.945556640625, 319.124969482422], [452.945556640625, 303.124969482422], 
[484.945556640625, 287.124969482422], [516.945556640625, 271.124969482422], 
[548.945556640625, 255.124969482422], [580.945556640625, 271.124969482422], 
[548.945556640625, 287.124969482422], [516.945556640625, 303.124969482422], 
[484.945556640625, 319.124969482422], [452.945556640625, 335.124969482422], 
[420.945556640625, 351.124969482422], [388.945556640625, 367.124969482422], 
[356.945556640625, 383.124969482422], [324.945556640625, 399.124969482422], 
[292.945556640625, 415.124969482422], [324.945556640625, 431.124969482422], 
[356.945556640625, 415.124969482422], [388.945556640625, 399.124969482422], 
[420.945556640625, 383.124969482422], [452.945556640625, 367.124969482422], 
[484.945556640625, 351.124969482422], [516.945556640625, 335.124969482422], 
[548.945556640625, 319.124969482422], [580.945556640625, 303.124969482422], 
[612.945556640625, 287.124969482422], [644.945556640625, 303.124969482422], 
[612.945556640625, 319.124969482422], [580.945556640625, 335.124969482422], 
[548.945556640625, 351.124969482422], [516.945556640625, 367.124969482422], 
[484.945556640625, 383.124969482422], [452.945556640625, 399.124969482422], 
[420.945556640625, 415.124969482422], [388.945556640625, 431.124969482422], 
[356.945556640625, 447.124969482422], [388.945556640625, 463.124969482422], 
[420.945556640625, 447.124969482422], [452.945556640625, 431.124969482422], 
[484.945556640625, 415.124969482422], [516.945556640625, 399.124969482422], 
[740.945556640625, 319.124969482422], [708.945556640625, 335.124969482422], 
[676.945556640625, 351.124969482422], [644.945556640625, 367.124969482422], 
[612.945556640625, 383.124969482422], [580.945556640625, 399.124969482422], 
[548.945556640625, 415.124969482422], [516.945556640625, 431.124969482422], 
[484.945556640625, 447.124969482422], [452.945556640625, 463.124969482422], 
[420.945556640625, 479.124969482422], [452.945556640625, 495.124969482422], 
[484.945556640625, 479.124969482422], [516.945556640625, 463.124969482422], 
[548.945556640625, 447.124969482422], [580.945556640625, 431.124969482422], 
[612.945556640625, 415.124969482422], [644.945556640625, 399.124969482422], 
[676.945556640625, 383.124969482422], [708.945556640625, 367.124969482422], 
[740.945556640625, 351.124969482422], [772.945556640625, 335.124969482422], 
[804.945556640625, 351.124969482422], [772.945556640625, 367.124969482422], 
[740.945556640625, 383.124969482422], [708.945556640625, 399.124969482422], 
[676.945556640625, 415.124969482422], [644.945556640625, 431.124969482422], 
[612.945556640625, 447.124969482422], [580.945556640625, 463.124969482422], 
[548.945556640625, 479.124969482422], [516.945556640625, 495.124969482422], 
[484.945556640625, 511.124969482422], [516.945556640625, 527.125], 
[548.945556640625, 511.125], [580.945556640625, 495.125], 
[612.945556640625, 479.125], [644.945556640625, 463.125], 
[676.945556640625, 447.125], [708.945556640625, 431.125], 
[740.945556640625, 415.125], [772.945556640625, 399.125], 
[804.945556640625, 383.125], [836.945556640625, 367.125], 
[868.945556640625, 383.125], [836.945556640625, 399.125], 
[804.945556640625, 415.125], [772.945556640625, 431.125], 
[740.945556640625, 447.125], [708.945556640625, 463.125], 
[676.945556640625, 479.125], [644.945556640625, 495.125], 
[612.945556640625, 511.125], [580.945556640625, 527.125], 
[548.945556640625, 543.125]]
# [548.945556640625, 383.124969482422] # player's starting tile

var available_tiles : Array
var win : bool = false
var on_good : bool = false
var on_bad : bool = false
var game_started : bool = false

var distanceToMonster : Vector2
var badMonsterLocation : Vector2
var music_radius : float = 110
var current_music_state : int = 0
var music_play : bool = true

var BassMusicArray : Array = [preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Music/Sound Stuff/Calm Music/bass calm stem.wav"), 
preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Music/Sound Stuff/Stress Music/bass stress.wav"),
preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Music/Sound Stuff/Monster Music/bass monster.wav")
]

var DrumMusicArray : Array = [preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Music/Sound Stuff/Calm Music/drums calm stem.wav"), 
preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Music/Sound Stuff/Stress Music/drums stress stems.wav"),
preload("res://Frameworks(YourStuff)/Scary_Music_Jam/Music/Sound Stuff/Monster Music/drums monster stems.wav") 
]

func _start_game(): 	
	await ui_timer.timeout
	game_started = true
	tile_positions.shuffle() # shuffles possible positions
	for monsters in range(1,GOODMONSTERS+1): # loops over how many good monsters
		inst_monster(monsters, good_monster_inst)
	inst_monster(0, bad_monster_inst) # creates one bad monster
	badMonsterLocation = Vector2(tile_positions[0][0], tile_positions[0][1])
	canvas_modulate.set_color(Color(0.1333, 0.1333, 0.1333, 1.0)) # dark color: (0.1333, 0.1333, 0.1333, 1.0)
	lose_timer.wait_time = clampi((12/ get_intensity()),6,12)
	print(get_intensity())
	print(lose_timer.wait_time)
	lose_timer.start()
	time_label.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	time_label.text = str(int(lose_timer.time_left))
	var distance : float = badMonster_difference_Player().length()
	
	if music_play:
		if !(drum_music.playing and bass_music.playing):
			drum_music.play()
			bass_music.play()
		if distance <= 4.0 and current_music_state != 2:
			set_music(2)
		elif distance > 4.0 and distance <= music_radius and current_music_state != 1:
			set_music(1)
		elif !(distance <= music_radius) and current_music_state != 0:
			set_music(0)

# Sets the music and music state
func set_music(index: int):
	drum_music.set_stream(DrumMusicArray[index])
	bass_music.set_stream(BassMusicArray[index])
	drum_music.play()
	bass_music.play()
	current_music_state = index
	
#Finds cordinate difference from player and bad monster
func badMonster_difference_Player() -> Vector2:
	distanceToMonster = badMonsterLocation - player_light.global_position
	return distanceToMonster

func inst_monster(index: int, monster: PackedScene) -> Node2D:
	var instance = monster.instantiate()
	add_child(instance)
	instance.global_position.x = tile_positions[index][0] # sets monsters position
	instance.global_position.y = tile_positions[index][1]
	return instance

# On spacebar click it play flashnight noise and sees if it is on bad monster or good
func spacebar_hit():
	flash_light.play()
	if on_bad:
		win = true
		lose_timer.timeout.emit()
	elif on_good:
		lose_timer.timeout.emit()
	# else: nothing happens
	
# When timer timesout it checks to see if player won or lost
func _on_lose_timer_timeout() -> void:
	music_play = false
	bass_music.stop()
	drum_music.stop()
	if not win:
		canvas_modulate.set_color(Color(0.71,0.71,0.71,1))
		jumpscare.visible = true
		jump_scare_music.play()
		jumpscare_timer.start()
	else:
		await get_tree().create_timer(0.2).timeout
		winning_timer.start()
		winning_music.play()
		#get_tree().reload_current_scene()

func _on_jumpscare_timer_timeout() -> void:
	end_game.emit(false)


func _on_winning_timer_timeout() -> void:
	end_game.emit(true)
