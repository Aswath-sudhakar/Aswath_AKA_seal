class_name Node2DEffectSequencer extends Node
## The purpose of [Node2DEffectSequencer] is to hold and call a series of [Node2DEffect]
## in sequence, to allow for the more complex tween animation.

## The node which was have a sequence of effects applied
@export var affected_node : Node2D

## Determines if the array of effects will loop once completed
@export var loop : bool = false

## Starts the array of effects upon all nodes becoming ready
@export var autostart : bool = false

## Array of held [Node2DEffect]
@export var effect_array : Array[Node2DEffect]

signal finished
var is_running : bool = false

func _ready() -> void:
	# Check if there is a node
	if !affected_node:
		return
	# Start sequence if autostart is enabled
	if autostart:
		do_effect_sequence()
	


## Calls the do_effect of every [Node2DEffect] in sequence
func do_effect_sequence() -> void:
	is_running = true
	# Check if there is a node to affect
	if !affected_node:
		printerr(self, "There was no node to apply effects to!")
		return
	
	for effect : Node2DEffect in effect_array:
		effect.affected_node = affected_node
		
		# Disable loop for all effects
		if effect.loop:
			loop = false
			#effect.loop = false
			print("Loop in effect found, breaking out of sequence.")
			#printerr(effect, "Set loop to false, does not apply when played in sequence.")
		
		# Disable autostart for all effects
		if effect.autostart:
			effect.autostart = false
			printerr(effect, "Set autostart to false, does not apply when played in sequence.")
		
		effect.do_tween()
		if effect.loop:
			break
		await effect.tween.finished
		
	
	# Loop if [member loop] is true
	if loop:
		effect_array.reverse()
		
		for effect : Node2DEffect in effect_array:
			effect.do_tween_backward(true)
			await effect.tween.finished
		
		effect_array.reverse()
		do_effect_sequence()
	finished.emit()
	is_running = false

## Stops the sequence by killing every tween in the array of [member effect_array]
func stop_sequence() -> void:
	for effect : Node2DEffect in effect_array:
		effect.stop_tween()
	finished.emit()
	is_running = false
