class_name PlayerState
extends State

@export var enable_head_bob := false
@export var can_interact:=false
var player:Player
var current_look_dir:=Vector2.ZERO
var time_since_enter:=0.0
var cached_vel_y

const STATE_STRINGS = {
	"IDLE":"PlayerStateIdle",
	"RUN":"PlayerStateRun",
	"CROUCH":"PlayerStateCrouch",
	"JUMP":"PlayerStateJumping",
	"INAIR":"PlayerStateInAir",
	"GRAPPLING":"PlayerStateGrappling",
	"AIRSLAM":"PlayerStateAirSlam",
	"HITREACT":"PlayerStateHitReact",
	"WALLRUN":"PlayerStateWallRun",
	}

func _ready() -> void:
	player = owner

func enter(_data=null)->void:
	#print(name)
	player.head_bob.enabled = enable_head_bob
	player.state_label.text = name
	time_since_enter = 0.0
	super(_data)

func exit()->void:
	super()

func tick(delta)->void:
	cached_vel_y = player.velocity.y
	#player.movement.check_coyote_time()
	time_since_enter += delta
	_handle_slow_time(delta)
	super(delta)
	
func physics_tick(delta)->void:
	super(delta)
	pass
	
func process_inputs(input_data:InputData)->void:
	_check_transitions(input_data)
	if can_interact: _check_actions(input_data)
	if input_data.held_actions.has("JUMP"):
		player.movement.jump()

func _check_transitions(input_data:InputData)->void:
	pass

func _move_player(move_type:Movement.MOVE_TYPE):
	var last_input_direction = player.last_input_data.direction
	var direction := player.transform.basis * Vector3(last_input_direction.x, 0, last_input_direction.y).normalized()
	player.movement.move(direction,move_type)
	player.movement.handle_gravity()

func _handle_slow_time(delta):
	var slow_time = player.last_input_data.held_actions.has("SLOW_TIME")
	var can_slow_time = false
	if slow_time:
		var has_stamina_left = player.stamina_meters[Arms.Hand.LEFT].try_use(10*delta/Engine.time_scale)
		var has_stamina_right = player.stamina_meters[Arms.Hand.RIGHT].try_use(10*delta/Engine.time_scale)
		can_slow_time = has_stamina_left or has_stamina_right
	TimeScale.slow_time(can_slow_time)
	#player.camera.fov = lerp(player.camera.fov,50.0 if can_slow_time else 75.0,5.0*delta)

func _handle_fall_kick():
	if player.is_on_floor():
		player.camera_effects.add_fall_kick(-cached_vel_y*0.5)
		player.cached_velocity.y = 0

func _check_actions(input_data):
	if input_data.just_pressed_actions.has("ALT_ACTION"):
			player.start_action(Arms.Hand.RIGHT)
	if input_data.just_pressed_actions.has("INTERACT"):
			player.start_action(Arms.Hand.LEFT)
	if input_data.just_released_actions.has("ALT_ACTION"):
			player.finish_action(Arms.Hand.RIGHT)
	if input_data.just_released_actions.has("INTERACT"):
			player.finish_action(Arms.Hand.LEFT)
