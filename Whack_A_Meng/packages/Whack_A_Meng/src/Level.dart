part of whack_a_meng;

class Level extends Sprite {
  ResourceManager _resourceManager;
  int level;

  Random _random = new Random();

  int _leftOffset = 25;
  int _topOffset = 25;

  static Level Current;

  Level(this._resourceManager, this.level) {
    Current = this;
  }

  Start() {
    DrawBackground();

    LevelSpec levelSpec = _resourceManager.getCustomObject("level_${level}_spec");

    ScoreBoard scoreBoard = new ScoreBoard(_resourceManager, levelSpec.target)
      ..x = 575
      ..y = 250;
    addChild(scoreBoard);

    Clock clock = new Clock(_resourceManager, levelSpec.timeLimit)
      ..x = 605
      ..y = 100;
    addChild(clock);

    BitmapData holeData = _resourceManager.getBitmapData("hole");

    for (var i = 1; i <= levelSpec.columns; i++) {
      int x = _leftOffset + 170 * i - holeData.width;

      for (var j = 1; j <= levelSpec.rows; j++) {
        int y = _topOffset + 150 * j - holeData.height;

        Hole hole = new Hole(_resourceManager, levelSpec.spawnTime, levelSpec.retreatTime, levelSpec.stayTime)
                          ..x = x
                          ..y = y;
        hole.onMengWhacked.listen((_) => scoreBoard.Increment());
        addChild(hole);
      }
    }

    StraightWalk walk = new StraightWalk(_resourceManager);
    addChild(walk);
    walk.Visit().then((_) => removeChild(walk));

    NpcVisit water = new WaterVisit(_resourceManager);
    addChild(water);
    water.Visit().then((_) => removeChild(water));
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