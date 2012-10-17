class WorldMap3D {
  private PImage tex;
  private PShape wmap, wmap2;
  private int mapBitmapSizeX;
  private MercatorMap mercMap; 
  
  
  WorldMap3D(int mapSizeX, int mapSizeY, int mapBitmapSizeX) {
    this.mapBitmapSizeX = mapBitmapSizeX;

    String fileExt = "png";
    String mapType = "world-navy";
    String pathPfx = "map-" + mapType + "/" + mapType + "-";
    switch (mapBitmapSizeX) {
      case 2000:
      case 6000:
      case 6400:
      case 8000:
        break;
      default:
        this.mapBitmapSizeX = 4000;
        break;
    }
    tex = loadImage(pathPfx + mapBitmapSizeX + "." + fileExt);
    
    textureMode(NORMAL);
    wmap = create2DMap(mapSizeX, mapSizeY);
    wmap2 = create2DMap(mapSizeX, mapSizeY, 200);
    // wmap = createCubeMap();
    
    mercMap = new MercatorMap(-(mapSizeX/2.0), -(mapSizeY/2.0), mapSizeX, mapSizeY, 85.0511, -85.0511, -180, 180); 
    
  }
  
  WorldMap3D(int mapSizeX, int mapSizeY) {
    this(mapSizeX, mapSizeY, 4000);
  }

  private PShape create2DMap(int mapSizeX, int mapSizeY) {
    return create2DMap(mapSizeX, mapSizeY, 0);
  }


  private PShape create2DMap(int mapSizeX, int mapSizeY, int zCoord) {
    PShape m2d = createShape(QUADS);
    float halfX = mapSizeX/2.0;
    float halfY = mapSizeY/2.0;
    m2d.texture(tex);
    m2d.vertex(-halfX, -halfY,  zCoord,   0,   0);
    m2d.vertex( halfX, -halfY,  zCoord,   1,   0);
    m2d.vertex( halfX,  halfY,  zCoord,   1,   1);
    m2d.vertex(-halfX,  halfY,  zCoord,   0,   1);
    m2d.end(CLOSE);
    
    return m2d;
  }

  private PShape createCubeMap() {
    PShape mc = createShape(QUADS);
    mc.noStroke();
    mc.texture(tex);
    
    // +Z "front" face
    mc.vertex(-1, -1,  1, 0, 0);
    mc.vertex( 1, -1,  1, 1, 0);
    mc.vertex( 1,  1,  1, 1, 1);
    mc.vertex(-1,  1,  1, 0, 1);
  
    // -Z "back" face
    mc.vertex( 1, -1, -1, 0, 0);
    mc.vertex(-1, -1, -1, 1, 0);
    mc.vertex(-1,  1, -1, 1, 1);
    mc.vertex( 1,  1, -1, 0, 1);
  
    // +Y "bottom" face
    mc.vertex(-1,  1,  1, 0, 0);
    mc.vertex( 1,  1,  1, 1, 0);
    mc.vertex( 1,  1, -1, 1, 1);
    mc.vertex(-1,  1, -1, 0, 1);
  
    // -Y "top" face
    mc.vertex(-1, -1, -1, 0, 0);
    mc.vertex( 1, -1, -1, 1, 0);
    mc.vertex( 1, -1,  1, 1, 1);
    mc.vertex(-1, -1,  1, 0, 1);
  
    // +X "right" face
    mc.vertex( 1, -1,  1, 0, 0);
    mc.vertex( 1, -1, -1, 1, 0);
    mc.vertex( 1,  1, -1, 1, 1);
    mc.vertex( 1,  1,  1, 0, 1);
  
    // -X "left" face
    mc.vertex(-1, -1, -1, 0, 0);
    mc.vertex(-1, -1,  1, 1, 0);
    mc.vertex(-1,  1,  1, 1, 1);
    mc.vertex(-1,  1, -1, 0, 1);
    
    mc.end(CLOSE);
    
    return mc;
  }
  
  void update() {
    shape(wmap);
    shape(wmap2);
  }
  
  void setTint(int col, int al) {
    wmap.tint(col, al);
  }
  
  int getMapBitmapSizeX() {
    return mapBitmapSizeX;
  }
  
  MercatorMap getMercatorMap() {
    return mercMap;
  }
  


}
