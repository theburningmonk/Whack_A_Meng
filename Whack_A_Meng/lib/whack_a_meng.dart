library whack_a_meng;

import "dart:async";
import "dart:math";
import 'package:stagexl/stagexl.dart';

part "src/Level.dart";
part "src/LevelSpec.dart";
part "src/Hole.dart";
part "src/Target.dart";
part "src/Button.dart";
part "src/WelcomeScreen.dart";
part "src/State.dart";
part "src/Hammer.dart";
part "src/Clock.dart";
part "src/ScoreBoard.dart";
part "src/NpcVisit.dart";

class Game extends Sprite {
  ResourceManager _resourceManager;

  Game(this._resourceManager) {
    this.onAddedToStage.listen(_onAddedToStage);
    new Hammer(_resourceManager);
  }

  _onAddedToStage(Event e) {
    Level level = new Level(_resourceManager, 1);
    addChild(level);
    level.Start();

    addChild(Hammer.Instance);
    Mouse.hide();

    onMouseMove.listen((evt) => Hammer.Instance.Move(evt));
    onMouseClick.listen((evt) => Hammer.Instance.Hit(evt));
  }
}