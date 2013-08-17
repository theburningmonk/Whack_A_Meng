part of whack_a_meng;

class Level extends Sprite {
  ResourceManager _resourceManager;
  int _level;
  LevelSpec _levelSpec;

  Random _random = new Random();

  int _leftOffset = 25;
  int _topOffset = 25;

  ScoreBoard _scoreBoard;
  NpcVisitScheduler _npcScheduler;

  List<Hole> _holes = new List<Hole>();

  Completer<int> _completer = new Completer<int>();

  Level(this._resourceManager, this._level) {
  }

  Future<int> start() {
    _drawBackground();

    _levelSpec = _resourceManager.getCustomObject("level_${_level}_spec");

    _scoreBoard = new ScoreBoard(_resourceManager, _levelSpec.target)
      ..x = 575
      ..y = 250;
    addChild(_scoreBoard);

    Clock clock = new Clock(_resourceManager, _levelSpec.timeLimit)
      ..x = 605
      ..y = 100;
    addChild(clock);

    BitmapData holeData = _resourceManager.getBitmapData("hole");

    for (var i = 1; i <= _levelSpec.columns; i++) {
      int x = _leftOffset + 170 * i - holeData.width;

      for (var j = 1; j <= _levelSpec.rows; j++) {
        int y = _topOffset + 150 * j - holeData.height;

        Hole hole = new Hole(_resourceManager, _levelSpec.spawnTime, _levelSpec.retreatTime, _levelSpec.stayTime)
                          ..x = x
                          ..y = y;
        hole.onMengWhacked.listen((_) => _scoreBoard.increment());
        _holes.add(hole);

        addChild(hole);
      }
    }

    _npcScheduler = new NpcVisitScheduler(_resourceManager, this, maxConcurrent : _levelSpec.maxConcurrentNpc, spawnProb : _levelSpec.npcSpawnProb);
    _npcScheduler.start();

    clock.start().then(_timeUp);
    return _completer.future;
  }

  _drawBackground() {
    List<String> tileTypes = _resourceManager.getCustomObject("tile_types");
    String tileType = tileTypes[_random.nextInt(tileTypes.length)];
    BitmapData tileData = _resourceManager.getBitmapData("${tileType}_plain");
    BitmapData riverData = _resourceManager.getBitmapData("${tileType}_river");

    int hTiles = 800 ~/ tileData.width;
    int vTiles = 600 ~/ tileData.height;

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

  _timeUp(_) {
    for (var hole in _holes) {
      hole.disable();
    }

    _npcScheduler.stop();

    if (_scoreBoard.score >= _levelSpec.target) {
      _completer.complete(LevelResult.Win);
    } else {
      _completer.complete(LevelResult.TimeOut);
    }
  }
}