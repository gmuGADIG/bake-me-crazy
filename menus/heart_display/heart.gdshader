shader_type canvas_item;

uniform float fill : hint_range(0, 1);

void fragment() {
	if (UV.y < (1.0 - fill)) discard;
}
