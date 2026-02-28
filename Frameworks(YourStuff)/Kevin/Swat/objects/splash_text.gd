extends Sprite2D

@onready var anim = $"MainAnim"

var shake_amount = 1

var textures = {
	"swat": load("res://Frameworks(YourStuff)/Kevin/Swat/assets/ui/text/swat.png"),
	"infestation": load("res://Frameworks(YourStuff)/Kevin/Swat/assets/ui/text/infestation.png"),
	"clear": load("res://Frameworks(YourStuff)/Kevin/Swat/assets/ui/text/clear.png")
}

func start():
	anim.play("swat")

func infestation():
	texture = textures["infestation"]
	shake_amount = 3
	anim.play("infestation")

func clear():
	texture = textures["clear"]
	shake_amount = 2
	anim.play("clear")


func _physics_process(_delta: float) -> void:
	offset = Vector2(randi_range(-shake_amount, shake_amount), randi_range(-shake_amount, shake_amount))
