shader_type canvas_item;

uniform vec3 sun_color : source_color;
uniform vec3 bg_color : source_color;

uniform vec2 target_pos;
uniform int beams = 6;

void fragment() {
	vec2 v = UV / TEXTURE_PIXEL_SIZE;
	v -= target_pos;
	float phi = atan(v.x, v.y) + PI + TIME / 8.;
	
	float x = 1.;
	x *= smoothstep(75., 78., distance(v, vec2(0.)));
	x *= step(PI / float(beams), mod(phi, PI / float(beams / 2)));
	x = 1. - x;
	x *= smoothstep(distance(v, vec2(0.)), 600., 500.);
	x *= step(distance(v, vec2(0.)), 600);
	
	COLOR.xyz = mix(sun_color, bg_color, 1. - x);
}
