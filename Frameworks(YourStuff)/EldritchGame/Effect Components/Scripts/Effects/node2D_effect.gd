@icon("uid://mc5sx2ggbl4q")
class_name Node2DEffect extends TransformEffect
## [Node2DEffect] is an extension of [TweenEffect] and additionally contains
## transform and [CanvasItem] parameters.

## The node which will have the effect applied.
@export var affected_node : Node2D


func _ready() -> void:
	# Check if there is a node
	if !affected_node:
		return
	# Start effect if autostart is enabled
	if autostart:
		do_tween()
	
	set_original_values()


func do_tween() -> void:
	do_transform_tween(affected_node)


func do_tween_backward(reset : bool = false) -> void:
	do_transform_tween_backward(affected_node, reset)


## Sets the original transform values to the [member affected_node]
func set_original_values() -> void:
	original_position = affected_node.position
	original_rotation = affected_node.rotation
	original_scale = affected_node.scale


## Sets the current transform values to the [member affected_node]
func set_current_values() -> void:
	current_position = affected_node.position
	current_rotation = affected_node.rotation
	current_scale = affected_node.scale
