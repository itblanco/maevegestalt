RadioButton changeProjRadio;
int previousRadioButton;
public void initGUI() {
  ControlFont roboto = new ControlFont(createFont("Roboto-Light.ttf", 10)); 
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
  
  // ---------- PROJECTION group ----------
  
  
  // ---------- OPERATIONS group ----------
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
    .setPosition(5, 24)
    .setSize(140, 16)
    .setGroup(operations);



  
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
