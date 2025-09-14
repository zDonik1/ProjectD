shader_type spatial;
render_mode unshaded;

uniform sampler2D depth_texture: source_color, hint_depth_texture;

void vertex()
{
	POSITION = vec4(VERTEX, 1.0);
}

void fragment()
{
	float depth = texture(depth_texture, SCREEN_UV).r;
	ALPHA = 1.0 - floor(depth); // handling depth of 1.0 (farthest distance)
	if (ALPHA != 0.0) {
		float discrete_depth = floor(depth * pow(256.0, 3.0)); // out of 256^3
	
		float intermediary = discrete_depth / 256.0;
		float chann1 = fract(intermediary);
		intermediary = floor(intermediary) / 256.0;
		float chann2 = fract(intermediary);
		float chann3 = floor(intermediary) / 256.0;

//	ALBEDO = texture(depth_texture, SCREEN_UV).rrr;
		ALBEDO = vec3(chann1, chann2, chann3);
	}
}