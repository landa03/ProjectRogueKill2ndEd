@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Weapon", "StaticBody3D", preload("res://Components/Weapon/base_weapon.gd"), preload("res://Assets/Img/Icons/Nodes Icons/Icon_Weapon.svg") )
	add_custom_type("RangedWeapon", "Weapon", preload("res://Components/Weapon/ranged_weapon.gd"), preload("res://Assets/Img/Icons/Nodes Icons/Icon_Ranged_Weapon.svg") )

func _exit_tree():
	remove_custom_type("Weapon")
	remove_custom_type("RangedWeapon")
