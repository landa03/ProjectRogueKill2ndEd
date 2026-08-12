class_name Projectil
extends RigidBody3D

@export var mesh_instance : MeshInstance3D
#@export var rigid_body : RigidBody3D
@export var collision_shape : CollisionShape3D

@export var speed : float
@export var gravity : float
var forward_vector : Vector3

@export var hazard : Hazard

#enum DisipationMethod{TYME, BOUNCE}
#@export var disipation_method : DisipationMethod #enum
@export var time_limit : float
@export var bounce_limit : int

func _ready() -> void:
	forward_vector = self.get_global_transform_interpolated().basis.x
	gravity_scale = gravity
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	apply_central_force(forward_vector * speed)
	#print(forward_vector * speed)

func _on_body_entered (body : Node3D):
	pass
