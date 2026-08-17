class_name RangedWeapon
extends Node3D

@export var projectile_scene : PackedScene
@export var projectile_instance : Projectil
@export var projectile_egress : Node3D

@export var projectil_speed : float
@export var projectil_gravity : float
var projectil_forward_vector : Vector3

@export var hazard : Hazard

@export var projectil_time_limit : float = 60
@export var projectil_bounce_limit : int = 10
@export var is_projectil_explosive : bool

#TODO : add explosion data variables


#func _ready() -> void:
	#projectile_scene


func atak():
	projectile_instance = projectile_scene.instantiate()
	projectile_instance.initialize()
	projectile_instance.speed = projectil_speed
	projectile_instance.gravity = projectil_gravity
	projectile_instance.forward_vector = projectil_forward_vector
	projectile_instance.hazard = hazard
	projectile_instance.time_limit = projectil_time_limit
	projectile_instance.bounce_limit = projectil_bounce_limit
	projectile_instance.bounce_limit = projectil_bounce_limit
	
