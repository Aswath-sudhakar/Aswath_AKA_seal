class_name EldritchGame extends Node2D

## amount gained from perfect chomp
const GOOD_EAT_AMOUNT : float = 15
## amount gained from imperfect chomp
const BAD_EAT_AMOUNT : float = 5

@onready var monsta: Monsta = $Monsta
@onready var hunger_bar: TextureProgressBar = $HungerBar

@warning_ignore("unused_signal") signal switch_to_new_scene
@warning_ignore("unused_signal") signal reload_scene

func _ready() -> void:
	_start_game()

func _start_game():
	monsta.bad_planet_eaten.connect(_on_bad_planet_eaten)
	monsta.good_planet_eaten.connect(_on_good_planet_eaten)

func win_game():
	pass

func lose_game():
	pass

func _on_good_planet_eaten(hit_was_good : bool):
	var value_to_add : float
	if hit_was_good:
		value_to_add = GOOD_EAT_AMOUNT
	else:
		value_to_add = BAD_EAT_AMOUNT
	
	tween_hunger_bar_to_value(hunger_bar.value + value_to_add)
	
	if hunger_bar.value + value_to_add >= hunger_bar.max_value:
		win_game()
		return

func _on_bad_planet_eaten():
	tween_hunger_bar_to_value(hunger_bar.value - (GOOD_EAT_AMOUNT * 1.2) )

func tween_hunger_bar_to_value(value : float):
	get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).tween_property(hunger_bar, "value", value, 0.3)
