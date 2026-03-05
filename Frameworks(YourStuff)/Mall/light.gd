extends Sprite2D

@onready var light_character: CharacterBody2D = $"../../LightCharacter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vec_to_playa = light_character.global_position - global_position
	rotation = global_position.angle_to_point(light_character.global_position) - .8#atan2(vec_to_playa.y,vec_to_playa.x) + -1.3
