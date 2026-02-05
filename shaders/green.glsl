vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(tex, texture_coords);
    
    // Calculate average of RGB channels
    float grey = (pixel.r + pixel.g + pixel.b) / 3.0;
    
    return vec4(grey, grey, grey, pixel.a) * color;
}
