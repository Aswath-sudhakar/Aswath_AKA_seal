@abstract class_name TweenEffect extends Node
## The TweenEffect class is an abstract class meant to be used to build out other
## effect classes using tweens. [br]
## This class contains all of the information relating to the tween including
## transitions, easing, and the tween's duration.


@export_category("Universal Parameters")
## Determines if the effect will loop while playing.
@export var loop : bool = false

## Starts the effect upon the node becoming ready
@export var autostart : bool = false

@export_category("Transition Parameters")
## Type of [TransitionType] of the tween.
@export var trans_type : Tween.TransitionType
## Type of [EaseType] of the tween.
@export var ease_type : Tween.EaseType
## Duration of the tween as a [float].
@export var tween_duration : float = 1.0

## The variable holding the tween.
var tween : Tween


## This function resets and creates a new tween with all given parameters:
## [member trans_type], [member ease_type].
func reset_tween() -> void:
	# If there is a current tween, abort it
	if tween:
		tween.kill()
	# Setup the new tween
	setup_tween()

## Creates the tween with the [member ease_type], [member trans_type] and
## allow for tweening to be done simultaneously
func setup_tween() -> void:
	tween = create_tween().set_ease(ease_type).set_trans(trans_type).set_parallel(true)


## Kill the [member tween] if a [member tween] exists
func stop_tween() -> void:
	if tween:
		tween.kill()


@abstract func do_tween() -> void
## This function calls the specific application of the tween, which must be defined
## in any subclass of [TweenEffect].
