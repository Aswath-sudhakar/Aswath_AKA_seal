extends Button

@onready var adaptive_music: Node = $"../AdaptiveMusic"

@export var hover_scale := 1.2
@export var scale_speed := 0.15
@export var wiggle_amount := 5.0
@export var wiggle_speed := 8.0
@onready var circle_player: AnimationPlayer = $"CirclePlayer"
@onready var main_mall_game: Node2D = $"../.."
@onready var animsprite : AnimatedSprite2D = $AnimatedSprite2D
var _is_hovered := false
var _base_scale := Vector2.ONE
var _base_rotation := 0.0
var _time := 0.0
@export var index := 0
@export var name_click : String
const HIRED_ = preload("res://Frameworks(YourStuff)/Mall/hired!.tscn")



func show_circ():
	circle_player.play("showcirc")

# Called when the node enters the scene tree for the first time.
func _ready():
	_base_scale = scale
	_base_rotation = rotation_degrees 
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

var clicked = false
func _process(delta):
	if _is_hovered and !clicked:
		_time += delta * wiggle_speed
		rotation_degrees = _base_rotation + sin(_time) * wiggle_amount
		if Input.is_action_just_pressed("space"):
			var hire : RigidBody2D = HIRED_.instantiate()
			
			add_child(hire)
			hire.global_position = circle_player.get_child(0).global_position
			hire.apply_central_impulse(Vector2(0,-300))
			hire.show()
			adaptive_music.increase_volume(index, -10.0, .1,1)
			clicked = true
			main_mall_game.add_player(self)
			animsprite.play("default")
	else :
		rotation_degrees = lerp(rotation_degrees, _base_rotation, delta * 10)
		

func _on_mouse_entered():
	return
	_is_hovered = true
	var tween = create_tween()
	tween.tween_property(self, "scale", _base_scale * hover_scale, scale_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	return
	_is_hovered = false
	var tween = create_tween()
	tween.tween_property(self, "scale", _base_scale, scale_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

#scale moves smoothly using tween
#sin wave used for wiggle
#when mouse leaves: scale returns to normal & rotation smoothly resets


func _on_area_2d_body_entered(body: Node2D) -> void:
	_is_hovered = true
	var tween = create_tween()
	tween.tween_property(self, "scale", _base_scale * hover_scale, scale_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func _on_area_2d_body_exited(body: Node2D) -> void:
	_is_hovered = false
	var tween = create_tween()
	tween.tween_property(self, "scale", _base_scale, scale_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
