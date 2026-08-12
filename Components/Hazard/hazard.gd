class_name Hazard
extends Node3D

enum Faction{ALLY, ENEMY_1, ENVIRONMENT}
enum DamageType{SLASHING, PIERCING, BLUDGEONING}

@export var faction : Faction #enum
@export var damage_type : DamageType #enum
@export var dmage_amount : float
