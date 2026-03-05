extends Game

@onready var ribbon_seal: RigidBody2D = $Ribbon_Seal
@onready var wind_sfx: AudioStreamPlayer2D = $Wind_SFX

@onready var start_overlay: CanvasLayer = $StartOverlay
@onready var main: Node2D = $"."
@onready var evil_seal: RigidBody2D = $Evil_seal

func _start_game():
	get_tree().paused = true
	ribbon_seal.won.connect(_on_player_won)
	
	start_overlay.game_start.connect(Game_started)
	evil_seal.lose.connect(_on_player_lost)
	
	
func Game_started():
	get_tree().paused = false
	wind_sfx.play()
	

func _on_player_won():
	var tween = create_tween()
	start_overlay.show()
	start_overlay.animate_countdown("you won!")
	tween.tween_property(wind_sfx,"volume_db",-40,1.5)
	
	
func _on_player_lost():
	start_overlay.show()
	start_overlay.animate_countdown("you lost!")
	
