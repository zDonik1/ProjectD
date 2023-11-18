shader_type spatial;
render_mode unshaded;

uniform sampler2D outline_depth_texture: source_color;
uniform sampler2D screen_texture: source_color, hint_screen_texture;
uniform sampler2D normal_texture: hint_normal_roughness_texture;
uniform sampler2D depth_texture: hint_depth_texture;

bool is_approx_equal(float a, float b)
{
	return abs(a - b) < 0.0001;
}

void vertex()
{
	POSITION = vec4(VERTEX, 1.0);
}

void fragment()
{
//	ALBEDO = vec3(fract(texture(outline_depth_texture, SCREEN_UV).r * 10000.0));
	ALBEDO = texture(outline_depth_texture, SCREEN_UV).rgb;
//	if (is_approx_equal(texture(outline_depth_texture, SCREEN_UV).r, texture(depth_texture, SCREEN_UV).r)) {
//		ALBEDO = vec3(1, 0, 0);
//	}
//	else {
//		ALBEDO = texture(screen_texture, SCREEN_UV).rgb;
//	}
}