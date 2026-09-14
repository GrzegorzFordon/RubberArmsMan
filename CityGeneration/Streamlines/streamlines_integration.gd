class_name StreamlineIntegration
extends Node

var seed : Vector2
var original_dir : Vector2
var streamline : Array[Vector2]
var prev_direction : Vector2
var prev_point : Vector2
var is_valid : bool

static func with_data(_seed,_original_dir,_streamline,_prev_direction,_prev_point,_is_valid):
	var new_streamline_integration = StreamlineIntegration.new()
	new_streamline_integration.seed = _seed
	new_streamline_integration.original_dir = _original_dir
	new_streamline_integration.streamline = _streamline
	new_streamline_integration.prev_direction = _prev_direction
	new_streamline_integration.prev_point = _prev_point
	new_streamline_integration.is_valid = _is_valid
	return new_streamline_integration
