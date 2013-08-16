part of whack_a_meng;

class Direction {
  static const int LeftToRight  = 1;
  static const int RightToLeft  = 2;
}

abstract class NpcVisit extends Sprite {
  Random random = new Random();
  Bitmap npc;
  int direction;

  ResourceManager resourceManager;

  NpcVisit(this.resourceManager) {
    npc = _PickNpc();
    addChild(npc);

    direction = _ChooseDirection();
    if (direction == Direction.LeftToRight) {
      // all images are facing left, so when going from left to right, flip the
      // npc image horizontally
      npc.scaleX = -1;
    }
  }

  List<String> GetNpcList();

  _PickNpc() {
    List<String> npcs = GetNpcList();
    String npcName = npcs[random.nextInt(npcs.length)];
    BitmapData background = resourceManager.getBitmapData(npcName);
    return new Bitmap(background);
  }

  int _ChooseDirection() {
    // if next bool = true then go from right to left
    if (random.nextBool())
    {
      return Direction.LeftToRight;
    // else go from left to right
    } else {
      return Direction.RightToLeft;
    }
  }

  Future<NpcVisit> Visit();
}

class StraightWalk extends NpcVisit {
  List<String> _npcs = [ "gnome", "gui", "taotie", "yeti", "drop_bear", "meng_npc",
                        "pixie_banksia", "pixie_dandelion", "pixie_orchid" ];
  num _toX;

  StraightWalk(ResourceManager resourceManager) : super(resourceManager) {
  }

  List<String> GetNpcList() {
    return _npcs;
  }

  Future<NpcVisit> Visit() {
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

class WaterVisit extends NpcVisit {
  List<String> _npcs = [ "mermaid_blonde", "mermaid_red",
                         "selkie_blonde", "selkie_red", "selkie_violet" ];

  WaterVisit(ResourceManager resourceManager) : super(resourceManager) {
  }

  List<String> GetNpcList() {
    return _npcs;
  }

  Future<NpcVisit> Visit() {
    this.y = stage.height;
    int toY = (600 - npc.height).toInt();

    this.x = random.nextInt((800 - npc.width).toInt());

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