precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;
#define PI 3.14159265359

float plot(float coordAvarage, float pct){
  return  step( pct - 0.003, coordAvarage) -
          step( pct + 0.003, coordAvarage);
}

float circle(vec2 st, float x, float y, float radius) {
    float vx = st.x - x;
    float vy = st.y - y;
    return -(smoothstep(
        radius - 0.01,
        radius, sqrt(vx*vx+vy*vy)
    ) - 1.0);
}

void main() {
    float ratio = u_resolution.x / u_resolution.y;
    vec2 st = vec2(
      (gl_FragCoord.x / u_resolution.x) * ratio,
      gl_FragCoord.y / u_resolution.y
    );
    vec2 center = vec2(0.5 * ratio, 0.5);
    float orbitRadius = 0.2;
    float planetSize = 0.02;
    float orbitRadius2 = 0.4;
    float planetSize2 = 0.03;
    float angle = u_time * 0.1 * PI * 2.0;
    float c = circle(st, center.x, center.y, 0.1)
        + circle(
        	st,
        	sin(angle) * orbitRadius + center.x,
        	cos(angle) * orbitRadius + center.y, planetSize
    	)
        + circle(
        	st,
        	sin(angle) * orbitRadius2 + center.x,
        	cos(angle) * orbitRadius2 + center.y, planetSize2
    	);
    c = clamp(c, 0.0, 1.0);

    vec3 color = vec3(c);

    float pct = plot((st.x + st.y) * 0.5, c);
    color *= 1.0 - pct;
    color += pct * vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}