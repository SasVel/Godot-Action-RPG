extends CharacterBody2D

var rng = RandomNumberGenerator.new()
@onready var stats = $Stats
@onready var deathEffect = preload("res://Effects/enemy_death_effect.tscn")
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var animatedSprite = $AnimatedSprite

@export var SPEED = 300
@export var ACCELERATION = 100

var directionToPlayer = Vector2.ZERO
var state = IDLE
enum {
	IDLE,
	WANDER,
	CHASE
}

func _ready():
	var startFrame = rand_start_frame()
	animatedSprite.set_frame(startFrame)
	
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 300 * delta)
	
	match state:
		IDLE:
			if playerDetectionZone.player_detected():
				state = CHASE
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var directionToPlayer = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(directionToPlayer * SPEED, ACCELERATION * delta * 2)
				directionToPlayer = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(directionToPlayer * ACCELERATION, SPEED * delta * 2)
				animatedSprite.flip_h = directionToPlayer.x < 0
			else:
				state = IDLE
	
	move_and_slide()



func rand_start_frame():
	return rng.randi_range(0, 4)
	
func _on_hurtbox_area_entered(area):
	velocity = area.knockback_vector * 180
	stats.health -= area.damage

func death_effect():
	var effect = deathEffect.instantiate()
	get_parent().add_child(effect)
	effect.position = position

func _on_stats_no_health():
	death_effect()
	queue_free()
