class_name PlayerStateAirSlam
extends PlayerState

@export var base_up_velocity :=  5.0
var cur_up_velocity := 0.0
var starting_height:float

func enter(_data=null)->void:
	player.velocity.y = 0
	starting_height = player.global_position.y
	cur_up_velocity = base_up_velocity
	super(_data)

func exit()->void:
	super()

func physics_tick(_delta)->void:
	player.velocity.x -= player.velocity.x * 0.7 * _delta
	player.velocity.z -= player.velocity.z * 0.7 * _delta
	player.velocity.y += cur_up_velocity * 5.0 * _delta
	cur_up_velocity -= base_up_velocity * _delta * 2.0
	if cur_up_velocity < base_up_velocity * 0.3:
		player.velocity.y -= player.movement.fall_gravity * 20 * _delta * time_since_enter
	super(_delta)

func process_inputs(input_data:InputData)->void:
	_move_player(Movement.MOVE_TYPE.NONE)
	super(input_data)

func _check_transitions(input_data:InputData)->void:
	if player.is_on_floor():
		player.combat.slam_ground(player.movement.fall_gravity * time_since_enter)
		player.camera_effects.add_fall_kick(30)
		transition.emit(STATE_STRINGS.IDLE)
	super(input_data)
