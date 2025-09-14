shader_type spatial;
render_mode unshaded;

uniform sampler2D outline_depth_texture: source_color;
uniform sampler2D screen_texture: source_color, hint_screen_texture;
uniform sampler2D normal_texture: hint_normal_roughness_texture;
uniform sampler2D depth_texture: hint_depth_texture;

bool is_approx_equal(float a, float b)
{
	return abs(a - b) < 0.00013;
}

void vertex()
{
	POSITION = vec4(VERTEX, 1.0);
}

void fragment()
{
//	ALBEDO = texture(outline_depth_texture, SCREEN_UV).rgb;
	
	vec4 encoded_depth = texture(outline_depth_texture, SCREEN_UV);
	float discrete_depth = encoded_depth.r * 256.0 + encoded_depth.g * pow(256.0, 2.0) + encoded_depth.b * pow(256.0, 3.0);
	float depth = discrete_depth / pow(256.0, 3.0);
	ALBEDO = texture(screen_texture, SCREEN_UV).rgb;
	if (is_approx_equal(depth, texture(depth_texture, SCREEN_UV).r)) {
		ALBEDO = mix(ALBEDO, vec3(1, 0, 0), 0.2);
	}
}