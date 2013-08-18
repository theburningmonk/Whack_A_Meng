part of whack_a_meng;

class EndOfLevelScreen extends Sprite with OptionSelector {
  ResourceManager _resourceManager;
  Bitmap _background;
  Bitmap _overlay;

  List<String> _npcList = [ "gnome", "meng", "mermaid_red", "selkie_violet", "vege_lamb", "yeti", "gui" ];
  Random _random = new Random();

  EndOfLevelScreen(this._resourceManager, int result) {
    String npc = pickOption();

    if (result == LevelResult.TimeOut) {
      _background = new Bitmap(_resourceManager.getBitmapData("timeout"));
      _overlay = new Bitmap(_resourceManager.getBitmapData("timeout_${npc}_overlay"));
    } else {
      _background = new Bitmap(_resourceManager.getBitmapData("win"));
      _overlay = new Bitmap(_resourceManager.getBitmapData("win_${npc}_overlay"));
    }

    addChild(_background);

    _overlay.y = 180;
    addChild(_overlay);

    var start = new Bitmap(_resourceManager.getBitmapData("retry"));
    var startHover = new Bitmap(_resourceManager.getBitmapData("retry_hover"));
    var startClick = new Bitmap(_resourceManager.getBitmapData("retry_click"));

    var startButton = new Button(start, startHover, startClick)
                        ..x = 310
                        ..y = 385;
    addChild(startButton);
    startButton.onMouseUp.listen(_onStartMouseUp);
  }

  getOptions() {
    return _npcList;
  }

  _onStartMouseUp(_) {
    stage.removeChild(this);
  }
}