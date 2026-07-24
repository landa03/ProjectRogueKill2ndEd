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

@export var character_visuals : CharacterVisuals


func _physics_process(delta: float) -> void:

#PLAYER MOOVMENT/ DIRECTION
	direction.x = Input.get_axis("move_left", "move_right")
	#print(Input.get_axis("move_left", "move_right"))
	direction.z = Input.get_axis("move_forward" , "move_back")

	walking_speed = max_walking_speed * direction.length()
	#print(walking_speed)
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
	if target_velocity.length() > terminal_velocity.length():
		target_velocity = target_velocity.clamp(-terminal_velocity, terminal_velocity)
	
	velocity = target_velocity
	#velocity.move_toward(Vector3.ZERO, delta)
	move_and_slide()
	
#	ANIMATION
	
	
	
	#if is_on_floor():
		#character_visuals.character_animation_player.play("Idle")
	#else :
		#character_visuals.character_animation_player.stop(true)
		
#	separarle por parte de ariba y parte de abajo
#	tenerlos por booleanos con prioridades, de ariba asia abajo en orden de mayor prio a menor prio
	
	
#	ANIMATION

func _process(delta: float) -> void:
	print(self.velocity.length())
	#print(self.is_on_floor())

func _ready():
	# Makes your mouse disappear from the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#print(event is InputEventMouseMotion)
	if event is InputEventMouseMotion:
		var camera_rotation = event.relative * camera_rotation_sensitivity
		self.rotate(Vector3.DOWN, deg_to_rad(camera_rotation.x))
		camera_pivot.rotate(Vector3.RIGHT, deg_to_rad(-camera_rotation.y))
# TODO : areglar como se maneja la gravedad 
