class_name EldritchParticlePathing extends Path2D

const PathFollow2d = preload('uid://d3xire3t1b2b5')

@onready var adaptive_music: EldritchAdaptiveMusic = $EldritchAdaptiveMusic

signal planet_got_eaten
signal bad_planet_eaten

var path_movement_percent : float

var paths_array : Array[EldritchParticleFollow] = []

@export var speed : float = 0.1
var planets : Array[Planet]

func _ready() -> void:
	adaptive_music.start()
	connect_adaptive_music_signals()
	for planet in get_children():
		if planet is not Planet:
			continue
		planets.append(planet as Planet)
		if planet is GoodPlanet:
			(get_parent() as EldritchGame).increase_planet_count()
			(planet as Planet).planet_eaten.connect(call_planet_decrease)
		elif planet is Planet:
			(planet as Planet).planet_eaten.connect(_on_bad_planet_eaten)
		parent_planet_to_line_follow(planet as Planet)
	space_out_planets()
	path_movement_percent = 1.0 / (get_parent() as EldritchGame).planet_count

func connect_adaptive_music_signals():
	adaptive_music.current_bar.connect(progress_paths)

func parent_planet_to_line_follow(planet : Planet) -> void:
	var path : EldritchParticleFollow = EldritchParticleFollow.new()
	path.set_script(PathFollow2d)
	#path.speed = speed
	add_child(path)
	planet.position = Vector2.ZERO
	planet.reparent(path, false)
	
	paths_array.append(path)

func space_out_planets() -> void:
	var progress_amount : float = 0
	for child in paths_array:
		if child is not EldritchParticleFollow:
			return
		progress_amount += ( 1 / float(planets.size()) )
		(child as EldritchParticleFollow).progress_ratio = progress_amount

func _on_bad_planet_eaten() -> void:
	bad_planet_eaten.emit()

func call_planet_decrease() -> void:
	planet_got_eaten.emit()

func progress_paths() -> void:
	for path : EldritchParticleFollow in paths_array:
		get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).tween_property(path, "progress_ratio", path.progress_ratio + path_movement_percent, 0.25)
