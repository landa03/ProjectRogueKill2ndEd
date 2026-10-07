extends RigidBody3D

@export var movemnt_speed: float = 25
@export var movemnt_acceleration: float = 100

@export var horizontal_linear_damp: float = 0.5 #ground_friction
var curent_horizontal_linear_damp: float = 0

#@export var jump_strength: float = 20

@export var terminal_velocity: float = 150

var move_direction : Vector3

@export var ground_collision: Area3D
var ground_collision_bodies_inside: int = 0
var is_on_floor: bool = true
##MOTION * SENSITIVITY
@export var camera_rotation_mouse_sensitivity: float = 0.001
##MOTION * SENSITIVITY
@export var camera_rotation_joypad_sensitivity: float = 0.05
@export var camera_pivot: Node3D

@export var character_visuals : CharacterVisuals

@export var jump_skill: JumpSkill
@export var dash_skill: DashSkill
@export var slide_skill: SlideSkill
@export var slam_skill: SlamSkill

@onready var character_skills: Array[CharacterSkill] = [jump_skill, dash_skill, slide_skill, slam_skill]

#si el punto con el que colisiona el personaje esta abajo de el personaje
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	curent_horizontal_linear_damp = horizontal_linear_damp
	contact_monitor = true
	#self
	#body_entered.connect(_on_body_entered)
	#print("poop ", body_entered.is_connected(_on_body_entered), " ", contact_monitor)
	#pass
	#ground_collision
	ground_collision.body_entered.connect(_on_ground_collision_body_entered)
	ground_collision.body_exited.connect(_on_ground_collision_body_exited)
	

func interupt_skills_from_category(skill_category : CharacterSkill.SkillCategory, exeption : CharacterSkill):
	for character_skill in character_skills:
		if character_skill.skill_category == skill_category and not character_skill == exeption:
			character_skill.is_skill_active = false
			character_skill.skill_finished.emit()

func _on_ground_collision_body_exited(body:Node):
	ground_collision_bodies_inside = ground_collision_bodies_inside - 1
	if ground_collision_bodies_inside < 0:
		ground_collision_bodies_inside = 0
	if ground_collision_bodies_inside < 1:
		#print("is of ground")
		gravity_scale = 3
		curent_horizontal_linear_damp = 0
		is_on_floor = false
	#print("is_on_floor = ", is_on_floor)
	#print("ground_collision_bodies_inside = ", ground_collision_bodies_inside)

func _on_ground_collision_body_entered(body:Node):
	ground_collision_bodies_inside = ground_collision_bodies_inside + 1
	if ground_collision_bodies_inside > 0:
		#print("is on ground")
		gravity_scale = 0.5
		linear_velocity.y = 0
		#print("ground colition = ", body)
		curent_horizontal_linear_damp = horizontal_linear_damp
		jump_skill.current_use_charges = jump_skill.max_use_charges
		is_on_floor = true
		if slam_skill.is_skill_active:
				slam_skill.skill_finished.emit()
	#print("is_on_floor = ", is_on_floor)
	#print("ground_collision_bodies_inside = ", ground_collision_bodies_inside)

#func _on_body_entered(body:Node) :
	#print("body")
	#if is_zero_approx(linear_velocity.y):
		#print("bonck")
	#print(ray_cast_downwards.target_position)

func _physics_process(delta: float) -> void:
	#print(linear_velocity)
	#print(linear_damp)
	
#	PLAYER ROTATE TO CAMERA DIRECTION/
	
#	/PLAYER ROTATE TO CAMERA DIRECTION
	
#	TEMINAL VELOSITY/
	linear_velocity.x = clamp(linear_velocity.x, -terminal_velocity, terminal_velocity)
	linear_velocity.y = clamp(linear_velocity.y, -terminal_velocity, terminal_velocity)
	linear_velocity.z = clamp(linear_velocity.z, -terminal_velocity, terminal_velocity)
#	/TEMINAL VELOSITY

