#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform mat4 transform;
attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 vertNormal;

void main() {
  vertColor = color;
  vertNormal = normal;
  gl_Position = transform * position;
}
