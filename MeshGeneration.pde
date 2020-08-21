void createMeshCube() {
  HEC_Creator creator = new HEC_Box().setSize(meshSize, meshSize*0.2f, meshSize*0.5f);
  HE_Mesh mesh = new HE_Mesh(creator);
  meshColl = new HE_MeshCollection();
  meshColl.add(mesh);
}
