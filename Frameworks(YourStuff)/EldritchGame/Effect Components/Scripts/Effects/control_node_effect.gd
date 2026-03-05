@icon("uid://mms7tsllqfcb")
class_name ControlNodeEffect extends TransformEffect
## [ControlNodeEffect] is an extension of [TweenEffect] and additionally contains
## transform and [CanvasItem] parameters.

## The node which will have the effect applied.
@export var affected_node : Control


func _ready() -> void:
	if !affected_node:
		return
	
	if autostart:
		do_tween()
	# Sets the pivot offset to be the center of the control node
	affected_node.pivot_offset_ratio = Vector2(0.5, 0.5)


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
