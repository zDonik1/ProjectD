<<<<<<< Updated upstream
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
=======
shader_type spatial;
render_mode unshaded;

uniform sampler2D depth_texture: source_color, hint_depth_texture;

float encode_8bits_to_float(int n)
{
	return float(n & 0x000000FF) / 256.0;
}

void vertex()
{
	POSITION = vec4(VERTEX, 1.0);
}

void fragment()
{
	float depth = texture(depth_texture, SCREEN_UV).r;
	if (floor(depth) == 1.0) {
		depth = 1.0 / 0.0; // mark as infinity
	}
	int new_depth = floatBitsToInt(depth);
	ALBEDO.r = encode_8bits_to_float(new_depth);
	ALBEDO.g = encode_8bits_to_float(new_depth >> 8);
	ALBEDO.b = encode_8bits_to_float(new_depth >> 16);
	ALPHA = encode_8bits_to_float(new_depth >> 24);
>>>>>>> Stashed changes
}