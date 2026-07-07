extends CharacterBody3D
#Player walking speed
@export var max_walking_speed: float = 14 
var walking_speed: float = 0
@export var ari_controll: float = 0.8 
#The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration: float = 50
@export var jump_strength: float = 20
@export var max_jumps: int =  3
var remaining_jumps: int = 3

@export var camera_rotation_sensitivity: float = 0.1

@export var camera_pivot: Node3D
@export var camera: Camera3D

var target_velocity = Vector3.ZERO
func _physics_process(delta: float) -> void:

#PLAYER MOOVMENT/ DIRECTION
	var direction = Vector3.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	#print(Input.get_axis("move_left", "move_right"))
	direction.z = Input.get_axis("move_forward" , "move_back")

	walking_speed = max_walking_speed * direction.length()
	#print(walking_speed)
	if direction != Vector3.ZERO:
		#direction = direction.normalized()
		direction = direction.rotated(self.up_direction, self.rotation.y).normalized()
#PLAYER MOOVMENT/ DIRECTION
	
	
	
	target_velocity.x = direction.x * walking_speed
	target_velocity.z = direction.z * walking_speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
		#target_velocity.x = direction.x * walking_speed / ari_controll
		#target_velocity.z = direction.z * walking_speed / ari_controll
		target_velocity.x = self.velocity.x + direction.x * walking_speed * ari_controll / 10
		target_velocity.z = self.velocity.z + direction.z * walking_speed * ari_controll / 10
	else :
		target_velocity.y = 0
		remaining_jumps = max_jumps
	
	if Input.is_action_just_pressed("jump") and remaining_jumps > 0:
		#target_velocity.y = target_velocity.y + jump_strength
		target_velocity.y = jump_strength
		remaining_jumps -= 1
		
	velocity = target_velocity
	move_and_slide()
	

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
