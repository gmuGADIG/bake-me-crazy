shader_type canvas_item;

uniform float north : hint_range(0., 1.) = 1.;
uniform float east : hint_range(0., 1.) = 1.;
uniform float south : hint_range(0., 1.) = 1.;
uniform float west : hint_range(0., 1.) = 1.;

void fragment() {
	if (
		UV.y < 1. - north ||
		UV.x > east ||
		UV.y > south ||
		UV.x < 1. - west
	) {
		COLOR = vec4(0.);
	}
}
