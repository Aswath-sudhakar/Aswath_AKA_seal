extends CharacterBody2D

const tile_size: Vector2 = Vector2(22,22)

@onready var up_right: RayCast2D = $Up_Right
@onready var down_right: RayCast2D = $Down_Right
@onready var up_left: RayCast2D = $Up_Left
@onready var down_left: RayCast2D = $Down_left


@export var tile_map_layer: TileMapLayer

var direction_x : float = 0.0
var direction_y : float = 0.0
var direction : Vector2

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		get_parent().spacebar_hit()
	if not get_parent().game_started:
		return
		
	direction_x = Input.get_axis('left',"right")
	direction_y = Input.get_axis('forward',"back")
	if !(direction_x or direction_y):
		return
	
	direction = Vector2(direction_x, direction_y)
	if Input.is_action_just_pressed("back") or Input.is_action_just_pressed("forward") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
		if direction == Vector2(1,-1) and !up_right.is_colliding():
			global_position += Vector2(32, 16) * direction
		elif direction == Vector2(-1,-1) and !up_left.is_colliding():
			global_position += Vector2(32, 16) * direction
		elif direction == Vector2(-1,1) and !down_left.is_colliding():
			global_position += Vector2(32, 16) * direction
		elif direction == Vector2(1,1) and !down_right.is_colliding():
			global_position += Vector2(32, 16) * direction
	
			
			
