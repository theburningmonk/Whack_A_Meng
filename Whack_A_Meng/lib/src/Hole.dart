part of whack_a_meng;

class Hole extends Sprite {
  Random _random = new Random();

  ResourceManager _resourceManager;
  num _spawnTime;
  num _retreatTime;
  num _stayTime;

  BitmapData _whack;
  BitmapData _awesome;
  BitmapData _great;

  Sprite _overlay;
  Sprite _meng;

  bool _isActive = false;
  bool _isRetreating = false;

  Hole(this._resourceManager, this._spawnTime, this._retreatTime, this._stayTime) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("hole"));
    Bitmap foreground = new Bitmap(_resourceManager.getBitmapData("hole_over"));

    addChild(background);

    _overlay = new Sprite()
        ..addChild(foreground)
        ..mouseEnabled = false;

    _whack = _resourceManager.getBitmapData("whack");
    _awesome = _resourceManager.getBitmapData("awesome");
    _great = _resourceManager.getBitmapData("great");

    _meng = new Sprite()
        ..addChild(new Bitmap(_resourceManager.getBitmapData("meng")))
        ..onMouseClick.listen(whackMeng)
        ..x = 5
        ..y = 15;

    this.onEnterFrame.listen(_onEnterFrame);
  }

  _onEnterFrame(EnterFrameEvent evt) {
    if (!_isActive && _random.nextInt(500) < 1) {
      spawnMeng();
    }
  }

  spawnMeng() {
    addChild(_meng);
    addChild(_overlay);

    _isActive = true;
    _isRetreating = false;

    stage.juggler.tween(_meng, _spawnTime, TransitionFunction.easeOutElastic)
      ..animate.x.to(-15);

    stage.juggler.delayCall(retreatMeng, _stayTime);
  }

  retreatMeng() {
    if (_isRetreating) {
      return;
    }

    _isRetreating = true;

    stage.juggler.tween(_meng, _retreatTime)
      ..animate.x.to(5)
        ..onComplete = () {
      removeChild(_meng);
      removeChild(_overlay);
      _isActive = false;
    };
  }

  showWhack(MouseEvent evt) {
    var whack = new Bitmap(_whack);

    whack.x = evt.localX - _whack.width / 2;
    whack.y = evt.localY - _whack.height / 2;

    addChild(whack);

    stage.juggler.delayCall(() => removeChild(whack), 0.3);
  }

  whackMeng(MouseEvent evt) {
    if (_isRetreating) {
      return;
    }

    showWhack(evt);

    stage.juggler.removeTweens(_meng);
    retreatMeng();
  }
}