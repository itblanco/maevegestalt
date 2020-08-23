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

public void mouseClicked(MouseEvent e) {    
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

MouseEvent mouseEvent = null;
public void mouseMoved(MouseEvent e) {
  mouseEvent = e;  
}

public void mouseExited() {
  pause();
}

public void mouseEntered() {
  resume();
}

public void mouseWheel(MouseEvent e) {
  
}

public void focusLost() {
 pause(); 
}

public void focusGained() {
  resume();
}
