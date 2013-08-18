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
part "src/WelcomeScreen.dart";

class Game extends Sprite {
  ResourceManager _resourceManager;
  int _currentLevelNum = 1;
  Level _currentLevel;

  Game(this._resourceManager) {
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
    _currentLevel = new Level(_resourceManager, _currentLevelNum);
    addChildAt(_currentLevel, 0);

    Mouse.hide();

    _currentLevel.start().then((result) {
      Mouse.show();

      if (result == LevelResult.Win) {
        print("Win");
      } else if (result == LevelResult.TimeOut) {
        print("Time Out");

        addChild(new EndOfLevelScreen(_resourceManager, result));
      }
    });
  }
}

abstract class OptionSelector {
  Random _random = new Random();

  dynamic pickOption() {
    List options = getOptions();
    return options[_random.nextInt(options.length)];
  }

  List getOptions();
}