library whack_a_meng;

import "dart:async";
import "dart:math";
import 'package:stagexl/stagexl.dart';

part "src/Button.dart";
part "src/Clock.dart";
part "src/EndOfLevelScreen.dart";
part "src/Hammer.dart";
part "src/Hole.dart";
part "src/Level.dart";
part "src/LevelResult.dart";
part "src/LevelSpec.dart";
part "src/NpcVisit.dart";
part "src/ScoreBoard.dart";
part "src/TutorialScreen.dart";
part "src/WelcomeScreen.dart";

class Game extends Sprite {
  ResourceManager _resourceManager;
  int _currentLevelNum = 1;
  int _maxLevelNum;
  Level _currentLevel;

  Game(this._resourceManager) {
    _maxLevelNum = _resourceManager.getCustomObject("level_specs").length;

    onAddedToStage.listen(_onAddedToStage);
  }

  _onAddedToStage(Event e) {
    var hammer = new Hammer(_resourceManager);
    addChild(hammer);

    onMouseMove.listen((evt) => Hammer.Instance.move(evt));
    onMouseClick.listen((evt) => Hammer.Instance.hit(evt));

    _startLevel();
  }

  _startLevel() {
    // no more levels
    if (_currentLevelNum == _maxLevelNum) {
      Bitmap endGameBitmap = new Bitmap(_resourceManager.getBitmapData("end_game"));
      addChild(endGameBitmap);
    } else {
      _currentLevel = new Level(_resourceManager, _currentLevelNum);
      addChildAt(_currentLevel, 0);

      Mouse.hide();

      _currentLevel.start().then((result) {
        Mouse.show();

        var resultScreen = new EndOfLevelScreen(_resourceManager, result);
        addChild(resultScreen);

        resultScreen.onClose.listen((_) {
          if (result == LevelResult.TimeOut) {
            _currentLevelNum = 1;
          } else {
            _currentLevelNum++;
          }

          removeChild(_currentLevel);
          _startLevel();

          removeChild(resultScreen);
        });
      });
    }
  }
}

// Mixin for a selector with number of potential options
abstract class OptionSelector {
  Random _random = new Random();

  dynamic pickOption() {
    List options = getOptions();
    return options[_random.nextInt(options.length)];
  }

  List getOptions();
}

// Mixin for something that can be whacked!
abstract class Whackable {
  StreamController _onWhackedController = new StreamController.broadcast();

  Stream get onWhacked => _onWhackedController.stream;
  int _whackedCount = 0;

  whack() {
    _whackedCount++;
    _onWhackedController.add(_whackedCount);
  }
}