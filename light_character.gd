extends CharacterBody2D


const speed = 400.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	if position.x >= 460:
		position.x = 460
	elif position.x <= -450:
		position.x = -450
	if position.y >= 200:
		position.y = 200
	elif position.y <= -175:
		position.y = -175
		
	print(position)
	
	move_and_slide()
	
	
