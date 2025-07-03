shader_type canvas_item;

uniform float show_theta;
uniform float theta_offset;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float theta = atan(uv.y / uv.x);
	if(uv.x < 0.0) { theta += PI; }
	theta = mod(theta + theta_offset, TAU);
	if(theta > show_theta) {
		discard;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
