shader_type canvas_item;

void fragment() {
	float y = mod(UV.y + TIME * .8, 1.);
	float dist = distance(y, .01);
	dist *= 2.;
	dist = 1. - dist;
	dist *= dist * dist;

	COLOR.xyz += vec3(dist);
	// Called for every pixel the material is visible on.
}
