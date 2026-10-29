extends RigidBody3D

@export var movement_speed: float = 25
@export var movement_acceleration: float = 100

@export var horizontal_linear_damp: float = 0.5 #ground_friction
var curent_horizontal_linear_damp: float = 0

#@export var jump_strength: float = 20

@export var terminal_velocity: float = 150

var move_direction: Vector3

@export var ground_collision: Area3D
var ground_collision_bodies_inside: int = 0
var is_on_floor: bool = true
##MOTION * SENSITIVITY
@export var camera_rotation_mouse_sensitivity: float = 0.001
##MOTION * SENSITIVITY
@export var camera_rotation_joypad_sensitivity: float = 0.05
@export var camera_pivot: Node3D

@export var character_visuals: CharacterVisuals
##The weight value in the rotations lerp, lerp(character_rotation, camera_rotation, value)
@export var character_visuals_rotation_weight: float = 0.1

var character_visual_rotation: float
var movment_direction_blend_amount: float

@export var jump_skill: JumpSkill
@export var dash_skill: DashSkill
@export var slide_skill: SlideSkill
@export var slam_skill: SlamSkill

@onready var character_skills: Array[CharacterSkill] = [jump_skill, dash_skill, slide_skill, slam_skill]

var linear_velocity_horizontal_angle: float
var visual_movment_angle: float

@export var equipped_weapon: Weapon
@export var weapon_inventory: Array [Weapon]
@export var interaction_area: Area3D
@export var main_interaction_detector: RayCast3D
@export var main_interaction_detector_marker: Marker3D

@export var step_up_colider: ShapeCast3D
@export var step_up_height: float = 5

#TODO: fat raycast to stinky ground so it do da step up

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
	
	
func add_weapon_to_inventory(weapon : Weapon) :
	weapon_inventory.append(weapon)
	weapon.is_interactable = false
	weapon.reparent(character_visuals.back_attachment)
	weapon.position = character_visuals.back_attachment.position
	weapon.rotation = Vector3(0,0,0) #stored_position (deve venir del weapon)


func swap_weapon() :
	if equipped_weapon != null :
		add_weapon_to_inventory(equipped_weapon)
		if equipped_weapon.second_hand_position != null:
			character_visuals.left_hand_ik.influence = 1
	weapon_inventory[0].reparent(character_visuals.right_hand_attachment)
	weapon_inventory[0].position = character_visuals.right_hand_attachment.position
	weapon_inventory[0].rotation = Vector3(90,-90,0) #held_position (deve venir del weapon)
	equipped_weapon = weapon_inventory[0]
	weapon_inventory.remove_at(0)


func interupt_skills_from_category(skill_category : CharacterSkill.SkillCategory, exeption : CharacterSkill):
	for character_skill in character_skills:
		if character_skill.skill_category == skill_category and not character_skill == exeption:
			character_skill.is_skill_active = false
			if character_skill.is_active_hold:
				character_skill._on_skill_cooldown_timer_timeout()
			#character_skill.skill_finished.emit()
			if character_skill.skill_finished_conected_callable:
				character_skill.skill_finished_conected_callable.call()
			character_skill._on_skill_finished()

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
		gravity_scale = 0
		linear_velocity.y = -0.1
		#print("ground colition = ", body)
		curent_horizontal_linear_damp = horizontal_linear_damp
		jump_skill.current_use_charges = jump_skill.max_use_charges
		is_on_floor = true
		if slam_skill.is_skill_active:
				#slam_skill.skill_finished.emit()
				if slam_skill.skill_finished_conected_callable:
					slam_skill.skill_finished_conected_callable.call()
				#slam_skill.skill_finished.emit()
				



func _physics_process(delta: float) -> void:
	#print(linear_velocity)
	#print(linear_damp)
#	el radio / posision de la deteccion deve de depender de la valosidad
#	STEP UP/
	if Vector2(linear_velocity.x,linear_velocity.z).length() > 0.1 or move_direction != Vector3.ZERO:
		step_up_colider.target_position = Vector3(linear_velocity.x/20,-1,linear_velocity.z/20)
		if step_up_colider.collide_with_bodies:
			if step_up_colider.get_collision_point(0).y > global_position.y and step_up_colider.get_collision_point(0).y < global_position.y + step_up_height:
				global_position.y = lerp(global_position.y, step_up_colider.get_collision_point(0).y, 0.6)
#	/STEP UP
	
