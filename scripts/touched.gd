extends Node3D

var open := false

func interact():
	open = !open

	var target_rot = deg_to_rad(90 if open else 0)
	rotation.z = target_rot

	print("Touched rotated:", rotation.y)
