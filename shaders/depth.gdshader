shader_type spatial;
render_mode unshaded;

uniform sampler2D depth_texture: source_color, hint_depth_texture;

void vertex()
{
	POSITION = vec4(VERTEX, 1.0);
}

void fragment()
{
//	ALBEDO = texture(depth_texture, SCREEN_UV).rrr;
	ALBEDO = vec3(fract(texture(depth_texture, SCREEN_UV).r * 10000.0));
}