import wblut.core.*; 
import wblut.geom.*; 
import wblut.hemesh.*; 
import wblut.math.*; 
import wblut.nurbs.*; 
import wblut.processing.*; 
import peasy.*; 
import java.util.*; 
import controlP5.*; 
import com.jogamp.newt.event.KeyEvent; 

WB_Render render;
HE_MeshCollection meshColl;
HE_MeshCollection selectedColl;
HE_Mesh tempSelectMesh = null;
HE_Mesh selectedMesh = null;
PeasyCam cam;

float meshSize = 800;
float splitProbability;
boolean drawBorder = true;

color selectCol = 0xffFF0353;
color selectedCol = 0xff92CE4F;
color creationCol = #456F76;

ControlP5 cp5;
PFont font10;

public void setup() {
  //fullScreen(P3D);
  size(1300, 700, P3D);
  font10 = createFont("Roboto-Light.ttf", 10);
  cam = new PeasyCam(this, meshSize);
  cam.rotateY(PI/4);
  cam.rotateX(PI/4);
  cam.setResetOnDoubleClick(false);

  render = new WB_Render(this);

  selectedColl = new HE_MeshCollection();

  HEC_Creator creator = new HEC_Box().setSize(meshSize, meshSize*0.2f, meshSize*0.5f);  
  HE_Mesh mesh = new HE_Mesh(creator);

  meshColl = new HE_MeshCollection();
  meshColl.add(mesh);

  splitProbability = random(0.1f, 0.9f);
  thread("selectMesh");

  initGUI();
}

WB_Ray ray = null;
public void draw() {  
  if (cp5.isMouseOver()) cam.setActive(false); 
  else                  cam.setActive(true);
  
  creationModeControl();
  selectedMesh = tempSelectMesh;
  ray = render.getPickingRay(mouseX, mouseY);
  background(30);
  //cam.beginHUD();
  //push();
  //noStroke();
  //fill(selectedCol);

  //circle(width/2, height/2, 500);
  //pop();
  //cam.endHUD();
  if (drawBorder) {
    push();
    scale(1.05);
    fill(255);
    noStroke();   
    render.drawFaces(meshColl); 
    PImage i = copy();
    pop();

    background(30); 
    cam.beginHUD();
    image(i, 0, 0);
    cam.endHUD();
  }
  noStroke();   
  scale(1);
  if(creationMode) fill(creationCol);
  else fill(30);

  render.drawFaces(meshColl);

  noFill();
  stroke(255);
  render.drawEdges(meshColl);

  if (!creationMode) {
    noStroke();
    fill(selectedCol);
    render.drawFaces(selectedColl);
    fill(selectCol);
    if (selectedMesh != null) {
      render.drawFaces(selectedMesh);
    }
  }
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  
  String title = "fps: " + frameRate;
  surface.setTitle(title);
}
