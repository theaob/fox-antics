extends CharacterBody2D

class_name Player

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

const GRAVITY: float = 1000.0
const RUN_SPEED: float = -120.0
const MAX_FALL_SPEED: float = 400.0
const HURT_TIME: float = 0.3
const JUMP_VELOCITY: float = -400.0

enum PLAYER_STATE {
	IDLE, RUN, JUMP, FALL, HURT
}

var _state: PLAYER_STATE = PLAYER_STATE.IDLE

func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
		
	get_input()	
	
	calculate_states()
	
	move_and_slide()
	
func get_input() -> void:
	
	velocity.x = 0
	
	if Input.is_action_pressed("left") == true:
		velocity.x = -RUN_SPEED

	if Input.is_action_pressed("right") == true:
		velocity.x = RUN_SPEED

	if Input.is_action_pressed("jump") == true and is_on_floor() == true:
		velocity.y = JUMP_VELOCITY
		
	velocity.y = clamp(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)

func calculate_states() -> void:
	
	if _state == PLAYER_STATE.HURT:
		pass
		
	if is_on_floor() == true:
		if velocity.x == 0:
			set_state(PLAYER_STATE.IDLE)
		else:
			set_state(PLAYER_STATE.RUN)
	else:
		if velocity.y > 0:
			set_state(PLAYER_STATE.FALL)
		else:
			set_state(PLAYER_STATE.JUMP)
			
	sprite_2d.flip_h = velocity.x < 0
			
func set_state(new_state: PLAYER_STATE) -> void:
	
	if new_state == _state: 
		return
	
	_state = new_state
	
	match _state:
		PLAYER_STATE.IDLE:
			animation_player.play("idle")
		PLAYER_STATE.JUMP:
			animation_player.play("jump")
		PLAYER_STATE.FALL:
			animation_player.play("fall")
		PLAYER_STATE.RUN:
			animation_player.play("run")
		PLAYER_STATE.HURT:
			animation_player.play("hurt")
