shader_type sky;

uniform float exposure : hint_range(0, 128) = 1.0;
uniform sampler2D tex_sky_day : filter_linear, source_color, hint_default_black;
uniform sampler2D tex_sky_night: filter_linear, source_color, hint_default_black;
uniform float weight;

void sky() {
	vec4 col_day = texture(tex_sky_day, SKY_COORDS);
	vec4 col_night = texture(tex_sky_night, SKY_COORDS);
	float blend_factor = weight;
	vec4 col_blend = mix(col_day,col_night,blend_factor);
	COLOR = col_blend.rgb * exposure;
}
