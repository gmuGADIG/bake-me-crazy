shader_type canvas_item;
render_mode unshaded;

void fragment() {
	if (SCREEN_UV.y > .9) {
		COLOR.a *= 0.;
	}
	//COLOR.a *= (SCREEN_UV.y > .9) : 1. ? 0.;
}