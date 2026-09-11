@tool
extends VisualShaderNodeCustom
class_name VSNode_WorldPosition3D


func _get_name() -> String:
	return "WorldPosition"


func _get_category() -> String:
	return "Data"


func _get_description() -> String:
	return "Returns the world position of the vertex in 3D space."


func _get_return_icon_type() -> PortType:
	return PORT_TYPE_VECTOR_3D


func _get_input_port_count() -> int:
	return 0


func _get_input_port_name(port: int) -> String:
	return ""


# func _get_input_port_type(port: int) -> PortType:
# 	return PORT_TYPE_SCALAR


func _get_output_port_count() -> int:
	return 1

func _get_output_port_name(port: int) -> String:
	return "WorldPosition"


func _get_output_port_type(port: int) -> PortType:
	return PORT_TYPE_VECTOR_3D


func _get_code(input_vars: Array[String], output_vars: Array[String],
		mode: Shader.Mode, type: VisualShader.Type) -> String:
	## INV_VIEW_MATRIX and VERTEX do not exist in the shader until fragment()
	## is called, so we need to pass them as input variables. The function
	## in get_global_code() is declared as a global function so we can't directly
	## use INV_VIEW_MATRIX and VERTEX or it will throw a compile error.
	return output_vars[0] + " = wpos(INV_VIEW_MATRIX, VERTEX);"


func _get_global_code(mode):
	return"""
	vec3 wpos(mat4 inv_view_matrix, vec3 vert){
		vec3 world_pos = (inv_view_matrix * vec4(vert, 1.0)).xyz;
		return world_pos;
	}
	"""
