shader_type canvas_item;
render_mode unshaded;

void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	COLOR.rgb = vec3(1.0,0,0);
}
