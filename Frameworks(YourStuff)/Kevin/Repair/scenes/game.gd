extends Node3D

@onready var placement_indic = $"Placement Indicator"
@onready var placement_mesh = $"Placement Indicator/block_cursor"
@onready var sun = $"Sun"

@onready var screen_darkener = $"CanvasLayer/Control/Screen Darkener"
@onready var win_camera = $"Win Camera Pivot"
@onready var crosshair = $"CanvasLayer/Control/Crosshair"
@onready var blocks_left = $"CanvasLayer/Control/Blocks Left"
@onready var time_left = $"CanvasLayer/Control/Time Left"
@onready var controls = $"CanvasLayer/Control/Controls"
@onready var repair = $"CanvasLayer/Control/Repair"

@onready var blocks_left_img = $"CanvasLayer/Control/Blocks Left Img"
@onready var time_left_img = $"CanvasLayer/Control/Time Left Img"

@onready var blocks_left_anim = $"CanvasLayer/Control/Blocks Left Img/AnimationPlayer"
@onready var time_left_anim = $"CanvasLayer/Control/Time Left Img/AnimationPlayer"

@onready var win_anim_timer = $"Win Anim Timer"
@onready var lose_anim_timer = $"Lose Anim Timer"
@onready var time_left_timer = $"Time Left Timer"
@onready var next_game_timer = $"Next Game Timer"
@onready var world_break_timer = $"World Breaking Timer"

@onready var sound_build = $"Build"
@onready var sound_break = $"Break"
@onready var sound_build_correct = $"Build Correct"
@onready var music = $"Music"
@onready var music_fade = $"Music/Fade"
@onready var fader = $"Fader"

@onready var loading_screen = $"CanvasLayer/Control/Loading Screen"

var block_break_particle = preload("res://Frameworks(YourStuff)/Kevin/Repair/objects/block_particle.tscn")
var block_place_particle = preload("res://Frameworks(YourStuff)/Kevin/Repair/objects/success_particle.tscn")

var level_references = [
	preload("res://Frameworks(YourStuff)/Kevin/Repair/scenes/demo_level.tscn"),
	preload("res://Frameworks(YourStuff)/Kevin/Repair/scenes/cozy_valley.tscn"),
	preload("res://Frameworks(YourStuff)/Kevin/Repair/scenes/verdant_forest.tscn"),
	preload("res://Frameworks(YourStuff)/Kevin/Repair/scenes/gusty_gulch.tscn")
]

var music_references = [
	preload("res://Frameworks(YourStuff)/Kevin/Repair/audio/Shining_Voxels.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Repair/audio/Shining_Voxels_Ending_1.wav"),
	preload("res://Frameworks(YourStuff)/Kevin/Repair/audio/Shining_Voxels_Ending_2.wav")
]

var grid_map: kevincraft_level_base
var player: CharacterBody3D

var game_container: Game

var won = false

var update_tutorial = true

var seconds_left = 25

var ultra_hardcore_difficulty: float

var tutorial_segment = 0

var break_world_height = 18

enum TUTORIAL_TEXTS {
	blank,
	walk, jump,
	build, mine,
	repair,
	win, timeout, fall
}

var tutorials = [
	"WASD to move!",
	"WASD to move!", "SPACE to jump!",
	"Right click to build!", "Left click to break!",
	"Repair the house!",
	"House repaired!", "Time's up...", "You fell..."
]

