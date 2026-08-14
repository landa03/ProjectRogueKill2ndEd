class_name HealthPoints
extends Node3D

@export var max_health_points : float
var current_health_points : float

enum Faction{ALLY, ENEMY_1, ENVIRONMENT}
enum DamageType{SLASHING, PIERCING, BLUDGEONING}

@export var parent_faction : Faction

func _ready():
	current_health_points = max_health_points
#TODO: resistencias
func receive_damage(faction : Faction, damage_type : DamageType, dmage_amount : float):
	#print("ouch, ",self.get_parent()," takes ",dmage_amount, " ", damage_type, " from an ",faction)
	current_health_points -= dmage_amount
	print(self.get_parent(), " has ", current_health_points, " out of ", max_health_points)
