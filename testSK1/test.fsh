

void main(void) {
 
  vec2 uv = v_tex_coord;
    //vec2 u_resolution = 0.0;
    
    vec2 pos = floor(1.0 / uv.xy);
    float co = fract(sin(dot(uv.xy ,vec2(12.9898,78.233))) * 43758.5453);
    vec2 st = gl_FragCoord.xy/u_sprite_size;
    
    
    float y = smoothstep(0.1,0.9,st.x);
    
    vec3 color = vec3(y);
 
 
  uv.y += (cos((uv.y + (u_time * 0.04)) * 45.0) * 0.0019*co) +
          (cos((uv.y + (u_time * 0.1)) * 10.0) * 0.002);
 
  uv.x += (sin((uv.y + (u_time * 0.07)) * 15.0) * 0.029*pos.y) +
          (tan((uv.y + (u_time * 0.1)) * 15.0) * 0.02);
 
  //gl_FragColor = texture2D(u_texture, uv*color.x);
     gl_FragColor = vec4(color.x*uv.y,color.y*uv.x,co,1.0);
}
