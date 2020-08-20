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
WB_SelectRender3D selectRender;
HE_MeshCollection meshColl;
HE_MeshCollection selectedColl;
HE_Mesh tempSelectMesh = null;
HE_Mesh selectedMesh = null;
PeasyCam cam;

float meshSize = 800;
float splitProbability;
boolean drawBorder = true;

int selectCol = 0xffFF0353;
int selectedCol = 0xff92CE4F;

ControlP5 cp5;

public void setup() {
  fullScreen(P3D);
  //size(1300, 700, P3D);
  cam = new PeasyCam(this, meshSize);
  render = new WB_Render(this);
  selectedColl = new HE_MeshCollection();
  selectRender = new WB_SelectRender3D(this);
  //ortho(-width/2, width/2, -height/2, height/2, 1, 1000000);
  HEC_Creator creator = new HEC_Box().setSize(meshSize, meshSize*0.2f, meshSize*0.5f);
  //HEC_Creator creator = new HEC_Sphere().setRadius(meshSize*0.8).setUFacets(5).setVFacets(5);
  HE_Mesh mesh = new HE_Mesh(creator);

  meshColl = new HE_MeshCollection();
  meshColl.add(mesh);

  splitProbability = random(0.1f, 0.9f);
  thread("selectMesh");

  initGUI();
}

