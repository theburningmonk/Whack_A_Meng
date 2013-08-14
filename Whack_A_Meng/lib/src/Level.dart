part of whack_a_meng;

class Level extends Sprite {
  ResourceManager _resourceManager;
  int level;
  
  Random _random = new Random(); 
  
  int _leftOffset = 25;
  int _topOffset = 25;
  
  static Level Current;
  
  Level(this._resourceManager, this.level) {
    onMouseOver.listen((evt) => Hammer.Instance.Move(evt));
    onMouseMove.listen((evt) => Hammer.Instance.Move(evt));
    onMouseClick.listen((evt) => Hammer.Instance.Hit(evt));
    
    Current = this;
  }
  
  Start() {    
    DrawBackground();
    
    LevelSpec levelSpec = _resourceManager.getCustomObject("level_${level}_spec");
    BitmapData holeData = _resourceManager.getBitmapData("hole");
    
    for (var i = 1; i <= levelSpec.columns; i++) {
      int x = _leftOffset + 170 * i - holeData.width;
      
      for (var j = 1; j <= levelSpec.rows; j++) {
        int y = _topOffset + 150 * j - holeData.height;
        
        Hole hole = new Hole(_resourceManager)
                          ..x = x
                          ..y = y;
        addChild(hole);
      }
    }
  }
  
  DrawBackground() {
    List<String> tileTypes = _resourceManager.getCustomObject("tile_types");
    String tileType = tileTypes[_random.nextInt(tileTypes.length)];
    BitmapData tileData = _resourceManager.getBitmapData("${tileType}_plain");
    BitmapData riverData = _resourceManager.getBitmapData("${tileType}_river");
    
    int hTiles = stage.width ~/ tileData.width;
    int vTiles = stage.height ~/ tileData.height;
    
    for (int h = 0; h < hTiles; h++) {
      int x = tileData.width * h;
      
      for (int v = 0; v < vTiles-1; v++) {
        int y = tileData.height * v; 
        
        Bitmap plainTile = new Bitmap(tileData)
            ..x = x
            ..y = y;
        addChild(plainTile); 
      }      
      
      Bitmap river = new Bitmap(riverData)
        ..x = x
        ..y = tileData.height * (vTiles-1);
      addChild(river);
    }
  }
}