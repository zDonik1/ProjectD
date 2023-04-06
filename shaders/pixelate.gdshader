shader_type spatial;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

uniform float horizontal_resolution = 160;

void vertex()
{
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() 
{
	float vertical_resolution = VIEWPORT_SIZE.y * horizontal_resolution / VIEWPORT_SIZE.x;
	vec2 uv;
	uv.x = floor(SCREEN_UV.x * horizontal_resolution) / horizontal_resolution;
	uv.y = floor(SCREEN_UV.y * vertical_resolution) / vertical_resolution;
	vec3 color = texture(screen_texture, uv).rgb;
	EMISSION = color;
	ALBEDO = EMISSION;
}
