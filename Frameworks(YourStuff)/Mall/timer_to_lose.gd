extends Timer

@onready var timer_label: Label = $TimerLabel

func _process(delta: float) -> void:
	timer_label.text = str(time_left)
