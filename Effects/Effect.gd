extends AnimatedSprite2D

func _ready():
	self.animation_finished.connect(_on_animation_finished())
	self.play("Animate")

func _on_animation_finished():
	print("Test")
	queue_free()
