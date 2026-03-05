class_name CoverUp extends Game
func _start_game():  pass

func coverup_image(image : Image):
	self.texture = ImageTexture.create_from_image(image)
