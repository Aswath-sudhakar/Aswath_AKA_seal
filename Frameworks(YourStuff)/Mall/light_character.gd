extends CharacterBody2D


const speed = 10000.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if !visible: return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
	if direction:
		velocity = direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	if position.x >= 1152:
		position.x = 1152
	elif position.x <= -0:
		position.x = -0
	if position.y >= 648:
		position.y = 648
	elif position.y <= 0:
		position.y = 0
	
	move_and_slide()
	
	
