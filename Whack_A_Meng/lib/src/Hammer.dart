part of whack_a_meng;

class Hammer extends Sprite {
  ResourceManager _resourceManager;
  
  Sprite _background;
  
  static Hammer Instance;
  bool _isHitting = false;
  
  Hammer(this._resourceManager) {
    _background = new Sprite()
      ..addChild(new Bitmap(_resourceManager.getBitmapData("hammer")))
      ..mouseEnabled = false;
    
    _background.pivotX = _background.width;
    _background.pivotY = _background.height;
        
    addChild(_background);
    
    Instance = this;
  }
  
  Move(MouseEvent evt) {
    SetPosition(evt);
  }
  
  Hit(MouseEvent evt) {
    if (_isHitting) {
      return;
    }
    
    SetPosition(evt);
    
    Tween rotate = new Tween(_background, 0.2)
      ..animate.rotation.to(0.7)
      ..onComplete = () {
        _background.rotation = 0.0;
        _isHitting = false;
      };
      
    _isHitting = true;
    stage.renderLoop.juggler.add(rotate);       
  }
  
  SetPosition(MouseEvent evt) {
    x = evt.stageX + _background.width + 5;
    y = evt.stageY + _background.height / 2 + 18;    
  }
}