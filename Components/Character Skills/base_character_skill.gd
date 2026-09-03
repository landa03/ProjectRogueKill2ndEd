class_name CharacterSkill
extends Node

signal skill_activated
signal skill_finished

enum SkillCategory {UNKNOWN,MOVMENT}
@export var skill_category : SkillCategory = SkillCategory.UNKNOWN

@export var cost_per_use : float = 1
@export var cost_per_second : float = 0

@export var max_use_charges : int = 1
var current_use_charges : int = max_use_charges :
	set(new_value):
		current_use_charges = clamp(new_value, 0, max_use_charges)
		if current_use_charges > 0:
			is_skill_available = true
		else:
			is_skill_available = false

@export var skill_owner : CharacterBody3D

@export var is_active_hold : bool = false

#timers(
@export_group("Skill Timers")
@export var skill_duration_timer : Timer
@export var skill_duration_wait_time : float :
	set(new_value):
		skill_duration_timer.wait_time = new_value
		skill_duration_wait_time = new_value
@export var skill_cooldown_timer : Timer
@export var skill_cooldown_wait_time : float :
	set(new_value):
		skill_cooldown_timer.wait_time = new_value
		skill_cooldown_wait_time = new_value
#)timers

var is_skill_active : bool = false
var is_skill_available : bool = true

func _ready():
	if not is_active_hold :
		skill_duration_timer.timeout.connect(_on_skill_duration_timer_timeout)
	skill_duration_timer.wait_time = skill_duration_wait_time
	skill_cooldown_timer.timeout.connect(_on_skill_cooldown_timer_timeout)
	skill_cooldown_timer.wait_time = skill_cooldown_wait_time

func activate_skill():
	if is_skill_available:
		current_use_charges -= 1
		is_skill_active = true
		skill_activated.emit()
		skill_duration_timer.start()
		skill_cooldown_timer.start()
		#if current_use_charges <= 0 :
			#is_skill_available = false
			
	
#	phisics dont run
func _on_skill_duration_timer_timeout():
	is_skill_active = false

func _on_skill_cooldown_timer_timeout():
	if current_use_charges < max_use_charges :
		current_use_charges += 1
