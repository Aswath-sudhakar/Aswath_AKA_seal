class_name EldritchParticlePathing extends Path2D

const PathFollow2d = preload('uid://d3xire3t1b2b5')
const GOOD_PLANET = preload("uid://jaq2sk636hlb")
const BAD_PLANET = preload("uid://dhjes0nrq5d64")

var adaptive_music: EldritchAdaptiveMusic

var eldritch_game : EldritchGame
var path_movement_percent : float
var planets : Array[Planet]
var paths_array : Array[EldritchParticleFollow] = []
var should_be_moving : bool = true

@export var planets_to_spawn : Array[bool]

#func _ready() -> void:
	#add_to_group("ParticlePathing")
	#adaptive_music = get_tree().get_first_node_in_group("EldritchAdaptiveMusic")
	#eldritch_game = get_parent() as EldritchGame
	#adaptive_music.start()
	#connect_adaptive_music_signals()
	#adaptive_music.half_bar.connect(do_planet_beat_effect)
	#initialize_planets()

func initialize():
	add_to_group("ParticlePathing")
	adaptive_music = get_tree().get_first_node_in_group("EldritchAdaptiveMusic")
	eldritch_game = get_tree().get_first_node_in_group("Eldritchgame")
	#adaptive_music.start()
	#connect_adaptive_music_signals()
	
	initialize_planets()

func start():
	adaptive_music.half_bar.connect(do_planet_beat_effect)
	connect_adaptive_music_signals()

func do_planet_beat_effect() -> void:
	for planet : Planet in planets:
		if !is_instance_valid(planet):
			continue
		planet.do_beat_effect()


func initialize_planets() -> void:
	print('iniializing')
	var good_planet : GoodPlanet
	@warning_ignore("unused_variable")
	var bad_planet : BadPlanet
	for toggle in planets_to_spawn:
		if toggle:
			good_planet = GOOD_PLANET.instantiate() as GoodPlanet
			eldritch_game.planets_to_eat += 1
			parent_planet_to_line_follow(good_planet)
		else:
			bad_planet = BAD_PLANET.instantiate() as BadPlanet
			parent_planet_to_line_follow(bad_planet)
			print('instancing bad planet')
	path_movement_percent = 1.0 / planets.size()
	space_out_planets()

func connect_adaptive_music_signals() -> void:
	adaptive_music.fuck.connect(progress_paths)

func parent_planet_to_line_follow(planet : Planet) -> void:
	var path : EldritchParticleFollow = EldritchParticleFollow.new()
	path.set_script(PathFollow2d)
	add_child(path)
	path.add_child(planet)
	paths_array.append(path)
	planets.append(planet)

func space_out_planets() -> void:
	var progress_amount : float = 0
	for path in paths_array:
		progress_amount += ( 1 / float(planets.size()) )
		path.progress_ratio = progress_amount

func progress_paths() -> void:
	if !should_be_moving:
		return
	for path : EldritchParticleFollow in paths_array:
		if path.is_being_eaten:
			continue
		get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).tween_property(path, "progress_ratio", path.progress_ratio + path_movement_percent, 0.3)
