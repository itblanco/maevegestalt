#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float u_time;

varying vec4 vertColor;
varying vec3 vertNormal;

void main() {
  vec3 n = normalize(vertNormal);
  float lighting = max(0.0, n.z);
  float pulse = 0.5 + 0.5 * sin(u_time);
  vec3 col = vertColor.rgb * lighting * pulse;
  gl_FragColor = vec4(col, vertColor.a);
}
