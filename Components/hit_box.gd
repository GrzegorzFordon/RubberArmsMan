class_name HitBox
extends Area3D

signal hurt_box_hit(hurt_box:HurtBox)

var ignore_list : Array[HurtBox]

func _on_area_entered(area: Area3D) -> void:
	if area is not HurtBox: return
	area = area as HurtBox
	if area.owner == owner: return
	var hit_data = HitData.new()
	hit_data.power = 20
	hit_data.origin = global_position
	area.on_hit(hit_data)
	hurt_box_hit.emit(area)
