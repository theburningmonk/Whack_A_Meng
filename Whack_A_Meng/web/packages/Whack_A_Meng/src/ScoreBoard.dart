part of whack_a_meng;

class ScoreBoard extends Sprite {
  ResourceManager _resourceManager;
  int _score = 0;
  int _target;

  ScoreBoard(this._resourceManager, this._target) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("score_board"));
    addChild(background);
  }

  Increment() {
  }

  Decrement() {
  }
}