part of whack_a_meng;

class Clock extends Sprite {
  ResourceManager _resourceManager;
  int _timeLeft;

  Clock(this._resourceManager, this._timeLeft) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("clock_background"));
    addChild(background);
  }

  Start() {
  }
}