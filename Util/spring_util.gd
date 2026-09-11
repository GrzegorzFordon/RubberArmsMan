class_name SpringUtil

static func hookes_law(displacement:Vector3,current_velocity:Vector3,stiffness:float,damping:float):
	return (stiffness * displacement)-(damping*current_velocity)
