shader_type canvas_item;

// Allows you to control the output color in the Shader Params in the Inspector.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	// We sample the screen texture at this point, which has the Mask node's pixels
	// rendered on it.
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	// Basically get's the ViewportTexture
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color;

	// If the pixel's value is lower than the Mask's output color, it means the
	// mask is being occluded, so we draw the silhouette instead.
	if (screen_color.rgb != vec3(1.0, 0, 0) && tex_color.a > 0.5){
		COLOR.rgba = vec4(0.53,0.53,0.53,0.75).rgba;
		
		// We convert the pixel width we want for our outline in decimal texel size.
		vec2 size = vec2(1.0) / vec2(textureSize(TEXTURE, 0));
		
		// We sample and offset the texture 8 times to draw an outline.
		float alpha = tex_color.a;
		alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		
		// If the summed alpha is too high, it means we're over the original texture
		// and we don't want to draw this pixel; it's not part of the outline.
		if (alpha >= 9.0) {
			alpha = 0.0;
		}
		
		// We then override the texture's color with the calculated outline.
		COLOR = vec4(vec4(0.53,0.53,0.53,0.75).rgb, min(alpha, 1.0) * tex_color.a);
	}
}