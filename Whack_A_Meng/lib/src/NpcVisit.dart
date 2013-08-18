part of whack_a_meng;

class Direction {
  static const int LeftToRight  = 1;
  static const int RightToLeft  = 2;
}

abstract class NpcVisit extends Sprite with OptionSelector {
  Random random = new Random();
  Bitmap npc;
  int direction;

  ResourceManager resourceManager;

  NpcVisit(this.resourceManager) {
    npc = _pickNpc();
    addChild(npc);

    direction = _chooseDirection();
    if (direction == Direction.LeftToRight) {
      // all images are facing left, so when going from left to right, flip the
      // npc image horizontally
      npc.scaleX = -1;
    }
  }

  _pickNpc() {
    String npcName = pickOption();
    BitmapData background = resourceManager.getBitmapData(npcName);
    return new Bitmap(background);
  }

  int _chooseDirection() {
    // if next bool = true then go from right to left
    if (random.nextBool())
    {
      return Direction.LeftToRight;
    // else go from left to right
    } else {
      return Direction.RightToLeft;
    }
  }

  Future<NpcVisit> visit();
}

class Walker extends NpcVisit {
  List<String> _npcs = [ "gnome", "gui", "taotie", "yeti", "drop_bear", "meng_npc",
                        "pixie_banksia", "pixie_dandelion", "pixie_orchid" ];
  num _toX;

  Walker(ResourceManager resourceManager) : super(resourceManager) {
  }

  List getOptions() {
    return _npcs;
  }

  Future<NpcVisit> visit() {
    this.y = random.nextInt((550 - npc.height).toInt());

    if (direction == Direction.RightToLeft) {
      this.x = stage.width;
      _toX   = -npc.width;
    } else {
      this.x = -npc.width;
      _toX   = stage.width;
    }

    var completer = new Completer<NpcVisit>();

    stage.juggler.tween(this, 10)
      ..animate.x.to(_toX)
      ..onComplete = () => completer.complete(this);

    return completer.future;
  }
}

class Swimmer extends NpcVisit {
  List<String> _npcs = [ "mermaid_blonde", "mermaid_red",
                         "selkie_blonde", "selkie_red", "selkie_violet" ];

  Swimmer(ResourceManager resourceManager) : super(resourceManager) {
  }

  List getOptions() {
    return _npcs;
  }

  Future<NpcVisit> visit() {
    y = stage.height;
    int toY = (600 - npc.height).toInt();

    x = random.nextInt((800 - npc.width).toInt());

    var completer = new Completer<NpcVisit>();

    stage.juggler.tween(this, 1, TransitionFunction.easeOutBack)
      ..animate.y.to(toY)
      ..onComplete = () {
        stage.juggler.delayCall(() {
          stage.juggler.tween(this, 0.5, TransitionFunction.easeOutBack)
            ..animate.y.to(stage.height)
            ..onComplete = () => completer.complete(this);
        }, 5);
      };

    return completer.future;
  }
}

typedef NpcVisit GenVisitor();

class NpcVisitScheduler extends Sprite {
  ResourceManager _resourceManager;
  DisplayObjectContainer _container;

  int _maxConcurrent;
  int _current = 0;
  double _spawnProb;

  List _generators;
  Random _random = new Random();

  StreamSubscription _enterFrameSub;

  NpcVisitScheduler(this._resourceManager, this._container, { int maxConcurrent, double spawnProb }) {
    if (maxConcurrent == null) {
      _maxConcurrent = 1;
    } else {
      _maxConcurrent = maxConcurrent;
    }

    if (spawnProb == null) {
      _spawnProb = 0.001;
    } else {
      _spawnProb = spawnProb;
    }

    _generators = [ () => new Walker(_resourceManager),
                    () => new Swimmer(_resourceManager) ];
  }

  start() {
    _enterFrameSub = onEnterFrame.listen(_onEnterFrame);
  }

  stop() {
    _enterFrameSub.cancel();
  }

  _onEnterFrame(_) {
    if (_current < _maxConcurrent &&  _random.nextDouble() <= _spawnProb) {
      GenVisitor generator = _generators[_random.nextInt(_generators.length)];
      NpcVisit visitor = generator();
      _current++;

      _container.addChild(visitor);
      visitor.visit().then((_) {
        _container.removeChild(visitor);
        _current--;
      });
    }
  }
}