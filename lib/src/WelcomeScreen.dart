part of whack_a_meng;

class WelcomeScreen extends Sprite {
  ResourceManager _resourceManager;
  Bitmap _background;
  
  WelcomeScreen(this._resourceManager) {
    _background = new Bitmap(_resourceManager.getBitmapData("welcome"));     
    addChild(_background);
    
    var start = new Bitmap(_resourceManager.getBitmapData("start"));    
    var startHover = new Bitmap(_resourceManager.getBitmapData("start_hover"));
    var startClick = new Bitmap(_resourceManager.getBitmapData("start_click"));
    
    var startButton = new Button(start, startHover, startClick)
                        ..x = 93
                        ..y = 430;    
    addChild(startButton);    
    startButton.onMouseUp.listen(_onStartMouseUp);
  }
  
  _onStartMouseUp(_) {
    stage.removeChild(this);
  }
}