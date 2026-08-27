class_name RangedWeapon
extends Weapon

@export var projectile_scene : PackedScene
#@export var projectile_instance : Projectil
var projectile_instance : Projectil
@export var projectile_egress : Node3D

var forward_vector : Vector3

@export var projectil_speed : float
@export var projectil_gravity : float
var projectil_forward_vector : Vector3

@export var projectil_time_limit : float = 60
@export var projectil_bounce_limit : int = 10
@export var is_projectil_explosive : bool

#TODO : add explosion data variables

@export var timer : Timer

func _ready() -> void:
	forward_vector = -self.get_global_transform_interpolated().basis.z
	timer.timeout.connect(on_timer_time_out)
	self.is_interactable = true

func on_timer_time_out():
	atak()

func atak():
	print("shoot")
	projectile_instance = projectile_scene.instantiate()
	projectile_instance.speed = projectil_speed
	projectile_instance.gravity = projectil_gravity
	projectile_instance.forward_vector = projectil_forward_vector
	projectile_instance.hazard = hazard
	projectile_instance.time_limit = projectil_time_limit
	projectile_instance.bounce_limit = projectil_bounce_limit
	projectile_instance.bounce_limit = projectil_bounce_limit
	projectile_instance.parent_weapon = self
	projectile_instance.position = projectile_egress.position
	self.add_child(projectile_instance)
	projectile_instance.apply_central_impulse(forward_vector * projectil_speed)
	
