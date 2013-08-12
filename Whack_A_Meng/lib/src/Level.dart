part of whack_a_meng;

class Level extends Sprite {
  ResourceManager _resourceManager;
  int level;
  
  Random _random = new Random();
  int _leftOffset = 100;
  int _topOffset = 100;
  
  Level(this._resourceManager, this.level) {    
  }
  
  Start() {
    List<String> tileTypes = _resourceManager.getCustomObject("tile_types");
    String tileType = tileTypes[_random.nextInt(tileTypes.length)];
    BitmapData tileData = _resourceManager.getBitmapData("${tileType}_plain");
    BitmapData riverData = _resourceManager.getBitmapData("${tileType}_river");
    
    LevelSpec levelSpec = _resourceManager.getCustomObject("level_${level}_spec");
    
    for (int i = -1; i < levelSpec.columns; i++) {
      int x = _leftOffset + 100 * i;
      
      Bitmap top = new Bitmap(tileData)..x = x;
      addChild(top);
      
      for (int j = -1; j < levelSpec.rows; j++) {
        int y = _topOffset + 100 * j;
        
        Bitmap tile = new Bitmap(tileData)
                            ..x = x
                            ..y = y;        
        addChild(tile);
        
        if (i >= 0 && j >= 0) {        
          Hole hole = new Hole(_resourceManager)
                            ..x = x
                            ..y = y;
          addChild(hole);
        }
      }

      int y = _topOffset + 100 * levelSpec.rows;      
      Bitmap river = new Bitmap(riverData)
                          ..x = x
                          ..y = y;
      addChild(river);
    }
  }
}