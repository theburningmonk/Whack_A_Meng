part of whack_a_meng;

abstract class Target extends Sprite {
  ResourceManager _resourceManager;

  Target(this._resourceManager) {
    onMouseClick.listen(onMouseClickHander);
  }

  void onMouseClickHander(Event e);
}

class Meng extends Target {
  Meng(resourceManager) : super(resourceManager) {
    addChild(new Bitmap(_resourceManager.getBitmapData("meng")));
  }

  onMouseClickHander(_) {
    print("meng clicked");
  }
}

class NPC extends Target {
  String name;

  NPC(name, resourceManager) : super(resourceManager) {
    addChild(new Bitmap(_resourceManager.getBitmapData(name)));
  }

  onMouseClickHander(_) {
    print("meng clicked");
  }
}