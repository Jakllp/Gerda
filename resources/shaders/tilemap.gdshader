shader_type canvas_item;

void fragment() { 
    float distance_cut_off = 200.0; //px 
    vec2 at = screen_uv_to_sdf(SCREEN_UV);
	vec4 orig_color = texture(TEXTURE, UV);
	float ledrop = texture_sdf(at)/distance_cut_off;
	
	float lemod = 0.05;
	
	if (ledrop < 0.001) {
		if(ledrop > -0.2)
    		COLOR.rgb = orig_color.rgb + vec3(ledrop) - vec3(lemod);
		else
    		COLOR.rgb = orig_color.rgb + vec3(-0.2) - vec3(lemod);
	}
}

/*
void light() {
	float cNdotL = max(0.0, dot(NORMAL, LIGHT_DIRECTION));
  	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}
*/