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
