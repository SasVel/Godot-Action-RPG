extends CharacterBody2D

@export var ACCELERATION = 60;
@export var FRICTION = 40;
@export var SPEED = 500;
@export var MAX_SPEED = 1500;
var CURR_SPEED = SPEED;

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var lastDirection = Vector2(1, 0)
@onready var swordHitbox = $RotationPivot/SwordHitbox

func move_state(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#Setting blend positions
	animationTree.set("parameters/Idle/blend_position", lastDirection)
	animationTree.set("parameters/Run/blend_position", input_direction)
	animationTree.set("parameters/Attack/blend_position", lastDirection)
	animationTree.set("parameters/Roll/blend_position", lastDirection)
	
	var input_vector = input_direction * (CURR_SPEED * delta) * 10
	
	if input_direction != Vector2.ZERO:
		if CURR_SPEED < MAX_SPEED:
			CURR_SPEED += ACCELERATION
		
		velocity = input_vector
		
		lastDirection = input_direction
		animationState.travel("Run")
	else:
		if CURR_SPEED > MAX_SPEED:
			CURR_SPEED -= FRICTION
		else:
			CURR_SPEED = SPEED
		velocity = velocity.move_toward(Vector2.ZERO, (FRICTION * delta) * 20)
		
		animationState.travel("Idle")
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
			

func attack_state(delta):
	animationState.travel("Attack")
	velocity = Vector2.ZERO
	
func roll_state(delta):
	animationState.travel("Roll")
	velocity = lastDirection * (CURR_SPEED * delta) * 15
	
func attack_finished():
	state = MOVE

func roll_finished():
	state = MOVE

func _physics_process(delta):
	swordHitbox.knockback_vector = lastDirection
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	move_and_slide()
	
