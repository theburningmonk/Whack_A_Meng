part of whack_a_meng;

class ScoreBoard extends Sprite {
  ResourceManager _resourceManager;
  int score = 0;
  int target;

  int _hundredX = 42;
  int _tenX     = 82;
  int _oneX     = 122;

  int _scoreColor  = Color.White;
  int _targetColor = Color.Orange;

  TextField _scoreHundreds, _scoreTens, _scoreOnes;

  ScoreBoard(this._resourceManager, this.target) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("score_board"));
    addChild(background);

    _draw(target, 150, _targetColor);
    List<TextField> scoreParts = _draw(score, 55, _scoreColor);
    _scoreHundreds = scoreParts[0];
    _scoreTens     = scoreParts[1];
    _scoreOnes     = scoreParts[2];
  }

  _draw(int score, int y, int color) {
    TextFormat textFormat = new TextFormat("Calibri", 30, color, bold : true);

    TextField hundreds = new TextField()
      ..x = _hundredX
      ..y = y
      ..defaultTextFormat = textFormat
      ..text = (score ~/ 100).toString();
    addChild(hundreds);

    TextField tens = new TextField()
    ..x = _tenX
    ..y = y
    ..defaultTextFormat = textFormat
    ..text = (score % 100 ~/ 10).toString();
    addChild(tens);

    TextField ones = new TextField()
    ..x = _oneX
    ..y = y
    ..defaultTextFormat = textFormat
    ..text = (score % 10).toString();
    addChild(ones);

    return [ hundreds, tens, ones ];
  }

  _drawScore() {
    _scoreHundreds.text = (score ~/ 100).toString();
    _scoreTens.text     = (score % 100 ~/ 10).toString();
    _scoreOnes.text     = (score % 10).toString();
  }

  increment() {
    score += 1;
    _drawScore();
  }

  decrement() {
    score -= 1;
    _drawScore();
  }
}