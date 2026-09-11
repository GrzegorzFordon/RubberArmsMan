class_name Player
extends CharacterBody3D

@export var state_machine: StateMachine

@export var camera: Camera3D
@export var head: Node3D
@export var arms: Arms

#Components
@export var audio_stream_player: AudioStreamPlayer3D
@export var camera_effects: CameraEffects
@export var hud: HUD
@export var screen_space_vfx: ScreenSpaceVFX
@export var movement: Movement
@export var interactor: Interactor
@export var step_handler: StepHandler
@export var grappling: Grappling
@export var rigid_body_pusher: RigidBodyPusher
@export var combat: Combat
@export var crouching: Crouching
@export var vfx_controller: VFXController
@export var camera_rotation: CameraRotation
@export var ray_caster: RayCaster
@export var wall_run: WallRun
@export var head_bob: HeadBob

@export var smooth_step_enabled:=true
@export var controller_enabled := false

#Meters
@export var stamina_meters: Dictionary[Arms.Hand,Meter]

#Debug Labels
@export var state_label: Label
@export var velocity_label: Label
@export var fps_label: Label
@export var tension_label: Label
@export var floor_push_label: Label
@export var spring_label: Label
@export var facing_label: Label
@export var building_push_label: Label
@export var rest_length_label: Label
@export var target_dist_label: Label

var head_height := 1.5
var cached_velocity
var respawn_position:=Vector3.ZERO
var last_input_data:=InputData.new()


func _ready() -> void:
	InputManager.inputs_gathered.connect(_process_inputs)
	respawn_position = global_position

func _process(delta: float) -> void:
	state_machine.tick(delta)
	cached_velocity = velocity
	_debug_update_labels()

func _physics_process(delta: float) -> void:
	state_machine.physics_tick(delta)
	rigid_body_pusher.push_away_rigid_bodies()

func _process_inputs(input_dict:Dictionary[int,InputData]):
	var data = input_dict[InputManager.most_recent_device_id if controller_enabled else -1]
	var direction := transform.basis * Vector3(data.direction.x, 0, data.direction.y).normalized()
	var is_controller = InputManager.most_recent_device_id != -1 if controller_enabled else false
	step_handler.handle_step_climbing(direction)
	camera_rotation.rotate(data.direction_alt.x,data.direction_alt.y,is_controller)
	state_machine.process_inputs(data)
	last_input_data.direction = data.direction
	last_input_data.held_actions = data.held_actions

func start_action(hand:Arms.Hand):
	if combat.has_target():
		combat.punch(hand)
		pass
	elif interactor.has_candidate():
		#interactor.start_interact()
		arms.set_arm_action(hand,Arm.Action.CARRYING)
		arms.set_arm_target_position(hand,interactor.current_candidate.owner.global_position)
		pass
	elif grappling.has_target() or grappling.hit_sky:
		grappling.launch(hand)
		pass
	else:
		arms.arms_dict[hand].set_open_amount(1)

func finish_action(hand:Arms.Hand):
	arms.set_arm_action(hand,Arm.Action.IDLE)


func _debug_update_labels():
	var spd = velocity.length() as int
	velocity_label.text = "Speed: "+str(spd)
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second() as int)
