class_name Movement
extends Node

signal footstep_taken()

enum MOVE_TYPE { RUN , SPRINT , CROUCH, NONE }

@export var character: CharacterBody3D

@export var max_speed := 100
@export var break_speed:=45

@export var jump_peak_time := 0.5
@export var jump_fall_time := 0.5
@export var jump_height := 2.0
@export var jump_distance := 4.0
@export var sprint_jump_distance := 6.0
@export var crouch_jump_distance := 2.0

@export var coyote_timer: Timer
@export var input_buffer_timer: Timer


var move_speed_dict : Dictionary[MOVE_TYPE,int]
var jump_velocity:float
var jump_gravity:float
var fall_gravity:float

var debug_fastest_speed := 0.0

func _ready() -> void:
	await owner.ready
	character = owner as CharacterBody3D
	_set_jump_parameters()

func _physics_process(_delta: float) -> void:
	if character.velocity.length()>debug_fastest_speed:
		debug_fastest_speed = character.velocity.length()
		#print(debug_fastest_speed)
	check_coyote_time()
	if not input_buffer_timer: return
	if character.is_on_floor() and input_buffer_timer.time_left > 0.0:
			jump()

func move(direction:Vector3,move_type:MOVE_TYPE=MOVE_TYPE.RUN) -> void:
	var delta = get_process_delta_time()
	if not character: return

	var speed = move_speed_dict[move_type]

	if direction.length() > 1.0:
		direction = direction.normalized()

	if character.is_on_floor():
		if direction:
			character.velocity.x = direction.x * speed
			character.velocity.z = direction.z * speed
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, break_speed*delta)
			character.velocity.z = move_toward(character.velocity.z, 0, break_speed*delta)
	else:
		character.velocity.x = lerp(character.velocity.x,direction.x*speed,delta*5)
		character.velocity.z = lerp(character.velocity.z,direction.z*speed,delta*5)
	var velocity_without_vertical = Vector3(character.velocity.x,0,character.velocity.z);
	velocity_without_vertical = velocity_without_vertical.limit_length(max_speed)
	character.velocity = velocity_without_vertical + Vector3.UP*character.velocity.y 
	character.velocity = character.velocity.limit_length(max_speed)
	character.move_and_slide()

func handle_gravity():
	var delta = get_process_delta_time()
	if not character: return
	if not character.is_on_floor():
		var current_gravity = jump_gravity if character.velocity.y >0 else fall_gravity
		character.velocity.y -= current_gravity * delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("CROUCH"):
		character.global_position.y -= 10 * get_process_delta_time()

func jump(power_mult:float=1.0):
	if not character.is_on_floor(): input_buffer_timer.start()
	if coyote_timer.time_left > 0.0:
		character.velocity.y = jump_velocity * power_mult
		coyote_timer.stop()
		input_buffer_timer.stop()

func air_jump(direction:Vector3):
	character.velocity *= 0.2
	character.velocity.y = jump_velocity
	character.velocity += direction * 10.0

func _set_jump_parameters():
	jump_gravity = (2*jump_height)/pow(jump_peak_time,2)
	fall_gravity = (2*jump_height)/pow(jump_fall_time,2)
	jump_velocity = jump_gravity*jump_peak_time
	move_speed_dict[MOVE_TYPE.RUN] = jump_distance/(jump_peak_time+jump_fall_time)
	move_speed_dict[MOVE_TYPE.SPRINT] = sprint_jump_distance/(jump_peak_time+jump_fall_time)
	move_speed_dict[MOVE_TYPE.CROUCH] = crouch_jump_distance/(jump_peak_time+jump_fall_time)
	move_speed_dict[MOVE_TYPE.NONE] = 0



func check_coyote_time():
	if not coyote_timer:return
	if character.is_on_floor():
		coyote_timer.start()
