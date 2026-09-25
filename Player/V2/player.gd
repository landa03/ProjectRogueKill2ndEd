extends RigidBody3D

@export var movemnt_speed: float = 25
@export var movemnt_acceleration: float = 50

@export var terminal_velocity: float = 150

var move_direction : Vector2

@export var ground_collision: Area3D

#si el punto con el que colisiona el personaje esta abajo de el personaje
func _ready() -> void:
	contact_monitor = true
	#self
	body_entered.connect(_on_body_entered)
	print("poop ", body_entered.is_connected(_on_body_entered), " ", contact_monitor)
	#pass
	ground_collision.body_entered.connect(_on_ground_collision_body_entered)
	

func _on_ground_collision_body_entered(body:Node):
	print(body)

func _on_body_entered(body:Node) :
	#ray_cast_downwards.target_position
	print("")
	#if is_zero_approx(linear_velocity.y):
		#print("bonck")
	#print(ray_cast_downwards.target_position)
var state
func _physics_process(delta: float) -> void:
	#print(linear_velocity)
	
	
	
#	BASIC MOVMENT/
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.y = Input.get_axis("move_forward", "move_back")
	#linear_velocity = clamp(linear_velocity, Vector3(-1,-1,-1) * movemnt_speed, Vector3(1,1,1) * movemnt_speed)
	linear_velocity.x = clamp(linear_velocity.x, -terminal_velocity, terminal_velocity)
	linear_velocity.y = clamp(linear_velocity.y, -terminal_velocity, terminal_velocity)
	linear_velocity.z = clamp(linear_velocity.z, -terminal_velocity, terminal_velocity)
	if move_direction != Vector2.ZERO:
		move_direction = move_direction.normalized()
		if linear_velocity.x > movemnt_speed:
			move_direction.x = clamp(move_direction.x, -movemnt_speed, 0)
		if linear_velocity.x < -movemnt_speed:
			move_direction.x = clamp(move_direction.x, 0, movemnt_speed)
		if linear_velocity.z > movemnt_speed:
			move_direction.y = clamp(move_direction.y, -movemnt_speed, 0)
		if linear_velocity.z < -movemnt_speed:
			move_direction.y = clamp(move_direction.y, 0, movemnt_speed)
		
		self.apply_central_force(Vector3(move_direction.x * movemnt_acceleration,0,move_direction.y * movemnt_acceleration))
	if ground_collision.has_overlapping_bodies() :
		if Input.is_action_just_pressed("jump"):
			self.apply_central_impulse(Vector3(0,20,0))
#	/BASIC MOVMENT
	
