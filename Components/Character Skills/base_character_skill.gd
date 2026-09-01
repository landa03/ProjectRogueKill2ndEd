class_name CharacterSkill
extends Node

signal skill_activated

enum SkillCategory {UNKNOWN,MOVMENT}
@export var skill_category : SkillCategory = SkillCategory.UNKNOWN

#timers(
@export var skill_max_duration : float = 0
var skill_current_duration : float = skill_max_duration

@export var cooldown : float = 1
var current_cooldown : float = cooldown
#)timers

@export var cost_per_use : float = 1
@export var cost_per_second : float = 0

@export var max_use_charges : = 1
var current_use_charges : = max_use_charges

@export var is_skill_active : float = false

@export var skill_owner : PhysicsBody3D

func activate_skill():
	current_use_charges -= 1
	is_skill_active = true
	skill_activated.emit()
	current_cooldown = 0
	
func _physics_process(delta: float) -> void:
	if current_cooldown < cooldown :
		current_cooldown += 1