# remove method later
func _ready() -> void:
	if !InputMap.has_action("kevincraft_keyboard"):
		# up
		var up = InputEventKey.new()
		up.keycode = KEY_W
		var up2 = InputEventKey.new()
		up2.keycode = KEY_UP
		InputMap.add_action("kevincraft_up")
		InputMap.action_add_event("kevincraft_up", up)
		InputMap.action_add_event("kevincraft_up", up2)
		
		# left
		var left = InputEventKey.new()
		left.keycode = KEY_A
		var left2 = InputEventKey.new()
		left2.keycode = KEY_LEFT
		InputMap.add_action("kevincraft_left")
		InputMap.action_add_event("kevincraft_left", left)
		InputMap.action_add_event("kevincraft_left", left2)
		
		# down
		var down = InputEventKey.new()
		down.keycode = KEY_S
		var down2 = InputEventKey.new()
		down2.keycode = KEY_DOWN
		InputMap.add_action("kevincraft_down")
		InputMap.action_add_event("kevincraft_down", down)
		InputMap.action_add_event("kevincraft_down", down2)
		
		# right
		var right = InputEventKey.new()
		right.keycode = KEY_D
		var right2 = InputEventKey.new()
		right2.keycode = KEY_RIGHT
		InputMap.add_action("kevincraft_right")
		InputMap.action_add_event("kevincraft_right", right)
		InputMap.action_add_event("kevincraft_right", right2)
		
		# the everything button
		InputMap.add_action("kevincraft_keyboard")
		InputMap.action_add_event("kevincraft_keyboard", up)
		InputMap.action_add_event("kevincraft_keyboard", up2)
		InputMap.action_add_event("kevincraft_keyboard", left)
		InputMap.action_add_event("kevincraft_keyboard", left2)
		InputMap.action_add_event("kevincraft_keyboard", down)
		InputMap.action_add_event("kevincraft_keyboard", down2)
		InputMap.action_add_event("kevincraft_keyboard", right)
		InputMap.action_add_event("kevincraft_keyboard", right2)
		
		# jump
		var jump = InputEventKey.new()
		jump.keycode = KEY_SPACE
		InputMap.add_action("kevincraft_jump")
		InputMap.action_add_event("kevincraft_jump", jump)
		
		# break
		var destroy = InputEventMouseButton.new()
		destroy.button_index = MOUSE_BUTTON_LEFT
		InputMap.add_action("kevincraft_break")
		InputMap.action_add_event("kevincraft_break", destroy)
		
		# place
		var place = InputEventMouseButton.new()
		place.button_index = MOUSE_BUTTON_RIGHT
		InputMap.add_action("kevincraft_place")
		InputMap.action_add_event("kevincraft_place", place)

func start_game(new_difficulty: float):
	ultra_hardcore_difficulty = new_difficulty
	if ultra_hardcore_difficulty < 1.1:
		tutorial_segment = TUTORIAL_TEXTS.build - 1
	else:
		tutorial_segment = TUTORIAL_TEXTS.walk - 1
	progress_tutorial()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	grid_map = level_references[pick_level()].instantiate()
	add_child(grid_map)
	grid_map.start()
	player = grid_map.get_player()
	sun.start()
	time_left_timer.start()
	repair.start()
	music.play()
	player.process_mode = Node.PROCESS_MODE_INHERIT
	loading_screen.hide()

func _physics_process(_delta: float) -> void:
	if update_tutorial:
		if tutorial_segment == TUTORIAL_TEXTS.walk:
			if Input.is_action_just_pressed("kevincraft_keyboard"):
				progress_tutorial()
		elif tutorial_segment == TUTORIAL_TEXTS.jump:
			if Input.is_action_just_pressed("kevincraft_jump"):
				progress_tutorial()

func progress_tutorial():
	tutorial_segment += 1
	controls.text = "[center]" + tutorials[tutorial_segment] + "[/center]"

func pick_level() -> int:
	if ultra_hardcore_difficulty < 1.1:
		return 1
	elif ultra_hardcore_difficulty < 1.3:
		return 2
	elif ultra_hardcore_difficulty < 1.5:
		return 3
	return randi_range(1, 3) # otherwise it's random!

func build_tile(tile_pos: Vector3i, tile: int):
	# places block if there's no block
	if grid_map.get_cell_item(tile_pos) == -1 and !does_player_intersect_block(tile_pos):
		# tutorial bit
		if update_tutorial and tutorial_segment == TUTORIAL_TEXTS.build:
			progress_tutorial()
		# actually build the block
		var random_pitch = randf_range(0.9, 1.1)
		if grid_map.build_block(tile_pos, tile):
			# you placed the right block!
			sound_build_correct.pitch_scale = random_pitch
			sound_build_correct.play()
			var new_particle = block_place_particle.instantiate()
			add_child(new_particle)
			new_particle.position = grid_map.map_to_local(tile_pos)
			new_particle.restart()
		sound_build.pitch_scale = random_pitch
		sound_build.play()
		# turns grass into dirt underneath placed block
		if grid_map.get_cell_item(Vector3i(tile_pos.x, tile_pos.y - 1, tile_pos.z)) == 0:
			grid_map.set_cell_item(Vector3i(tile_pos.x, tile_pos.y - 1, tile_pos.z), 1)

func does_player_intersect_block(raw_tile_pos: Vector3i) -> bool:
	var player_pos = player.global_position
	var tile_pos = grid_map.map_to_local(raw_tile_pos)
	if abs(player_pos.x - tile_pos.x) < 1.6:
		if abs(player_pos.z - tile_pos.z) < 1.6:
			if abs(player_pos.y - 0.5 - tile_pos.y) < 1.6 or abs(player_pos.y + 0.5 - tile_pos.y) < 1.6:
				return true
	return false

