part of whack_a_meng;

class Clock extends Sprite {
  ResourceManager _resourceManager;

  int _totalTime;
  int _timeLeft;

  Bitmap _background;
  TextField _textField;

  Clock(this._resourceManager, this._totalTime) {
    _timeLeft = _totalTime;

    _background = new Bitmap(_resourceManager.getBitmapData("clock_background"));
    addChild(_background);

    _textField = new TextField()
      ..defaultTextFormat = new TextFormat("Calibri", 54, Color.Black, bold : true)
      ..text = _timeLeft.toString()
      ..y = 27;

    _updateTextField();
    addChild(_textField);
  }

  Future start() {
    var completer = new Completer<NpcVisit>();

    DelayedCall timerAction = new DelayedCall(() {
      _timeLeft--;
      _updateTextField();

      if (_timeLeft == 0) {
        completer.complete();
      }
    }, 1.0)
      ..repeatCount = _timeLeft;

    stage.juggler.add(timerAction);

    return completer.future;
  }

  _updateTextField() {
    _textField.text = _timeLeft.toString();
    _textField.x = _background.width / 2 - _textField.textWidth / 2;

    if (_timeLeft <= _totalTime * 0.3) {
      _textField.defaultTextFormat.color = Color.Red;
    } else if (_timeLeft <= _totalTime * 0.6) {
      _textField.defaultTextFormat.color = Color.DarkOrange;
    }
  }
}