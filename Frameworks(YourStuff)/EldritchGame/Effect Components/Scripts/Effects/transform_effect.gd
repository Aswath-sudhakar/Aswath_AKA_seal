@abstract class_name TransformEffect extends TweenEffect


#region Transform Properties
@export_category("Transform Properties")

@export_group("Position")
## The position the tween will start at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var start_position : Vector2 = Vector2.INF

## The position the tween will end at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var end_position : Vector2 = Vector2.INF

## Original position of the node 
var original_position : Vector2

## The current position of the node, stored in a variable
var current_position : Vector2

@export_group("Rotation")

## The rotation amount is the rotation degrees the tween will start at. [br]
## Has INF value by default, and will ignore this parameter if unchanged.
@export var start_rotation : float = INF

## The rotation amount is the rotation degrees the tween will end at. [br]
## Has INF value by default, and will ignore this parameter if unchanged.
@export var end_rotation : float = INF

## Original rotation of the node in degrees
var original_rotation : float

## The current rotate of the node in rotation_degrees, stored in a variable
var current_rotation : float

@export_group("Scale")

## The scale amount is the scale the tween will start at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var start_scale : Vector2 = Vector2.INF

## The scale amount is the scale the tween will end at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var end_scale : Vector2 = Vector2.INF

## Original scale of the node in degrees
var original_scale : Vector2

## The current rotate of the node in rotation_degrees, stored in a variable
var current_scale : Vector2

#endregion

#region CanvasItem Properties
@export_category("CanvasItem Properties")
@export_group("Visibility")

## The modulate the node will start at, if WHITE then will set to default. [br]
## If both modulate are the same, the tween will ignore modulation
@export var start_modulate : Color = Color.WHITE

## The modulate the node will end at, if WHITE then will set to default. [br]
## If both modulate are the same, the tween will ignore modulation
@export var end_modulate : Color = Color.WHITE


#endregion

@export_category("Reset Parameters")
## Resets all values to what they were when the tween started, is not compatible with loop.
@export var reset_on_completion : bool = false

## Execute transform tweens for the [param affected_node].
func do_transform_tween(_affected_node : Node) -> void:
	# Return if there is no node
	if !_affected_node:
		printerr(self, "No node assigned to Node2D Effect")
		return
	
	
	# Create a new tween with given parameters
	reset_tween()
	
	
	# Set the current values from _affected_node
	set_current_values()
	
	# Set to infinitely loop 
	if loop:
		tween.set_loops()
	
	# Tween the positions if not default
	if start_position.x != end_position.x:
		tween.tween_property(
			_affected_node,
			"position:x",
			end_position.x if end_position.x != INF else current_position.x,
			tween_duration
			).from(
				start_position.x if start_position.x != INF else current_position.x
				)
	if start_position.y != end_position.y:
		tween.tween_property(
			_affected_node,
			"position:y",
			end_position.y if end_position.y != INF else current_position.y,
			tween_duration
			).from(
				start_position.y if start_position.y != INF else current_position.y
				)
	
	# Tween the rotation if not default
	if start_rotation != end_rotation:
		tween.tween_property(
			_affected_node,
			"rotation_degrees",
			end_rotation if end_rotation != INF else current_rotation,
			tween_duration
			).from(
				start_rotation if start_rotation != INF else current_rotation
				)
	
	# Tween the scale if not default
	if start_scale.x != end_scale.x:
		tween.tween_property(
			_affected_node,
			"scale:x",
			end_scale.x if end_scale.x != INF else current_scale.x,
			tween_duration
			).from(
				start_scale.x if start_scale.x != INF else current_scale.x
				)
	if start_scale.y != end_scale.y:
		tween.tween_property(
			_affected_node,
			"scale:y",
			end_scale.y if end_scale.y != INF else current_scale.y,
			tween_duration
			).from(
				start_scale.y if start_scale.y != INF else current_scale.y
				)
	
	# Tween modulate if start_modulate and end_modulate are not the same
	if start_modulate != end_modulate:
		tween.tween_property(
			_affected_node,
			"modulate",
			end_modulate,
			tween_duration
		).from(
			start_modulate
		)
	
	if loop:
		tween.chain()
		
		do_transform_tween_backward(_affected_node)
	
	await tween.finished
	if reset_on_completion and !loop:
		reset_to_origin(_affected_node)

## Execute the do_tween function with start and end values reversed, meant to be used
## for looping. [br]
## Use [param reset] if used alone.
func do_transform_tween_backward(_affected_node : Node, reset : bool = false) -> void:
	# Reset if run only if the do_backwards is run alone
	if reset:
		setup_tween()
	
	# Set the current values from _affected_node
	set_current_values()
	
	# Tween the positions if not default
	if start_position.x != end_position.x:
		tween.tween_property(
			_affected_node,
			"position:x",
			start_position.x if start_position.x != INF else current_position.x,
			tween_duration
			).from(
				end_position.x if end_position.x != INF else current_position.x
				)
	if start_position.y != end_position.y:
		tween.tween_property(
			_affected_node,
			"position:y",
			start_position.y if start_position.y != INF else current_position.y,
			tween_duration
			).from(
				end_position.y if end_position.y != INF else current_position.y
				)
	
	# Tween the rotation if not default
	if start_rotation != end_rotation:
		tween.tween_property(
			_affected_node,
			"rotation_degrees",
			start_rotation if start_rotation != INF else current_rotation,
			tween_duration
			).from(
				end_rotation if end_rotation != INF else current_rotation
				)
	
	# Tween the scale if not default
	if start_scale.x != end_scale.x:
		tween.tween_property(
			_affected_node,
			"scale:x",
			start_scale.x if start_scale.x != INF else current_scale.x,
			tween_duration
			).from(
				end_scale.x if end_scale.x != INF else current_scale.x
				)
	if start_scale.x != end_scale.y:
		tween.tween_property(
			_affected_node,
			"scale:y",
			start_scale.y if start_scale.y != INF else current_scale.y,
			tween_duration
			).from(
				end_scale.y if end_scale.y != INF else current_scale.y
				)
	
	# Tween modulate if start_modulate and end_modulate are not the smae
	if start_modulate != end_modulate:
		tween.tween_property(
			_affected_node,
			"modulate",
			start_modulate,
			tween_duration
		).from(
			end_modulate
		)
	await tween.finished
	if reset_on_completion and !loop:
		reset_to_origin(_affected_node)


func reset_to_origin(_affected_node : Node) -> void:
	reset_tween()
	tween.tween_property(
			_affected_node,
			"position",
			original_position,
			tween_duration
			)
	tween.tween_property(
			_affected_node,
			"rotation_degrees",
			original_rotation,
			tween_duration
			)
	tween.tween_property(
			_affected_node,
			"scale",
			original_scale,
			tween_duration
			)


@abstract func set_original_values() -> void


@abstract func set_current_values() -> void
