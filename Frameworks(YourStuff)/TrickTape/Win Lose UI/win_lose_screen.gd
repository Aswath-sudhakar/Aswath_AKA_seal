class_name WinLoseScreen extends Control

#region win stuff
@onready var win_sprite: Sprite2D = $Win/WinSprite
@onready var win_sprite_effect: Node2DEffect = $Win/WinSprite/StampEffect
@onready var win_background: Sprite2D = $Win/WinBackground
@onready var win_background_effect: Node2DEffect = $Win/WinBackground/StampEffect
@onready var whimsy: Sprite2D = $Win/Whimsy
@onready var stamp_effect: Node2DEffect = $Win/Whimsy/StampEffect
#endregion

#region lose stuff
@onready var lose_sprite: Sprite2D = $Lose/LoseSprite
@onready var grow_lose: Node2DEffect = $Lose/LoseSprite/Grow

@onready var lose_background: Sprite2D = $Lose/LoseBackground
@onready var grow_background: Node2DEffect = $Lose/LoseBackground/Grow

@onready var slash_1: Sprite2D = $Lose/Slash1
@onready var slash_1_grow: Node2DEffect = $Lose/Slash1/Grow

@onready var slash_2: Sprite2D = $Lose/Slash2
@onready var slash_2_grow: Node2DEffect = $Lose/Slash2/Grow

@onready var slash_3: Sprite2D = $Lose/Slash3
@onready var slash_3_grow: Node2DEffect = $Lose/Slash3/Grow



#func _ready() -> void:
	#lost()

#endregion

signal lost_anim_finished
signal win_anim_finished

func won() -> void:
	await get_tree().create_timer(1).timeout
	win_background.show()
	win_background_effect.do_tween()
	await get_tree().create_timer(0.3).timeout
	whimsy.show()
	stamp_effect.do_tween()
	await stamp_effect.tween.finished
	win_sprite.show()
	win_sprite_effect.do_tween()
	await win_sprite_effect.tween.finished
	
	await get_tree().create_timer(1.0).timeout
	win_anim_finished.emit()


func lost() -> void:
	await get_tree().create_timer(1).timeout
	
	slash_1.show()
	slash_1_grow.do_tween()
	await slash_1_grow.tween.finished
	slash_2.show()
	slash_2_grow.do_tween()
	await slash_2_grow.tween.finished
	slash_3.show()
	slash_3_grow.do_tween()
	await slash_3_grow.tween.finished
	
	await get_tree().create_timer(0.5).timeout
	
	lose_background.show()
	grow_background.do_tween()
	await grow_background.tween.finished
	lose_sprite.show()
	grow_lose.do_tween()
	
	await grow_lose.tween.finished
	await get_tree().create_timer(1.0).timeout
	lost_anim_finished.emit()
