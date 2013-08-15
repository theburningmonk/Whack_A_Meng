part of whack_a_meng;

class NpcVisit extends Sprite {
  ResourceManager _resourceManager;
  NpcVisit(this._resourceManager) {
  }
}

class StraightWalk extends Sprite {
  List<String> _npcs = [ "gnome", "gui", "taotie", "yeti",
                        "pixie_banksia", "pixie_dandelion", "pixie_orchid" ];
  Random _random = new Random();
  Bitmap _npc;
  num _toX;

  StraightWalk(ResourceManager resourceManager) {
    String npcName = PickNpc();
    BitmapData background = resourceManager.getBitmapData(npcName);
    _npc = new Bitmap(background);
    addChild(_npc);
  }

  ChooseDirection() {
    // if next bool = true then go from right to left
    if (_random.nextBool())
    {
      this.x = stage.width;
      _toX   = -_npc.width;
    // else go from left to right
    } else {
      // all images are facing left, so when going from left to right, flip the
      // npc image horizontally
      _npc.scaleX = -1;
      this.x = -_npc.width;
      _toX   = stage.width;
    }
  }

  PickNpc() {
    return _npcs[_random.nextInt(_npcs.length)];
  }

  Future<NpcVisit> Visit() {
    this.y = _random.nextInt((stage.height - 50 - _npc.height).toInt());

    ChooseDirection();

    var completer = new Completer<NpcVisit>();

    stage.renderLoop.juggler.tween(this, 10)
      ..animate.x.to(_toX)
      ..onComplete = () => completer.complete(this);

    return completer.future;
  }
}