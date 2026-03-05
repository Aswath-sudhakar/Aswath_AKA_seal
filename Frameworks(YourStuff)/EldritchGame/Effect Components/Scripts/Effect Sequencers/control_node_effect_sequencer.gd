class_name ControlNodeEffectSequencer extends Node
## The purpose of [ControlNodeEffectSequencer] is to hold and call a series of [ControlNodeEffect]
## in sequence, to allow for the more complex tween animation.

## The node which was have a sequence of effects applied
@export var affected_node : Control

## Determines if the array of effects will loop once completed
@export var loop : bool = false

## Starts the array of effects upon all nodes becoming ready
@export var autostart : bool = false

## Array of held [ControlNodeEffect]
@export var effect_array : Array[ControlNodeEffect]
var is_running : bool = false

func _ready() -> void:
	# Check if there is a node
	if !affected_node:
		return
	# Start sequence if autostart is enabled
	if autostart:
		do_effect_sequence()
	


## Calls the do_effect of every [ControlNodeEffect] in sequence
func do_effect_sequence() -> void:
	is_running = true
	# Check if there is a node to affect
	if !affected_node:
		printerr(self, "There was no node to apply effects to!")
		return
	
	for effect : ControlNodeEffect in effect_array:
		effect.affected_node = affected_node
		
		# Disable loop for all effects
		if effect.loop:
			effect.loop = false
			printerr(effect, "Set loop to false, does not apply when played in sequence.")
		
		# Disable autostart for all effects
		if effect.autostart:
			effect.autostart = false
			printerr(effect, "Set autostart to false, does not apply when played in sequence.")
		
		effect.do_tween()
		await effect.tween.finished
	
	# Loop if [member loop] is true
	if loop:
		effect_array.reverse()
		
		for effect : ControlNodeEffect in effect_array:
			effect.do_tween_backward()
			await effect.tween.finished
		
		effect_array.reverse()
		do_effect_sequence()
	is_running = false


## Stops the sequence by killing every tween in the array of [member effect_array]
func stop_sequence() -> void:
	for effect : ControlNodeEffect in effect_array:
		effect.stop_tween()
	is_running = false
