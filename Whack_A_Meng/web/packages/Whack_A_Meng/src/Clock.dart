part of whack_a_meng;

class Clock extends Sprite {
  ResourceManager _resourceManager;
  int _timeLeft;

  Clock(this._resourceManager, this._timeLeft) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("clock_background"));
    addChild(background);
  }

  Future start() {
    var completer = new Completer<NpcVisit>();

    DelayedCall timerAction = new DelayedCall(() {
      _timeLeft--;

      print(_timeLeft);

      if (_timeLeft == 0) {
        completer.complete();
      }
    }, 1.0)
      ..repeatCount = _timeLeft;

    stage.juggler.add(timerAction);

    return completer.future;
  }
}