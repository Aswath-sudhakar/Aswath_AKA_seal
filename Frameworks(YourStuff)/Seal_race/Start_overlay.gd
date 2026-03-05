extends CanvasLayer

@onready var instructions: Control = $Instructions
@onready var countdown_label: Label = $CountdownLabel

var Transitioning = false
signal game_start
var meow : int = 0



func _input(event) -> void:
	if event.is_action_pressed("space") and not Transitioning and meow == 0:
		print("banana")     
		start_transition()
		meow += 1

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Instructions_slidein()
	
	
func start_transition():
	Transitioning = true
	
	var tween = create_tween()
	
	tween.tween_property(instructions,"position:y", 1000, 1  )\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN_OUT)
		
	
	tween.finished.connect(start_countdown)
	
	
func start_countdown():
	Transitioning = false
	instructions.visible = false 
	countdown_label.visible = true
	
	
		
	await animate_countdown("GO!")
		

	emit_signal("game_start")
	hide()
	
	

		
func animate_countdown(text):
	countdown_label.text = text
	
	
	var center_y = (get_viewport().size.y / 2 - countdown_label.size.y) / 2
	var start_y : int = 200
	var exit_y = get_viewport().size.y + 200
	
	countdown_label.position.y = start_y
	
	var tween = create_tween()
	
	tween.tween_property(countdown_label,"position:y", center_y + 40, .5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(countdown_label,"position:y", center_y, .5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(countdown_label, "scale", Vector2(1.3,1.3), 0.2)
	tween.tween_property(countdown_label,"scale",Vector2(1,1),.2)
	
	
	tween.tween_property(countdown_label,"position:y",exit_y, .5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	await tween.finished
	
func Instructions_slidein():
	await get_tree().process_frame
	
	var tween = create_tween()
	var center_y = (get_viewport().size.y - instructions.size.y) / 2 

	
	tween.tween_property(instructions, "position:y", center_y + 40, .5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(instructions, "position:y", center_y, .5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished
		



		
		

		
		
		
	
	
