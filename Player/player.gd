extends CharacterBody3D
#Player walking speed
@export var max_walking_speed: float = 14 
var walking_speed: float = 0
@export var air_controll: float = 2 
@export var air_controll_acceleration: float = 0.1
const ground_friction: float = 8

#The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration: float = 50
@export var jump_strength: float = 20
@export var max_jumps: int =  3
var remaining_jumps: int = 3

@export var camera_rotation_sensitivity: float = 0.1

@export var camera_pivot: Node3D
@export var camera: Camera3D

@export var terminal_velocity: Vector3 = Vector3(50, 50, 50)

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var anim_direction = Vector2.ZERO
@export var character_visuals : CharacterVisuals

#var forward

var moovment_direction_blend_amount : float
var character_visual_rotation : float

@export var weapon_inventory : Array [Weapon]
@export var interaction_area : Area3D
@export var equipped_weapon : Weapon
#var interactions_available : Array [Interactable]

#TODO : dash
#	stamina
#		costo, current & max
#	timeline
#		duration
#	last direction input
#	dash speed
var is_mid_dash : bool = false
@export var max_stamina : int = 5
var curent_stamina : float = max_stamina

enum MovmentState {UNKNOUN, IDLE, RUNING, DASHING, SLIDING, SLAMING, MID_AIR}
var current_movment_state : MovmentState = MovmentState.IDLE

@export var dash_skill : DashSkill
@export var Slide_skill : CharacterSkill
#@export var skill_type : CharacterSkill.SkillCategory



func _ready():
	# Makes your mouse disappear from the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_visuals.character_animation_tree.animation_finished.connect(play_animation_after_jump)

func on_interaction():
	#if interaction_area.get_overlapping_bodies().has(Weapon):
		#weapon_inventory.append(interaction_area.get_overlapping_bodies().find(Weapon))
	
	for body in interaction_area.get_overlapping_bodies() :
		print("is interactable? : ", body.is_in_group("Interactable"), ", ", "is weapon? : ", body.is_in_group("Weapon"))
		if body.is_in_group("Interactable") :
			if body.is_in_group("Weapon") :
				
				add_weapon_to_inventory(body)
				#character_visuals.back_attachment.add_child(body)
				
		

func add_weapon_to_inventory(weapon : Weapon) :
	weapon_inventory.append(weapon)
	weapon.is_interactable = false
	weapon.reparent(character_visuals.back_attachment)
	weapon.position = character_visuals.back_attachment.position
	weapon.rotation = Vector3(0,0,0) #stored_position (deve venir del weapon)
	#weapon.basis = Basis.from_euler(camera.basis.get_euler())
#	Basis.from_euler(projectile_egress.global_rotation) 
	
#TODO : mejorar el ik y agregar el ik de la otra mano
#TODO : hacer armas melee
#TODO : implementar veneficios por movimiento

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

func play_animation_after_jump(anim_name: StringName):
	match anim_name :
		"Jump":
			character_visuals.character_animation_tree.set("parameters/Transition Lower Half/transition_request", "Falling")
	#print(anim_name)
#TODO
func solve_movment_state(new_movment_state : MovmentState):
	print(MovmentState.find_key(current_movment_state))
	#CANCELA UN ESTADO AL INGRESAR UNO NUEVO, AL TERMINAR UN ESTADO CAMBIA A OTRO DEPENDIENDO DE LAS CONDICIONES	
#	MOOVMENT STATE SULVA
	current_movment_state = new_movment_state
#	MOOVMENT STATE SULVA/
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		on_interaction()
		#print("interaction presed")
	
	if Input.is_action_just_pressed("swap_weapon"):
		if weapon_inventory.size() > 0:
			swap_weapon()
			
		#print("swap weapon presed")
	
	if Input.is_action_just_pressed("held_item_action_1"):
		if equipped_weapon != null :
			equipped_weapon.atak()
		print("held_item_action_1 presed")
	
	if Input.is_action_just_pressed("dash"):
		dash_skill.dash_direction = direction
		dash_skill.activate_skill()
		print("dash presed")
	
	if equipped_weapon != null :
		#equipped_weapon.basis = Basis.from_euler(camera.global_rotation)
		equipped_weapon.global_rotation = camera.global_rotation
		if equipped_weapon.second_hand_position != null :
			#character_visuals.left_hand_ik.deterministic = true
			character_visuals.left_hand_ik.global_position = equipped_weapon.second_hand_position.global_position
		#else :
			#character_visuals.left_hand_ik.deterministic = false
			
	
