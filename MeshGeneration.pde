boolean creationMode = false;
HE_MeshCollection meshColl_copy = null;

void creationModeControl() {
    if(creationMode_box) createMeshBox();
    if(creationMode_platonic) createPlatonic();
    
}

// ---------- CREATE BOX ----------
boolean creationMode_box = false;
float boxw = 100, boxh = 100, boxd = 100;
void createMeshBox() {
  if(!creationMode) {
    creationMode = true;
    creationMode_box = true;
    cp5.getGroup("createBox").show();
    meshColl_copy = meshColl;
  } 
  HEC_Creator creator = new HEC_Box().setSize(boxw, boxh, boxd);
  HE_Mesh mesh = new HE_Mesh(creator);
  meshColl = new HE_MeshCollection();
  meshColl.add(mesh); 
}

void finishMeshBox() {
  creationMode = false;
  creationMode_box = false;
  cp5.getGroup("createBox").hide();
  meshColl_copy = null;
}

void cancelMeshBox() {
  if(meshColl_copy != null) {
   meshColl = meshColl_copy;    
  }
  creationMode = false;
  creationMode_box = false;
  cp5.getGroup("createBox").hide();
  meshColl_copy = null;
}

// ---------- CREATE PLATONIC ----------

boolean creationMode_platonic = false;
float platonicSize = 100;
void createPlatonic() {
  if(!creationMode) {
    creationMode = true;
    creationMode_platonic = true;
    cp5.getGroup("createPlatonicSolid").show();
    meshColl_copy = meshColl;
  }
  HEC_Creator creator = new HEC_Plato((int)cp5.getController("platonicTypes").getValue()+1, platonicSize);
  HE_Mesh mesh = new HE_Mesh(creator);
  meshColl = new HE_MeshCollection();
  meshColl.add(mesh); 
}

void finishPlatonic() {
  creationMode = false;
  creationMode_platonic = false;
  cp5.getGroup("createPlatonicSolid").hide();
  meshColl_copy = null;
}

void cancelPlatonic() {
  if(meshColl_copy != null) {
   meshColl = meshColl_copy;    
  }
  creationMode = false;
  creationMode_platonic = false;
  cp5.getGroup("createPlatonicSolid").hide();
  meshColl_copy = null;
}
