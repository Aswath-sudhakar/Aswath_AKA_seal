extends RigidBody2D


var glumph_speed : int = 5
var timer : int = 1
var dash_count : int = 0
var was_on_ground := false
@onready var ground: StaticBody2D = $"../Ground"
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ribbon_seal: RigidBody2D = $"."
@onready var ocean: Area2D = $"../Ocean"
@onready var seal_sprite: Sprite2D = $Seal_Sprite
@onready var game = get_parent()
@onready var glumph_sfx: AudioStreamPlayer2D = $"../Glumph"

signal won	

var has_won := false

func _ready():
	ocean.body_entered.connect(_on_area_entered)

func _process(delta):
	
	var on_ground = ray_cast_2d.is_colliding()
	
	if not was_on_ground and on_ground:
		dash_count = 0
		land_stretch(delta)

	
	was_on_ground = on_ground
	
	glumph()

	
	seal_sprite.scale.x = move_toward(seal_sprite.scale.x, 1, .4 * delta)
	seal_sprite.scale.y = move_toward(seal_sprite.scale.y, 1, .4 * delta)
	
	if not ray_cast_2d.is_colliding() and Input.is_action_just_pressed("Dash"):
		if dash_count == 0:
			apply_central_impulse(Vector2(50,0))
			dash_count += 1
		 
	


func land_stretch(delta):
	var tween = create_tween()
	tween.tween_property(seal_sprite, "scale", Vector2(1.4, .8), .1)
	
	
func glumph():
	
	if Input.is_action_just_pressed("space") and ray_cast_2d.is_colliding():
		apply_central_impulse(Vector2(200,-300))
		var tween = create_tween()
		tween.tween_property(seal_sprite, "scale", Vector2(.8, 1.4), .1)
		print("atish is dumb meow")
		glumph_sfx.play()
	pass

func _on_area_entered(body):
	print ("slap bellay")
	if body == self and not has_won:
		has_won = true
		emit_signal("won")
		game.emit_signal("end_game",has_won)

	
