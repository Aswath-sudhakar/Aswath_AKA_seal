extends Game

@onready var Description: RichTextLabel = $Description
@onready var button: Button = $Button
@onready var timer_words: RichTextLabel = $TimeLeft

var timer = 1.0
var won = false

signal time_done

func _process(delta: float) -> void:
	if timer_words:
		if timer_words.visible: 
			if timer > 0:
				timer = max(timer - delta, 0)
			else:
				timer = 0
				time_done.emit()
		timer_words.text = str(snapped(timer, .01))

func _on_button_pressed() -> void:
	button.modulate = Color.GREEN
	won = true


func _start_game() -> void:
	Description.show()
	await get_tree().create_timer(1.0).timeout #wait for instructions
	timer_words.show()
	button.show()
	timer = 2/get_intensity()
	await time_done
	if won:
		$ppl.play("win")
		$ppl.scale = $ppl.scale * .9
	else:
		$explosion.play("default")
	await get_tree().create_timer(.2).timeout
	end_game.emit(won) #defaults to false if button is not pressed