WB_Ray ray = null;
public void draw() {  
  selectedMesh = tempSelectMesh;
  ray = render.getPickingRay(mouseX, mouseY);
  background(30);
  if (drawBorder) {
    push();
    scale(1.1f);
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
  fill(30);

  render.drawFaces(meshColl);

  noFill();
  stroke(255);
  render.drawEdges(meshColl);

  noStroke();
  fill(selectedCol);
  render.drawFaces(selectedColl);
  fill(selectCol);
  if (selectedMesh != null) {
    render.drawFaces(selectedMesh);
  }

  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
}

public void keyPressed() {
  if (key == 's') {
    splitMesh();
  }
  if (key == 'r') {
    reorganizeMesh();
  }
  if (key == 'b') {
    drawBorder = !drawBorder;
  }
  if (keyCode == KeyEvent.VK_DELETE && selectedColl.size() > 0) {
    HE_MeshIterator mi = selectedColl.mItr();
    while (mi.hasNext()) {
      HE_Mesh mesh = mi.next();
      meshColl.remove(mesh);
    }
    selectedColl = new HE_MeshCollection();
  }
  if (keyCode == KeyEvent.VK_SPACE) {
    selectedColl = new HE_MeshCollection();
  }
}


public void mousePressed() {    
  switch(mouseButton) {
    case(LEFT):
    if (selectedMesh != null) { 
      if ((selectedColl.size() > 0 && keyCode == SHIFT) || selectedColl.size() == 0) selectedColl.add(selectedMesh);
      else if (selectedColl.size() == 1) {
        HE_Mesh mesh = selectedColl.getMesh(0);
        if (mesh == selectedMesh) selectedColl.remove(selectedMesh);
        else {
          selectedColl = new HE_MeshCollection();
          selectedColl.add(selectedMesh);
        }
      } else if (keyCode == ALT && selectedColl.size() > 1) selectedColl.remove(selectedMesh);
    }
    break;
    case(RIGHT):

    break;
  }
}

RadioButton changeProjRadio;
int previousRadioButton;
public void initGUI() {
  ControlFont roboto = new ControlFont(createFont("Roboto-Light.ttf", 10)); 
  ControlFont.sharp();
  CColor guicol = new CColor(0xffEDB016, 0xff505050, selectCol, 0xffffffff, 0xffffffff);
  cp5 = new ControlP5(this, roboto).setColor(guicol);

  Group proj = cp5.addGroup("proj")
    .setPosition(10, 25)
    .setSize(100, 35)
    .setLabel("projection")
    .setBackgroundColor(color(100, 50))
    .setBarHeight(15);
  changeProjRadio = cp5.addRadioButton("changeProjection")
    .setPosition(5, 5)
    .setSize(20, 9)
    .addItem("orthogonal", 0)
    .addItem("perspective", 1)
    .setSpacingRow(3)
    .setGroup(proj);

  Group operations = cp5.addGroup("operations")
    .setPosition(120, 25)
    .setSize(150, 35)
    //.setLabel("projection")
    .setBackgroundColor(color(100, 50))
    .setBarHeight(15);
  cp5.addButton("splitMesh")
    .setPosition(5, 5)
    .setSize(140, 16)
    .setGroup(operations);
  cp5.addButton("review")
    .setPosition(5, 25)
    .setSize(140, 16)
    .setGroup(operations);



  cp5.setAutoDraw(false);
}

public void changeProjection(int a) {
  switch(a) {
  case -1:
    if (previousRadioButton == 0) {
      changeProjRadio.activate(1);
      perspective(PI/3.0f, PApplet.parseFloat(width)/PApplet.parseFloat(height), 1, 1000000);
      previousRadioButton = 1;
    } else if (previousRadioButton == 1) {
      changeProjRadio.activate(0);
      ortho(-width/2, width/2, -height/2, height/2, 1, 1000000);
      previousRadioButton = 0;
    }
    break;
  case 0: 
    ortho(-width/2, width/2, -height/2, height/2, 1, 1000000);
    previousRadioButton = a;
    break;
  case 1:
    perspective(PI/3.0f, PApplet.parseFloat(width)/PApplet.parseFloat(height), 1, 1000000);
    previousRadioButton = a;
    break;
  }

  println(a);
}

float rotateR = 0.6f;
public void splitMesh() {
  List<HE_Mesh> meshes;
  if (selectedColl.size() > 0) {
    meshes = selectedColl.toList();
  } else {
    meshes = meshColl.toList();
  }

  List<HE_Mesh> newMeshes = new ArrayList<HE_Mesh>();

  for (HE_Mesh mesh : meshes) {
    float probability = random(1);
    if (probability < splitProbability || selectedColl.size() > 0) {
      PVector rv = PVector.random3D();
      PVector p = PVector.random3D();
      WB_Point pos = new WB_Point(p.x, p.y, p.z);
      pos.mulSelf(random(-meshSize*0.2f, meshSize*0.2f));
      pos.addSelf(mesh.getCenter());
      WB_Plane plane = new WB_Plane(pos, new WB_Point(rv.x, rv.y, rv.z)); 
      HEMC_SplitMesh sm = new HEMC_SplitMesh().setCap(true).setMesh(mesh).setPlane(plane);
      HE_MeshCollection mc = new HE_MeshCollection(sm);
      Iterator iterator = mc.iterator();

      while (iterator.hasNext()) {
        HE_Mesh m = (HE_Mesh)iterator.next();
        WB_Coord point = plane.getOrigin();
        WB_Coord dir = plane.getNormal();
        m.rotateAboutAxisSelf(random(-rotateR, rotateR), point, dir);
        m.scaleSelf(random(0.85f, 1.05f));
      }
      rotateR *= 0.5f;
      newMeshes.addAll(mc.toList());
    } else {
      newMeshes.add(mesh);
    }

    splitProbability = random(0.1f, 0.9f);
  }

  if (selectedColl.size() > 0) {
    for (HE_Mesh mesh : meshes) {
      meshColl.remove(mesh);
    }
  } else {
    meshColl = new HE_MeshCollection();
  }
  meshColl.addAll(newMeshes);
  selectedColl = new HE_MeshCollection();
}

public void reorganizeMesh() {
  Map<Float, HE_Mesh> dict = new HashMap<Float, HE_Mesh>();
  HE_MeshIterator mi = meshColl.mItr();
  while (mi.hasNext()) {
    HE_Mesh mesh = mi.next();
    float volume = (float)HE_MeshOp.getVolume(mesh);
    dict.put(volume, mesh);
  }

  SortedSet<Float> sortedVolumes = new TreeSet<Float>(dict.keySet());

  int s = floor(sqrt(meshColl.size()))/6;
  int i = 0;
  for (float k : sortedVolumes) {
    HE_Mesh mesh = dict.get(k);
    WB_Point p = new WB_Point(i%s*(meshSize/5), i/s*(meshSize/5));
    mesh.moveToSelf(p);
    i++;
  }
}


public void selectMesh() {
  while (true) {    
    HE_Mesh outMesh = null;
    HE_MeshIterator mi = meshColl.mItr();
    float closestDistance = -1;
    while (mi.hasNext() && ray != null) {
      HE_Mesh mesh = mi.next();
      HET_MeshOp.HE_FaceLineIntersection fi = HET_MeshOp.getClosestIntersection(mesh, ray);
      if (fi != null) {
        WB_Coord point = fi.getPoint();
        float distance = (float)WB_Point.getDistance(point, ray.getOrigin());
        if (distance < closestDistance || closestDistance < 0) {
          closestDistance = distance;
          outMesh = mesh;
        }
      } else continue;
    }
    tempSelectMesh = outMesh;
    delay(50);
  }
}
