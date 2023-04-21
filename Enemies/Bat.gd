extends CharacterBody2D

var rng = RandomNumberGenerator.new()
@onready var stats = $Stats


func _ready():
	var startFrame = rand_start_frame()
	var animatedSprite = $AnimatedSprite
	animatedSprite.set_frame(startFrame)
	
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 300 * delta)
	move_and_slide()

func rand_start_frame():
	return rng.randi_range(0, 4)
	
func _on_hurtbox_area_entered(area):
	velocity = area.knockback_vector * 150
	stats.health -= area.damage

func _on_stats_no_health():
	queue_free()
