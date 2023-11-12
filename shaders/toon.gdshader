shader_type spatial;
//render_mode ambient_light_disabled;

#include "toon.gdshaderinc"

void fragment() {
	ALBEDO = toon_fragment_albedo(UV);
}

void light() {
	DIFFUSE_LIGHT = toon_light_diffuse(NORMAL, LIGHT, LIGHT_COLOR, ATTENUATION,
		ALBEDO, DIFFUSE_LIGHT);
		
	SPECULAR_LIGHT = toon_light_specular(NORMAL, UV, VIEW, LIGHT, LIGHT_COLOR,
		ATTENUATION, SPECULAR_LIGHT);
}