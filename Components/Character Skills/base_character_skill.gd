class_name CharacterSkill
extends Node

signal skill_activated
signal skill_finished

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

@export var max_use_charges : int = 1
var current_use_charges : int = max_use_charges

@export var is_skill_active : float = false

@export var skill_owner : CharacterBody3D

func activate_skill():
	current_cooldown = 0
	skill_current_duration = 0
	current_use_charges -= 1
	is_skill_active = true
	skill_activated.emit()
	
func _physics_process(delta: float) -> void:
	if current_cooldown < cooldown and current_use_charges < max_use_charges :
		current_cooldown += 1
	elif current_cooldown > cooldown and current_use_charges < max_use_charges:
		current_use_charges += 1
		current_cooldown = 0
		
	if is_skill_active and skill_current_duration < skill_max_duration:
		skill_current_duration += 1
	else :
		skill_finished.emit()
