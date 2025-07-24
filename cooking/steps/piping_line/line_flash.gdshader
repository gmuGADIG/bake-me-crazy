shader_type canvas_item;

void fragment() {
	COLOR.a *= clamp(1.5+1.5*sin(2.0*TIME-UV.x),0.0,0.5);
}