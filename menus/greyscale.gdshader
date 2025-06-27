shader_type canvas_item;

void fragment() {
	COLOR.xyz = vec3((COLOR.x + COLOR.y + COLOR.z) / 3.);
}
