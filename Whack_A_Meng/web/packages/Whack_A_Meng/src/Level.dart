part of whack_a_meng;

class Level extends Sprite {
  ResourceManager _resourceManager;
  int _level;
  LevelSpec _levelSpec;

  Random _random = new Random();

  int _leftOffset = 25;
  int _topOffset  = 25;
  num _bannerY    = 260;

  ScoreBoard _scoreBoard;
  Clock _clock;
  NpcVisitScheduler _npcScheduler;

  List<Hole> _holes = new List<Hole>();

  Completer<int> _completer = new Completer<int>();

  Level(this._resourceManager, this._level) {
  }

  Future<int> start() {
    _drawBackground();

    _levelSpec = _resourceManager.getCustomObject("level_specs")[_level-1];

    _scoreBoard = new ScoreBoard(_resourceManager, _levelSpec.target)
      ..x = 575
      ..y = 250;
    addChild(_scoreBoard);

    _clock = new Clock(_resourceManager, _levelSpec.timeLimit)
      ..x = 605
      ..y = 100;
    addChild(_clock);

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

    _npcScheduler = new NpcVisitScheduler(_resourceManager, this, maxConcurrent : _levelSpec.maxConcurrentNpc, spawnProb : _levelSpec.npcSpawnProb)
      ..onNpcWhacked.listen((_) => _scoreBoard.decrement());

    if (_levelSpec.tutorialName != null) {
      TutorialScreen tutorial = new TutorialScreen(_resourceManager, _levelSpec.tutorialName);
      tutorial
        ..x = 400 - tutorial.width / 2
        ..y = 300 - tutorial.height / 2;

      addChild(tutorial);

      tutorial.onClose.listen((_) {
        removeChild(tutorial);
        _showAnnouncements();
      });
    } else {
      _showAnnouncements();
    }

    return _completer.future;
  }

  _start() {
    for (var hole in _holes) {
      hole.enable();
    }

    _npcScheduler.start();
    _clock.start().then(_timeUp);
  }

  _showAnnouncements() {
    _announce("LEVEL $_level")
      .then((_) => _showOverlay("start_level_ready")
        .then((_) => _showOverlay("start_level_go")
          .then((_) => _start())));
  }

  Future _announce(String text) {
    BitmapData bannerBackgroundData = _resourceManager.getBitmapData("start_level");
    Bitmap bannerBackground = new Bitmap(bannerBackgroundData);
    Sprite banner = new Sprite()
      ..addChild(bannerBackground)
      ..x = -bannerBackgroundData.width
      ..y = _bannerY;

    TextField lvlTextField = new TextField()
      ..text = text
      ..defaultTextFormat = new TextFormat("Calibri", 60, Color.White, bold : true)
      ..y = 3;
    lvlTextField
      ..x = bannerBackground.width / 2 - lvlTextField.textWidth / 2
      ..width = lvlTextField.textWidth;
    banner.addChild(lvlTextField);

    addChild(banner);

    Completer completer = new Completer();

    stage.juggler.tween(banner, 0.6)
      ..animate.x.to(-30)
      ..onComplete = () {
        stage.juggler.tween(banner, 0.6)
          ..animate.x.to(800)
          ..delay = 2
          ..onComplete = () {
            completer.complete();
          };
      };

    return completer.future;
  }

  Future _showOverlay(String overlayName) {
    Completer completer = new Completer();

    Bitmap overlay = new Bitmap(_resourceManager.getBitmapData(overlayName))
      ..y = _bannerY
      ..alpha = 0;

    addChild(overlay);

    stage.juggler.tween(overlay, 0.2)
      ..animate.alpha.to(1)
      ..onComplete = () {
        stage.juggler.tween(overlay, 0.2)
          ..animate.alpha.to(0)
          ..delay = 1
          ..onComplete = () {
            removeChild(overlay);
            completer.complete();
          };
      };

    return completer.future;
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

    _announce("TIME UP")
      .then((_) {
        if (_scoreBoard.score >= _levelSpec.target) {
          _completer.complete(LevelResult.Win);
        } else {
          _completer.complete(LevelResult.TimeOut);
        }
      });
  }
}