#	CHARACTER_VISUALS ANIMATIONS/
	if is_on_floor:
		if linear_velocity.length() > 0.1:
			character_visuals.character_animation_tree.set("parameters/Transition Lower Half/transition_request", "Runing")
			linear_velocity_horizontal_angle = atan2(-linear_velocity.x, -linear_velocity.z)
			visual_movment_angle = angle_difference(character_visuals.rotation.y, linear_velocity_horizontal_angle)
			#if abs(visual_movment_angle) > 1.58:
			if abs(visual_movment_angle) > 1.7:
				movment_direction_blend_amount = ((visual_movment_angle / (-PI / 2)) / 2) - 0.5
				character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", -(linear_velocity.length() / 10))#14 = max walking speed
			else:
				movment_direction_blend_amount = ((visual_movment_angle / (-PI / 2)) / 2) + 0.5
				character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", linear_velocity.length() / 10)#14 = max walking speed
			#print(movment_direction_blend_amount)
			character_visuals.character_animation_tree.set("parameters/Blend Movment Direction/blend_amount", movment_direction_blend_amount)
		else :
			character_visuals.character_animation_tree.set("parameters/Transition Lower Half/transition_request", "Idle")
			character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", 1)
#	/CHARACTER_VISUALS ANIMATIONS
	
#	PLAYER ROTATE TO CAMERA DIRECTION/
	character_visuals.rotation = lerp(character_visuals.rotation, Vector3(0,camera_pivot.rotation.y,0), character_visuals_rotation_weight)
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
	#linear_velocity = clamp(linear_velocity, Vector3(-1,-1,-1) * movement_speed, Vector3(1,1,1) * movement_speed)
	move_direction = move_direction.rotated(Vector3(0,1,0), camera_pivot.rotation.y)
	if move_direction != Vector3.ZERO:
		#curent_horizontal_linear_damp = 0
		#move_direction = move_direction.normalized()
		if linear_velocity.x > movement_speed:
			move_direction.x = clamp(move_direction.x, -movement_speed, 0)
		if linear_velocity.x < -movement_speed:
			move_direction.x = clamp(move_direction.x, 0, movement_speed)
		if linear_velocity.z > movement_speed:
			move_direction.z = clamp(move_direction.z, -movement_speed, 0)
		if linear_velocity.z < -movement_speed:
			move_direction.z = clamp(move_direction.z, 0, movement_speed)

		
		#self.apply_central_force(Vector3(move_direction.x * movement_acceleration,0,move_direction.y * movement_acceleration).rotated(Vector3(0,1,0), camera_pivot.rotation.y))
		apply_central_force(Vector3(move_direction.x * movement_acceleration,0,move_direction.z * movement_acceleration))
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
			slide_skill.is_skill_active = false
			slide_skill._on_skill_cooldown_timer_timeout()
		if slam_skill.is_skill_active:
			slam_skill.is_skill_active = false
			slam_skill._on_skill_cooldown_timer_timeout()
			
	
	
	if Input.is_action_just_pressed("swap_weapon"):
		if weapon_inventory.size() > 0:
			swap_weapon()
			
	if Input.is_action_just_pressed("held_item_action_1"):
		print("click bitch")
		if equipped_weapon:
			equipped_weapon.atak()
			
			
	
	#if Input.is_action_just_released("slide"):
		#if slide_skill.is_skill_active:
			#if slide_skill.skill_finished_conected_callable:
				#slide_skill.skill_finished_conected_callable.call()
		#if slam_skill.is_skill_active:
			#if slam_skill.skill_finished_conected_callable:
				#slam_skill.skill_finished_conected_callable.call()
			
#	CAMERA ROTATION BY JOIPAD MOTION/
	camera_pivot.rotation += Vector3(Input.get_axis("look_down", "look_up") * camera_rotation_joypad_sensitivity, Input.get_axis("look_right", "look_left") * camera_rotation_joypad_sensitivity, 0)
#	/CAMERA ROTATION BY JOIPAD MOTION

	if equipped_weapon != null :
		#equipped_weapon.basis = Basis.from_euler(camera.global_rotation)
		equipped_weapon.global_rotation = camera_pivot.global_rotation
		if equipped_weapon.second_hand_position != null :
			#character_visuals.left_hand_ik.deterministic = true
			character_visuals.left_hand_ik.global_position = equipped_weapon.second_hand_position.global_position
		#else :
			#character_visuals.left_hand_ik.deterministic = false

func _input(event):
	#print(event)
	if event is InputEventMouseMotion:
		camera_pivot.rotation += Vector3(-event.relative.y * camera_rotation_mouse_sensitivity, -event.relative.x * camera_rotation_mouse_sensitivity, 0)
		
#	INTERACTION INPUT/
	if Input.is_action_just_pressed("interact"):
		for body in interaction_area.get_overlapping_bodies() :
			print("is interactable? : ", body.is_in_group("Interactable"), ", ", "is weapon? : ", body.is_in_group("Weapon"))
			print(body.get_class())
			if body.is_in_group("Interactable") :
				if body.is_in_group("Weapon") :
					add_weapon_to_inventory(body)
#	/INTERACTION INPUT
	
	
	

#	INTERACTION RAYCAST/
#TODO
	#var that_one_thing: Object
	#main_interaction_detector.target_position = main_interaction_detector_marker.position
	#if main_interaction_detector.get_collider():
		#that_one_thing = main_interaction_detector.get_collider()
		#print(that_one_thing is Interactable)
		#print(interaction_raycast.get_collider().get_class())
#	/INTERACTION RAYCAST
