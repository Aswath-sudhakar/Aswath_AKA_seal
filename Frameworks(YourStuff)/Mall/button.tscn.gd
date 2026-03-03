extends Button

@export var hover_scale := 1.2
@export var scale_speed := 0.15
@export var wiggle_amount := 5.0
@export var wiggle_speed := 8.0
@onready var circle_player: AnimationPlayer = $"CirclePlayer"
@onready var main_mall_game: Node2D = $"../.."

var _is_hovered := false
var _base_scale := Vector2.ONE
var _base_rotation := 0.0
var _time := 0.0

func show_circ():
	circle_player.play("showcirc")

# Called when the node enters the scene tree for the first time.
func _ready():
	_base_scale = scale
	_base_rotation = rotation_degrees 
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta):
	if _is_hovered:
		_time += delta * wiggle_speed
		rotation_degrees = _base_rotation + sin(_time) * wiggle_amount
		if Input.is_action_just_pressed("space"):
			main_mall_game.add_player(self)
			print(self)
			
	else:
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
