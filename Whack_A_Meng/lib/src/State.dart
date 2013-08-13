part of whack_a_meng;

class State extends Sprite {
  int score = 0;
  int timeLeft;
  
  ResourceManager _resourceManager;
  BitmapData _woodSign;
  StreamController _gameOverController;
  
  State(this._resourceManager, this.timeLeft) {
    _woodSign = _resourceManager.getBitmapData("wood_sign");
    _gameOverController = new StreamController.broadcast();
    new Timer.periodic(new Duration(seconds : 1), (_) => timeLeft--);
  }
  
  Stream get onGameover => _gameOverController.stream;
}