#PLAYER MOOVMENT/ DIRECTION
	direction.x = Input.get_axis("move_left", "move_right")
	#print(Input.get_axis("move_left", "move_right"))
	direction.z = Input.get_axis("move_forward" , "move_back")

	walking_speed = max_walking_speed * direction.length()
	#print(walking_speed)
#	might be an error, aprox zero
	if direction != Vector3.ZERO:
		#direction = direction.normalized()
		direction = direction.rotated(self.up_direction, self.rotation.y).normalized()
			
#PLAYER MOOVMENT/ DIRECTION
	
	
	
	#target_velocity.x = direction.x * walking_speed
	#target_velocity.z = direction.z * walking_speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
		#target_velocity.x = lerpf(self.velocity.x ,direction.x * walking_speed, delta * air_controll)
		#target_velocity.z = lerpf(self.velocity.z ,direction.z * walking_speed, delta * air_controll)
		target_velocity.x = velocity.x + direction.x * walking_speed * delta * air_controll
		target_velocity.z = velocity.z + direction.z * walking_speed * delta * air_controll
		
	else :
		target_velocity.y = 0
		remaining_jumps = max_jumps
		#target_velocity.x = target_velocity.x + self.velocity.x / 1.1
		target_velocity.x = lerpf(self.velocity.x ,direction.x * walking_speed, delta * ground_friction)
		target_velocity.z = lerpf(self.velocity.z ,direction.z * walking_speed, delta * ground_friction)

	if Input.is_action_just_pressed("jump") and remaining_jumps > 0:
		#target_velocity.y = target_velocity.y + jump_strength
		target_velocity.y = jump_strength
		remaining_jumps -= 1
		character_visuals.character_animation_tree.set("parameters/Transition Lower Half/transition_request", "Jump")
		character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", 1)
	if target_velocity.length() > terminal_velocity.length():
		target_velocity = target_velocity.clamp(-terminal_velocity, terminal_velocity)
	
	velocity = target_velocity
	#velocity.move_toward(Vector3.ZERO, delta)
	move_and_slide()
	
#	ATAKS
	
	
	
#	ATAKS/
	
	
#	ANIMATION
#	ANIMATIONNODEBLENDTREE
	#print(velocity.length() / max_walking_speed)
	#var character_visual_rotation = atan2(-velocity.x, -velocity.z)

		
#	TODO : hacer que jire el cuerpo en todo momento asia donde apunta la camara
	if is_on_floor():
		if velocity.length() > 0.2 :
			character_visuals.character_animation_tree.set("parameters/Transition Lower Half/transition_request", "Runing")
			
			
			character_visual_rotation = atan2(-velocity.x, -velocity.z)
			character_visuals.global_rotation.y = character_visual_rotation
			moovment_direction_blend_amount = ((-character_visuals.rotation.y / (PI / 2)) / 2) + 0.5
			character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", velocity.length() / 10)#14 = max walking speed
			
			if abs(angle_difference(character_visual_rotation, rotation.y)) > 1.58:
				character_visuals.global_rotation.y = character_visual_rotation - PI
				moovment_direction_blend_amount = (((-character_visuals.rotation.y / (PI / 2)) / 2) + 0.5) * 1
				character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", -(velocity.length() / 10))#14 = max walking speed

			character_visuals.character_animation_tree.set("parameters/Blend Movment Direction/blend_amount", moovment_direction_blend_amount)

	
			#character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", 1)
		else :
			character_visuals.character_animation_tree.set("parameters/Transition Lower Half/transition_request", "Idle")
			character_visuals.character_animation_tree.set("parameters/TimeScale Lower Half/scale", 1)

		#print("air born")
		#character_visuals.character_animation_tree.set("parameters/Transition Lower Half/transition_request", "Falling")


#	ANIMATIONNODEBLENDTREE/
#	ANIMATION/

#func _process(delta: float) -> void:
	#print(direction)

func _input(event):
	#print(event is InputEventMouseMotion)
	if event is InputEventMouseMotion:
		var camera_rotation = event.relative * camera_rotation_sensitivity
		self.rotate(Vector3.DOWN, deg_to_rad(camera_rotation.x))
		camera_pivot.rotate(Vector3.RIGHT, deg_to_rad(-camera_rotation.y))
# TODO : areglar como se maneja la gravedad 
