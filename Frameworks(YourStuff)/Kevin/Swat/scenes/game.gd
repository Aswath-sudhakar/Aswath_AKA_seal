extends Game

@onready var swatter = $"Swatter"
@onready var anim = $"AnimationPlayer"
@onready var music_man = $"The Music Man"
@onready var splash_text = $"Splash Text"
@onready var mouse_text = $"Move Mouse Text"

@onready var vignette = $"Vignette"

@onready var next_game_timer = $"Next Game Timer"

@onready var impending_doom = $"Impending Doom"
@onready var impending_doom_anim = $"Impending Doom/AnimationPlayer"

@onready var win_sound = $"Win Sound"

var won = true

var ready_to_win = false

var in_danger = false

var flies = 0

var swats_left = 24

const DANGER_THRESH = 8

var stupid_little_fly = preload("res://Frameworks(YourStuff)/Kevin/Swat/objects/jerks/stupid_little_fly.tscn")

var fly_splat = preload("res://Frameworks(YourStuff)/Kevin/Swat/objects/jerks/death_splat.tscn")
var fly_part = preload("res://Frameworks(YourStuff)/Kevin/Swat/objects/jerks/death_part.tscn")
var fly_guts = preload("res://Frameworks(YourStuff)/Kevin/Swat/objects/jerks/fly_guts.tscn")

var ultra_hardcore_difficulty = 1.0

func _start_game():
	start(get_intensity())

func start(diff: float):
	if diff < 1.1:
		mouse_text.start()
	ultra_hardcore_difficulty = diff
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	flies = 8
	for i in flies:
		var larva = stupid_little_fly.instantiate()
		add_child(larva)
		larva.position = Vector2(randi_range(-150, 150), randi_range(-100, 100))
		larva.call_deferred("play_instrument", i, false)
	music_man.start()
	splash_text.start()
	vignette.start()

func _physics_process(_delta: float) -> void:
	if !won:
		var larva = stupid_little_fly.instantiate()
		add_child(larva)
		larva.position = Vector2(randi_range(-150, 150), randi_range(-100, 100))
		larva.call_deferred("play_instrument", randi_range(0, 2), true)

func shake_camera():
	anim.play("shake_" + str(randi_range(1, 3)))

func lose_fly(death_pos: Vector2):
	# splat
	var new_splat = fly_splat.instantiate()
	add_child(new_splat)
	new_splat.position = death_pos
	# eyes and wings
	for i in 2:
		for j in 2:
			var new_part = fly_part.instantiate()
			call_deferred("add_child", new_part)
			new_part.position = death_pos
			new_part.call_deferred("spawn_by_parent", i == 1, j)
	# guts
	var new_guts = fly_guts.instantiate()
	add_child(new_guts)
	new_guts.position = death_pos
	new_guts.initial_velocity_min *= -1
	new_guts.restart()
	flies = move_toward(flies, 0, 1)
	if flies == 0 and won:
		win_anim()

func swat():
	swats_left = move_toward(swats_left, 0, 1)
	if swats_left == DANGER_THRESH:
		in_danger = true
		impending_doom_anim.play("behold")
		impending_doom.play()
	if !swats_left:
		lose()
	if swatter != null:
		swatter.swat()
	if in_danger:
		vignette.blink()
	
	if ready_to_win:
		win_sound.play()
		ready_to_win = false

func win_anim():
	swats_left = 200
	impending_doom.stop()
	next_game_timer.start()
	splash_text.clear()
	mouse_text.go_away()
	music_man.stop()
	ready_to_win = true
	in_danger = false


func _on_next_game_timer_timeout() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("end_game", won)


func lose() -> void:
	if won:
		won = false
		next_game_timer.start()
		splash_text.infestation()
		mouse_text.go_away()
		vignette.stick_around()
