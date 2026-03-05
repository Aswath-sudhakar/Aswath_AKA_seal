class_name PlanetSwitcher extends Node

@onready var spawn_location: Marker2D = $SpawnLocation
@onready var spawn: Node2DEffect = $Spawn
@onready var die: Node2DEffect = $Die


const LEVEL_1 = preload("uid://1v6lhlff5lmf")
var monsta : Monsta
var levels : Array[PackedScene] = [LEVEL_1]


func _ready() -> void:
	monsta = get_tree().get_first_node_in_group("Monsta")

func switch_out_old_planets(old_path : EldritchParticlePathing):
	await kill_old_path(old_path)
	await spawn_in_new_path()
	

func kill_old_path(old_path : EldritchParticlePathing):
	if old_path == null: 
		return
	die.affected_node = old_path
	#print(old_path)
	die.do_tween()
	await die.tween.finished
	old_path.queue_free()
	if old_path.is_inside_tree():
		await old_path.tree_exited

func spawn_in_new_path():
	var new_path : EldritchParticlePathing = levels.pick_random().instantiate() as EldritchParticlePathing
	add_child(new_path)
	new_path.initialize()
	new_path.global_position = spawn_location.global_position
	spawn.affected_node = new_path
	spawn.end_position = monsta.global_position
	spawn.do_tween()
	await spawn.tween.finished
	print('finished')
	new_path.start()
	print('start')