#	MY DAMP/
	if linear_velocity.x > 0:
		linear_velocity.x -= curent_horizontal_linear_damp
	if linear_velocity.x < 0:
		linear_velocity.x += curent_horizontal_linear_damp
	if linear_velocity.z > 0:
		linear_velocity.z -= curent_horizontal_linear_damp
	if linear_velocity.z < 0:
		linear_velocity.z += curent_horizontal_linear_damp
	#linear_velocity.x -= horizontal_linear_damp
#	/MY DAMP

#	BASIC MOVMENT/
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_back")
	#linear_velocity = clamp(linear_velocity, Vector3(-1,-1,-1) * movemnt_speed, Vector3(1,1,1) * movemnt_speed)
	move_direction = move_direction.rotated(Vector3(0,1,0), camera_pivot.rotation.y)
	if move_direction != Vector3.ZERO:
		#curent_horizontal_linear_damp = 0
		#move_direction = move_direction.normalized()
		if linear_velocity.x > movemnt_speed:
			move_direction.x = clamp(move_direction.x, -movemnt_speed, 0)
		if linear_velocity.x < -movemnt_speed:
			move_direction.x = clamp(move_direction.x, 0, movemnt_speed)
		if linear_velocity.z > movemnt_speed:
			move_direction.z = clamp(move_direction.z, -movemnt_speed, 0)
		if linear_velocity.z < -movemnt_speed:
			move_direction.z = clamp(move_direction.z, 0, movemnt_speed)

		
		#self.apply_central_force(Vector3(move_direction.x * movemnt_acceleration,0,move_direction.y * movemnt_acceleration).rotated(Vector3(0,1,0), camera_pivot.rotation.y))
		apply_central_force(Vector3(move_direction.x * movemnt_acceleration,0,move_direction.z * movemnt_acceleration))
	#if ground_collision.has_overlapping_bodies() :
		#if Input.is_action_just_pressed("jump"):
			#jump_skill.activate_skill()
	if Input.is_action_just_pressed("jump"):
		if jump_skill.is_skill_available:
			interupt_skills_from_category(CharacterSkill.SkillCategory.MOVMENT, jump_skill)
		jump_skill.activate_skill()
#	/BASIC MOVMENT
		
	if Input.is_action_just_pressed("dash"):
		#print(Vector3(move_direction.x,0,move_direction.y).length())
		if move_direction.length() < 0.25:
			move_direction = Vector3(0,0,-1).rotated(Vector3(0,1,0), camera_pivot.rotation.y)
		dash_skill.dash_direction = move_direction
		if dash_skill.is_skill_available:
			interupt_skills_from_category(CharacterSkill.SkillCategory.MOVMENT, dash_skill)
		dash_skill.activate_skill()
	
	if Input.is_action_just_pressed("slide"):
		if is_on_floor:
			if move_direction.length() < 0.25:
				move_direction = Vector3(0,0,-1).rotated(Vector3(0,1,0), camera_pivot.rotation.y)
			slide_skill.slide_direction = move_direction
			if slide_skill.is_skill_available:
				interupt_skills_from_category(CharacterSkill.SkillCategory.MOVMENT, slide_skill)
			slide_skill.activate_skill()
		else:
			if slam_skill.is_skill_available:
				interupt_skills_from_category(CharacterSkill.SkillCategory.MOVMENT, slam_skill)
			slam_skill.activate_skill()
			
	if Input.is_action_just_released("slide"):
		if slide_skill.is_skill_active:
			slide_skill.skill_finished.emit()
		if slam_skill.is_skill_active:
			slam_skill.skill_finished.emit()
			
#	CAMERA ROTATION BY JOIPAD MOTION/
	camera_pivot.rotation += Vector3(Input.get_axis("look_down", "look_up") * camera_rotation_joypad_sensitivity, Input.get_axis("look_right", "look_left") * camera_rotation_joypad_sensitivity, 0)
#	/CAMERA ROTATION BY JOIPAD MOTION

#TODO: fuking basis >:(
func _input(event):
	#print(event)
	if event is InputEventMouseMotion:
		camera_pivot.rotation += Vector3(-event.relative.y * camera_rotation_mouse_sensitivity, -event.relative.x * camera_rotation_mouse_sensitivity, 0)
