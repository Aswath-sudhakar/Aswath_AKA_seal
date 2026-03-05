extends Game

@onready var game = $"SubViewportContainer/SubViewport/Game"

func _start_game():
	game.start_game(get_intensity())
	game.game_container = self
