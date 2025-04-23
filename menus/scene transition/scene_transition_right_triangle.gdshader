shader_type canvas_item;

// Draws a triangle. We simply anchor this to the right of the main_pink to
// add a triangle to it.

void fragment() {
	float t = 2.0 * (0.5 - abs(UV.y - 0.5));
	if(UV.x > t) discard;
}
