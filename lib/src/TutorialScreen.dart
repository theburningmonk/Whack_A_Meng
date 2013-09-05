part of whack_a_meng;

class TutorialScreen extends Sprite {
  ResourceManager _resourceManager;
  Bitmap _background;

  StreamController _onCloseController = new StreamController.broadcast();

  TutorialScreen(this._resourceManager, String backgroundName) {
    _background = new Bitmap(_resourceManager.getBitmapData(backgroundName));
    addChild(_background);

    var btnNormal = new Bitmap(_resourceManager.getBitmapData("continue"));
    var btnHover  = new Bitmap(_resourceManager.getBitmapData("continue_hover"));
    var btnClick  = new Bitmap(_resourceManager.getBitmapData("continue_click"));

    var button = new Button(btnNormal, btnHover, btnClick)
      ..x = 60
      ..y = 345;
    addChild(button);
    button.onMouseUp.listen((_) => _onCloseController.add(this));

    width  = _background.width;
    height = _background.height;
  }

  Stream get onClose => _onCloseController.stream;
}