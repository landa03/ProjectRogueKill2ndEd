class_name Projectil
extends RigidBody3D

@export var mesh_instance : MeshInstance3D
#@export var rigid_body : RigidBody3D
@export var collision_shape : CollisionShape3D
@export var time_limit_timer : Timer

var speed : float = 1
var gravity : float = 0
var movment_direction : Vector3

@export var hazard : Hazard

var time_limit : float = 60
var bounce_limit : int = 10
var current_bounces : int = 0

var is_explosive : bool = false
#TODO : add explosion and its data variables
#@esport var explosion : Explosion

var parent_weapon : RangedWeapon

func _ready() -> void:
	movment_direction = -self.get_global_transform_interpolated().basis.z
	gravity_scale = gravity
	self.contact_monitor = true
	self.max_contacts_reported = 10
	self.body_entered.connect(on_body_entered)
	time_limit_timer.start(time_limit)
	time_limit_timer.timeout.connect(on_time_limit_timer_timeout)
	
func destroy_projectile():
	queue_free()
#	TODO: hecer que explote si es explosivo
	
func on_time_limit_timer_timeout():
	print("time out")
	destroy_projectile()
	
func on_body_entered (body: Node):
	for child in body.get_children():
		if child is HealthPoints:
			child.receive_damage(hazard.faction, hazard.damage_type, hazard.dmage_amount)
			
	if current_bounces >= bounce_limit:
		print("pop")
		destroy_projectile()
	else :
		current_bounces += 1
		print(current_bounces, " boing")
	
func _physics_process(delta: float) -> void:
	apply_central_force(movment_direction * speed)
	#apply_central_force(movment_direction * parent_weapon.projectil_speed)
	#print(movment_direction * speed)
