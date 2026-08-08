class_name Projectil
extends Node3D

@export var mesh_instance : MeshInstance3D
@export var rigid_body : RigidBody3D
@export var collision_shape : CollisionShape3D

@export var speed : float
@export var fall_acceleration : float

enum Faction{ALLY, ENEMY_1, ENVIRONMENT}
enum DamageType{SLASHING, PIERCING, BLUDGEONING}

@export var faction : Faction #enum
@export var damage_type : DamageType #enum
@export var dmage_amount : float
