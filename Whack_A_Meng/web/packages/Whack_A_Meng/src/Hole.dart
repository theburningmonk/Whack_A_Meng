part of whack_a_meng;

class Hole extends Sprite {
  ResourceManager _resourceManager;
  BitmapData _whack;
  BitmapData _awesome;
  BitmapData _great;
  BitmapData _meng;
  
  Hole(this._resourceManager) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("hole"));
    Bitmap foreground = new Bitmap(_resourceManager.getBitmapData("hole_over"));    
    
    addChild(background);
    addChild(foreground);
    
    _whack = _resourceManager.getBitmapData("whack");
    _awesome = _resourceManager.getBitmapData("awesome");
    _great = _resourceManager.getBitmapData("great");
    _meng = _resourceManager.getBitmapData("meng");
    
    this.onMouseClick.listen(_onMouseClick);
  }
  
  _onMouseClick(MouseEvent evt) {
    Bitmap awesome = new Bitmap(_whack);
    awesome.x = evt.stageX - _whack.width / 2;
    awesome.y = evt.stageY - _whack.height / 2;
    
    stage.addChild(awesome);
    
    new Timer(new Duration(milliseconds : 300), () => stage.removeChild(awesome));
    new Timer(new Duration(milliseconds : 400), () => addChild(new Bitmap(_meng)));
    
    print("hole clicked");
  }
}