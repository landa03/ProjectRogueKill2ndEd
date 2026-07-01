extends CharacterBody3D
#Player walking speed
@export var walking_speed: float = 14 
#The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration: float = 75

var target_velocity = Vector3.ZERO
func _physics_process(delta: float) -> void:

	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	target_velocity.x = direction.x * walking_speed
	target_velocity.z = direction.z * walking_speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()

# TODO : encontrar forma de hacer que la camara / personaje gire conforme a el movimiento del mouse 
