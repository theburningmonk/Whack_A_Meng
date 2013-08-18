part of whack_a_meng;

class EndOfLevelScreen extends Sprite with OptionSelector {
  ResourceManager _resourceManager;
  Bitmap _background;
  Bitmap _overlay;
  String _buttonName;

  List<String> _npcList = [ "gnome", "meng", "mermaid_red", "selkie_violet", "vege_lamb", "yeti", "gui" ];

  StreamController _onCloseController = new StreamController.broadcast();

  EndOfLevelScreen(this._resourceManager, int result) {
    String npc = pickOption();

    if (result == LevelResult.TimeOut) {
      _background = new Bitmap(_resourceManager.getBitmapData("timeout"));
      _overlay    = new Bitmap(_resourceManager.getBitmapData("timeout_${npc}_overlay"));
      _buttonName = "retry";
    } else {
      _background = new Bitmap(_resourceManager.getBitmapData("win"));
      _overlay    = new Bitmap(_resourceManager.getBitmapData("win_${npc}_overlay"));
      _buttonName = "continue";
    }

    addChild(_background);

    _overlay.y = 180;
    addChild(_overlay);

    var btnNormal = new Bitmap(_resourceManager.getBitmapData(_buttonName));
    var btnHover  = new Bitmap(_resourceManager.getBitmapData("${_buttonName}_hover"));
    var btnClick  = new Bitmap(_resourceManager.getBitmapData("${_buttonName}_click"));

    var button = new Button(btnNormal, btnHover, btnClick)
      ..x = 310
      ..y = 385;
    addChild(button);
    button.onMouseUp.listen(_onStartMouseUp);
  }

  Stream get onClose => _onCloseController.stream;

  getOptions() {
    return _npcList;
  }

  _onStartMouseUp(_) {
    _onCloseController.add(this);
  }
}