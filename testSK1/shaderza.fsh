float map(vec3 p){
    
    float z = sin(u_time);
    if(z>1.0||z<0.0){
        
        z = 0.1;
        
    }
    
    vec3 q = fract(p) * 2.0 - 1.0;
    
    return length(q) - (0.12*z);
    
    
    
}

float trace(vec3 o, vec3 r){
    
    float t = 0.0;
    for(int i=0; i<16;++i){
        vec3 p = o + r * t;
        
        float d = map(p);
        
        t+= d*0.5;
        
    }
    
    return t;
    
    
}


void main(void)
{
    vec2 uv = gl_FragCoord.xy / size.xy;
    
    vec2 st = gl_FragCoord.xy/u_sprite_size;
    float pct = 0.0;
    
    float y = smoothstep(0.1,0.9,st.y);
    
    //vec3 color = vec3(pct);
    
    vec3 r = normalize(vec3 (uv, 1.0));
    
    vec3 o = vec3(0.0,u_time*0.05,-3.0);
    
    float t = trace(o,r);
    
    float z = sin(u_time);
    if(z>1.0||z<0.0){
        
        z = 0.0;
        
    }
    
    float fog = 1.0 / (1.0 +t *t *0.1);
    float fog3 = 1.0 / (1.0 +t *t *0.01);
    float fog2 = 1.0 / (1.0 * t *0.01);
    vec3 fc = vec3(fog,fog3,fog2);
    
    
    

    gl_FragColor = vec4(fc.x*z,fc.y,fc.z *z,1.0);
}
