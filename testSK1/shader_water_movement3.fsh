void main(void)
{
    vec2 uv = gl_FragCoord.xy / size.xy;
    
    vec2 st = gl_FragCoord.xy/u_sprite_size;
    float pct = 0.0;
    
    float y = smoothstep(0.1,0.9,st.y);
    float yz = smoothstep(0.9,0.1,st.x);
    
    vec3 color = vec3(pct);
    
    uv.y += (cos((uv.y + (u_time * 0.08)) * 85.0) * 0.0019) +
    (atan((uv.y + (u_time * 0.1)) * 10.0) * yz);
    
    uv.x += (sin((uv.y + (u_time * 0.13)) * cos(yz)) * 0.033) +
    (sin((uv.y + (u_time * 0.1)) * 15.0) * tan(y));
    
    
    //0.0029
    
    
    vec4 texColor = texture2D(customTexture,uv)*1.0;
    gl_FragColor = texColor;
}
