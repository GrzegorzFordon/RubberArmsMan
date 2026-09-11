shader_type spatial;
render_mode unshaded,cull_disabled;
uniform sampler2D texture_viewport:source_color;

void fragment() {
	vec2 base_uv = SCREEN_UV;
	ALBEDO = texture(texture_viewport, base_uv).rgb;
}
