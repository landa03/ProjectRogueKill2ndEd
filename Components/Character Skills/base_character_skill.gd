class_name CharacterSkill
extends Node

signal skill_activated
signal skill_finished
signal skill_not_available

#@export var skill_name: String = "unamed_skill"
@export var skill_instance: CharacterSkill = self

enum SkillCategory {UNKNOWN,MOVMENT}
@export var skill_category : SkillCategory = SkillCategory.UNKNOWN

#enum MoovmentState

@export var cost_per_use : float = 1
#@export var cost_per_second : float = 0
@export var required_resource : CharacterResource

@export var max_use_charges : int = 2
var current_use_charges : int :
	set(new_value):
		#print("current_use_charges = ", current_use_charges, ": new_value = ", new_value)
		#current_use_charges = clamp(new_value, 0, max_use_charges)
		if new_value > max_use_charges:
			new_value = max_use_charges
		if new_value < 0:
			new_value = 0
		current_use_charges = new_value
		
		if current_use_charges > 0:
			is_skill_available = true
		else:
			is_skill_available = false
			

#@export var skill_owner : CharacterBody3D
@export var skill_owner : RigidBody3D

@export var is_active_hold : bool = false
@export var is_cooldown_available: bool = true #TODO : implement

#timers(
@export_group("Skill Timers")
@export var skill_duration_timer : Timer
@export var skill_duration_wait_time : float :
	set(new_value):
		if skill_duration_timer:
			skill_duration_timer.wait_time = new_value
		#print("del seter", skill_duration_timer)
		skill_duration_wait_time = new_value
@export var skill_cooldown_timer : Timer
@export var skill_cooldown_wait_time : float :
	set(new_value):
		if skill_cooldown_timer:
			skill_cooldown_timer.wait_time = new_value
		skill_cooldown_wait_time = new_value
#)timers

var is_skill_active : bool = false
var is_skill_available : bool = true

#@export_group("Skill Callables")
#@export var skill_activated_callables: Array[Callable]
#@export var skill_finished_callables: Array[Callable]

func skill_ready():
	#print("del ready", skill_duration_timer)
	#if not is_active_hold :
	current_use_charges = max_use_charges
	if skill_duration_timer:
		skill_duration_timer.timeout.connect(_on_skill_duration_timer_timeout)
		skill_duration_timer.wait_time = skill_duration_wait_time
	if skill_cooldown_timer:
		skill_cooldown_timer.timeout.connect(_on_skill_cooldown_timer_timeout)
		skill_cooldown_timer.wait_time = skill_cooldown_wait_time
	skill_finished.connect(_on_skill_finished.bind(skill_instance))
	print(self.name, "_skill_finished.is_connected", " = ", skill_finished.is_connected(_on_skill_finished))
	if is_active_hold:
		skill_duration_timer.wait_time = 1
		#skill_duration_timer.wait_time = 0.5
		#cost_per_use = cost_per_use / 2
	
	#if skill_activated_callables.size() > 0:
		#for callable in skill_activated_callables:
			#skill_activated.connect(callable)
	#if skill_finished_callables.size() > 0:
		#for callable in skill_finished_callables:
			#skill_finished.connect(callable)
		

func activate_skill(delta:float = 1):

#	WARNING:is_active_hold not working
	if required_resource == null:
		#if is_active_hold:
			#skill_duration_timer.start(0)
		if is_skill_available:
			print(self, "activate_skill")
			current_use_charges -= 1
			is_skill_active = true
			skill_activated.emit(skill_instance)
			skill_duration_timer.start(0)
			#skill_cooldown_timer.start()
		#if current_use_charges <= 0 :
			#is_skill_available = false
		else:
			skill_not_available.emit(skill_instance)
	else:
		if is_skill_available and required_resource.curent_resource_amount >= cost_per_use:
			print(self, "activate_skill")
			current_use_charges -= 1
			is_skill_active = true
			skill_activated.emit(skill_instance)
			skill_duration_timer.start(0)
			#skill_cooldown_timer.start()
			#required_resource.curent_resource_amount -= cost_per_use
			required_resource.resource_amount_changed.emit(required_resource.curent_resource_amount, required_resource.curent_resource_amount - cost_per_use)
		#if current_use_charges <= 0 :
			#is_skill_available = false
		else:
			skill_not_available.emit(skill_instance)
	
	
func _on_skill_finished(instance: CharacterSkill):
	print("is ", skill_instance, " is equal to ", self," = ", skill_instance == self)
	if instance == skill_instance:
		is_skill_active = false


func _on_skill_duration_timer_timeout(instance: CharacterSkill):
	if instance == skill_instance:
		if is_cooldown_available:
			if current_use_charges < max_use_charges:
				skill_cooldown_timer.start()
		
		if not is_active_hold and is_skill_active:
			skill_finished.emit(skill_instance)
		elif is_active_hold and is_skill_active:
			if required_resource == null:
				activate_skill()
			elif required_resource.curent_resource_amount >= cost_per_use:
				activate_skill()
			elif required_resource.curent_resource_amount < cost_per_use:
				skill_finished.emit(skill_instance)
	

func _on_skill_cooldown_timer_timeout():
	if current_use_charges < max_use_charges :
		current_use_charges += 1
