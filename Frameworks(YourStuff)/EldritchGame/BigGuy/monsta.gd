class_name Monsta extends Node2D

signal bad_planet_eaten
signal good_planet_eaten(hit_was_good : bool)

@onready var eating_zone: EatingZone = $EatingZone
@onready var marker_2d: Marker2D = $Marker2D
@onready var clap: AudioStreamPlayer = $Clap
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var adaptive_music : EldritchAdaptiveMusic

func _ready() -> void:

	adaptive_music = get_tree().get_first_node_in_group("EldritchAdaptiveMusic")
	eating_zone.planet_suck.connect(suck_in_planet)

func suck_in_planet(planet : Planet):
	var hit_was_good : bool
	await adaptive_music.beat
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("gulp")
	
	if adaptive_music.bar_index % 4 == 0:
		print("Good hit!")
		hit_was_good = true
	elif adaptive_music.bar_index % 4 == 2:
		print("Dragging!")
		hit_was_good = false
	else:
		print("Rushing!")
		hit_was_good = false

	if planet is GoodPlanet:
		good_planet_eaten.emit(hit_was_good)
	else:
		bad_planet_eaten.emit()

	
	clap.play()
	move_planet_to_marker(planet)

func move_planet_to_marker(planet : Planet) -> void:
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(planet, 'global_position', marker_2d.global_position, 0.2)
	await tween.finished
	planet.die()
