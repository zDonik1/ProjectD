shader_type spatial;
render_mode unshaded, skip_vertex_transform, shadows_disabled, ambient_light_disabled;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

uniform float orthographic_size;
uniform vec2 resolution;
uniform vec2 zoom;
uniform vec2 offset;

void vertex()
{
	POSITION = vec4(VERTEX.xy * zoom + offset, 0.0, 1.0);
}

void fragment() 
{
	vec2 uv;
	uv.x = floor(UV.x * resolution.x) / resolution.x;
	uv.y = floor((1.0 - UV.y) * resolution.y) / resolution.y;
	vec3 color = texture(screen_texture, uv).rgb;
	
	ALBEDO = color;
}