func break_tile(tile_pos: Vector3i, reduce_particles: bool):
	if grid_map.get_cell_item(tile_pos) != -1:
		# play particles (wow theme)
		if !reduce_particles:
			var new_particle = block_break_particle.instantiate()
			add_child(new_particle)
			new_particle.position = grid_map.map_to_local(tile_pos)
			new_particle.start(grid_map.get_cell_item(tile_pos))
		# break block
		sound_break.pitch_scale = randf_range(0.9, 1.1)
		sound_break.play()
		grid_map.set_cell_item(tile_pos, -1)
		# update tutorial
		if update_tutorial and tutorial_segment == TUTORIAL_TEXTS.mine:
			progress_tutorial()

func return_tile_pos(pos: Vector3) -> Vector3i:
	return grid_map.local_to_map(pos)

func center_in_tile(pos: Vector3) -> Vector3:
	return grid_map.map_to_local(grid_map.local_to_map(pos))

# should DEFINITELY be in the placement indicator node but I don't really care
func center_placement_indicator(pos: Vector3, norm: Vector3, display: bool):
	placement_indic.position = center_in_tile(pos)
	placement_indic.visible = display
	placement_mesh.rotation.x = PI/2 * norm.z
	if norm.y:
		placement_mesh.rotation.x = -PI/2 + PI/2 * norm.y
	placement_mesh.rotation.z = -PI/2 * norm.x
	placement_mesh.position = norm * -0.99

func update_blocks_left(blocks_remaining: int, total_blocks_remaining: int):
	blocks_left.text = "[right]" + str(total_blocks_remaining - blocks_remaining) + "/" + str(total_blocks_remaining) + "[/right]"
	if total_blocks_remaining != blocks_remaining:
		blocks_left_anim.stop(true)
		blocks_left_anim.play("boing")

func win_game():
	won = true
	if update_tutorial:
		update_tutorial = false
		tutorial_segment = TUTORIAL_TEXTS.win - 1
	screen_darkener.play("darken")
	music_fade.play("fade")
	fader.play()
	win_anim_timer.start()
	next_game_timer.start()
	sun.stop()
	time_left_timer.stop()
	#Global.difficulty += 0.2

func lose_game():
	if !won:
		if update_tutorial:
			update_tutorial = false
			tutorial_segment = TUTORIAL_TEXTS.timeout - 1
		screen_darkener.play("darken")
		music_fade.play("fade")
		fader.play()
		lose_anim_timer.start()
		next_game_timer.start()
		player.disable_block_inputs()
		placement_mesh.hide()
		time_left_timer.stop()
		#Global.difficulty = 1.0

func _on_respawner_body_entered(_body: Node3D) -> void:
	update_tutorial = false
	tutorial_segment = TUTORIAL_TEXTS.fall - 1
	lose_game()

func _on_win_anim_timer_timeout() -> void:
	player.disable_player()
	win_camera.play()
	placement_mesh.hide()
	crosshair.hide()
	blocks_left.hide()
	time_left.hide()
	blocks_left_img.hide()
	time_left_img.hide()
	progress_tutorial()
	repair.win()
	controls.hide()
	music_fade.stop(true)
	music.volume_db = 0.0
	music.stream = music_references[1]
	music.play()

func _on_time_left_timer_timeout() -> void:
	seconds_left -= 1
	if seconds_left < 0:
		lose_game()
		time_left_timer.stop()
	elif seconds_left <= 2:
		time_left_anim.play("boing_emergency")
	elif seconds_left <= 5:
		time_left_anim.play("boing_mid")
	else:
		time_left_anim.play("boing_tiny")
	time_left.text = str(clampi(seconds_left, 0, 99))

func _on_next_game_timer_timeout() -> void:
	# in umdware, this loads next game
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	game_container.emit_signal("end_game", won)


func _on_lose_anim_timer_timeout() -> void:
	player.disable_player()
	win_camera.lose()
	placement_mesh.hide()
	crosshair.hide()
	blocks_left.hide()
	time_left.hide()
	blocks_left_img.hide()
	time_left_img.hide()
	sun.instant_set()
	progress_tutorial()
	if tutorial_segment == TUTORIAL_TEXTS.fall:
		repair.fall()
	else:
		repair.lose()
	world_break_timer.start()
	controls.hide()
	music_fade.stop(true)
	music.volume_db = 0.0
	music.stream = music_references[2]
	music.play()

func _on_world_breaking_timer_timeout() -> void:
	if break_world_height > 2:
		for i in 36:
			for j in 36:
				break_tile(Vector3i(-18 + i, break_world_height, -18 + j), true)
		break_world_height = move_toward(break_world_height, 3, 1)
