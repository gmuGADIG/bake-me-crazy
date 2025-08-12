shader_type canvas_item;

uniform float radius : hint_range(0., .13);

void fragment() {
	COLOR.a *= step(distance(UV, vec2(.5)), radius);
}
