RadioButton changeProjRadio;
int previousRadioButton;
public void initGUI() {
  ControlFont roboto = new ControlFont(font10); 
  ControlFont.sharp();
  CColor guicol = new CColor(0xffEDB016, 0xff505050, selectCol, 0xffffffff, 0xffffffff);
  cp5 = new ControlP5(this, roboto).setColor(guicol);
  cp5.setAutoDraw(false);

  // ---------- PROJECTION group ----------
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
    .addItem("axo", 2)
    .setSpacingRow(3)
    .setGroup(proj)
    .activate(0);
  changeProjection(0); 

  // ---------- CREATION group ----------
  Group creation = cp5.addGroup("creation")
    .setPosition(120, 25)
    .setSize(150, 50)
    .setBackgroundColor(color(100, 50))
    .setBarHeight(15);
  cp5.addButton("createMeshBox")
    .setPosition(5, 5)
    .setSize(140, 16)
    .setLabel("box")
    .setGroup(creation);
  cp5.addButton("createPlatonic")
    .setPosition(5, 24)
    .setSize(140, 16)
    .setLabel("platonic solid")
    .setGroup(creation);

  creationSubTools();

  // ---------- OPERATIONS group ----------
  Group operations = cp5.addGroup("operations")
    .setPosition(280, 25)
    .setSize(150, 50)
    .setBackgroundColor(color(100, 50))
    .setBarHeight(15);
  cp5.addButton("sliceMesh")
    .setPosition(5, 5)
    .setSize(140, 16)
    .setGroup(operations)
    .setLabel("Random Slice");
  cp5.addButton("review")
    .setPosition(5, 24)
    .setSize(140, 16)
    .setGroup(operations);
}

void creationSubTools() {
  // ---------- BOX ----------
  Group box = cp5.addGroup("createBox")
    .setPosition(width-210, 25)
    .setSize(200, 157)
    .setBackgroundColor(color(100, 50))
    .setBarHeight(15)
    .disableCollapse()
    .setLabel("create box")
    .setVisible(false);

  cp5.addSlider("boxw")
    .setPosition(5, 5)
    .setSize(190, 20)
    .setRange(10, 1000)
    .setGroup(box)
    .getCaptionLabel()
    .setText("width")
    .align(ControlP5Constants.RIGHT, ControlP5Constants.CENTER);
  cp5.addSlider("boxh")
    .setPosition(5, 28)
    .setSize(190, 20)
    .setRange(10, 1000)
    .setGroup(box)
    .getCaptionLabel()
    .setText("height")
    .align(ControlP5Constants.RIGHT, ControlP5Constants.CENTER);
  cp5.addSlider("boxd")
    .setPosition(5, 51)
    .setSize(190, 20)
    .setRange(10, 1000)
    .setGroup(box)
    .getCaptionLabel()
    .setText("depth")
    .align(ControlP5Constants.RIGHT, ControlP5Constants.CENTER);

  cp5.addButton("finishMeshBox")
    .setPosition(5, 120)
    .setSize(93, 30)
    .setGroup(box)
    .setLabel("ok");
  cp5.addButton("cancelMeshBox")
    .setPosition(102, 120)
    .setSize(93, 30)
    .setGroup(box)
    .setLabel("cancel");

  // ---------- PLATONIC SOLID ----------  
  Group platonic = cp5.addGroup("createPlatonicSolid")
    .setPosition(width-210, 25)
    .setSize(200, 157)
    .setBackgroundColor(color(100, 50))
    .setBarHeight(15)
    .disableCollapse()
    .setLabel("create platonic solid")
    .setVisible(false);

  cp5.addDropdownList("platonicTypes").setValue(1.0)
    .setPosition(5,28)
    .setWidth(190)
    .setCaptionLabel("Type")
    .setBarHeight(20)
    .setItemHeight(20)
    .setOpen(true)
    .setGroup(platonic)
    .addItem("cube", 1)
    .addItem("dodecahedron", 2)
    .addItem("icosahedron", 3)
    .addItem("octahedron", 4)
    .addItem("tetrahedron", 5);
  cp5.addSlider("platonicSize")
    .setPosition(5, 5)
    .setSize(190, 20)
    .setRange(10, 1000)
    .setGroup(platonic)
    .getCaptionLabel()
    .setText("depth")
    .align(ControlP5Constants.RIGHT, ControlP5Constants.CENTER);

  cp5.addButton("finishPlatonic")
    .setPosition(5, 120)
    .setSize(93, 30)
    .setGroup(platonic)
    .setLabel("ok");
  cp5.addButton("cancelPlatonic")
    .setPosition(102, 120)
    .setSize(93, 30)
    .setGroup(platonic)
    .setLabel("cancel");
}

public void changeProjection(int a) {
  switch(a) {
  case -1:
    switch(previousRadioButton) {
    case 0:
      changeProjRadio.activate(1);
      perspective(PI/3.0f, float(width)/float(height), 1, 1000000);
      previousRadioButton = 1;
      break;
    case 1:
      changeProjRadio.activate(0);
      ortho(-width/2, width/2, -height/2, height/2, 1, 1000000);
      previousRadioButton = 0;
      break;
    }
    //if (previousRadioButton == 0) {
    //  changeProjRadio.activate(1);
    //  perspective(PI/3.0f, float(width)/float(height), 1, 1000000);
    //  previousRadioButton = 1;
    //} else if (previousRadioButton == 1) {
    //  changeProjRadio.activate(0);
    //  ortho(-width/2, width/2, -height/2, height/2, 1, 1000000);
    //  previousRadioButton = 0;
    //}
    break;
  case 0: 
    ortho(-width/2, width/2, -height/2, height/2, 1, 1000000);
    previousRadioButton = a;
    break;
  case 1:
    perspective(PI/3.0f, float(width)/float(height), 1, 1000000);
    previousRadioButton = a;
    break;
  }
}
