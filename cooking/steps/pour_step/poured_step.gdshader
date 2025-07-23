shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	uv.x -= TIME;
	
	// Ensure uv Y doesn't wrap around
	// Hack: The top of the texture has a little bit of transparency, so we
	// can use 0.02 uv y to do this
	uv.y = clamp(uv.y, 0.02, 1.0);
	
	COLOR = texture(TEXTURE, uv);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
