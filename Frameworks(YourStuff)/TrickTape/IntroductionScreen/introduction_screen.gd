class_name IntroductionScreen extends Control

@onready var background: Sprite2D = $Background
@onready var drag: Sprite2D = $Drag


@onready var icon_drag_in: Node2DEffect = $Background/DragIn
@onready var icon_drag_out: Node2DEffect = $Background/DragOut
@onready var text_drag_in: Node2DEffect = $Drag/DragIn
@onready var text_drag_out: Node2DEffect = $Drag/DragOut
@onready var text_rotate: Node2DEffect = $Drag/Rotate

func _ready() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	show_introduction()

func show_introduction() -> void:
	background.visible = true
	drag.visible = true
	icon_drag_in.do_tween()
	text_drag_in.do_tween()
	await icon_drag_in.tween.finished
	await get_tree().create_timer(3.0).timeout
	icon_drag_out.do_tween()
	text_drag_out.do_tween()
	await icon_drag_out.tween.finished
	background.visible = false
	drag.visible = false
	
