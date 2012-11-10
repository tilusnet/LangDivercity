class WorldMap3D {
  private PImage tex;
  private int mapBitmapSizeX;
  private MercatorMap mercMap; 
  private int mapSizeX, mapSizeY;
  
  
  WorldMap3D(int mapSizeX, int mapSizeY, int mapBitmapSizeX) {
    this.mapSizeX = mapSizeX;
    this.mapSizeY = mapSizeY;
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
    draw2DMap(mapSizeX, mapSizeY);
    // wmap2 = create2DMap(mapSizeX, mapSizeY, 200);
    // wmap = createCubeMap();
    
    mercMap = new MercatorMap(-(mapSizeX/2.0), -(mapSizeY/2.0), mapSizeX, mapSizeY, 85.0511, -85.0511, -180, 180); 
    
  }
  
  WorldMap3D(int mapSizeX, int mapSizeY) {
    this(mapSizeX, mapSizeY, 4000);
  }

  private void draw2DMap(int mapSizeX, int mapSizeY) {
    draw2DMap(mapSizeX, mapSizeY, 0);
  }


  private void draw2DMap(int mapSizeX, int mapSizeY, int zCoord) {
    float halfX = mapSizeX/2.0;
    float halfY = mapSizeY/2.0;

    beginShape(QUADS);
    texture(tex);
    vertex(-halfX, -halfY,  zCoord,   0,   0);
    vertex( halfX, -halfY,  zCoord,   1,   0);
    vertex( halfX,  halfY,  zCoord,   1,   1);
    vertex(-halfX,  halfY,  zCoord,   0,   1);
    endShape();
  }

  private void drawCubeMap() {
    noStroke();

    beginShape(QUADS);
    texture(tex);
    
    // +Z "front" face
    vertex(-1, -1,  1, 0, 0);
    vertex( 1, -1,  1, 1, 0);
    vertex( 1,  1,  1, 1, 1);
    vertex(-1,  1,  1, 0, 1);
  
    // -Z "back" face
    vertex( 1, -1, -1, 0, 0);
    vertex(-1, -1, -1, 1, 0);
    vertex(-1,  1, -1, 1, 1);
    vertex( 1,  1, -1, 0, 1);
  
    // +Y "bottom" face
    vertex(-1,  1,  1, 0, 0);
    vertex( 1,  1,  1, 1, 0);
    vertex( 1,  1, -1, 1, 1);
    vertex(-1,  1, -1, 0, 1);
  
    // -Y "top" face
    vertex(-1, -1, -1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1, -1,  1, 1, 1);
    vertex(-1, -1,  1, 0, 1);
  
    // +X "right" face
    vertex( 1, -1,  1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1,  1, -1, 1, 1);
    vertex( 1,  1,  1, 0, 1);
  
    // -X "left" face
    vertex(-1, -1, -1, 0, 0);
    vertex(-1, -1,  1, 1, 0);
    vertex(-1,  1,  1, 1, 1);
    vertex(-1,  1, -1, 0, 1);
    
    endShape();
  }
  
  void update() {
    draw2DMap(mapSizeX, mapSizeY);
  }
  
  void setTint(int col, int al) {
    tint(col, al);
    draw2DMap(mapSizeX, mapSizeY);
  }
  
  int getMapBitmapSizeX() {
    return mapBitmapSizeX;
  }
  
  MercatorMap getMercatorMap() {
    return mercMap;
  }
  


}
