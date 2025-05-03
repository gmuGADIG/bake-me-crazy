shader_type canvas_item;

const float tick_count = 10.;
const float tick = 1. / tick_count;

void fragment() {
	// Called for every pixel the material is visible on.
	
	float dist = distance(UV, vec2(.5));
	float angle = atan(UV.y - .5, UV.x - .5) + PI;
	
	COLOR.rgb = vec3(1.);
	COLOR.a = smoothstep(0.43, 0.45, dist);
	COLOR.a *= smoothstep(dist - .02, dist, .49);
	
	COLOR.a *= step(mod(angle / TAU, tick), tick / 2.);
}
