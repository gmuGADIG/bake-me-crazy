shader_type canvas_item;

// Draws a tailing traingle thing.

void fragment() {
	float t = 2.0 * (abs(UV.y - 0.5));
	if((1.0 - UV.x) > t) discard;
}
