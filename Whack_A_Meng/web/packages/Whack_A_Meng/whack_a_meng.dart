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

class Game extends Sprite {
  ResourceManager _resourceManager;
  
  Game(this._resourceManager) {
    this.onAddedToStage.listen(_onAddedToStage);
  }
  
  _onAddedToStage(Event e) {
    Level level = new Level(_resourceManager, 1);
    addChild(level);
    level.Start();
  }
}