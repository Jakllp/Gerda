shader_type canvas_item;

void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	COLOR.rgb = vec3(1.0,0,0);
}
