boolean creationMode = false;
HE_MeshCollection meshColl_copy = null;

void creationModeControl() {
    if(creationMode_box) createMeshBox();
}


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
