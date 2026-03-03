extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("input_event", Callable(self, "_on_input_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.---------------------
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("Clicked node name:", name) 
