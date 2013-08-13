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
    
    Sprite overlay = new Sprite()
        ..addChild(foreground)
        ..mouseEnabled = false;            
    addChild(overlay);
            
    _whack = _resourceManager.getBitmapData("whack");
    _awesome = _resourceManager.getBitmapData("awesome");
    _great = _resourceManager.getBitmapData("great");
    _meng = _resourceManager.getBitmapData("meng");
    
    List<Point> path = [ new Point(21, 25), 
                         new Point(24, 33),
                         new Point(36, 39),
                         new Point(45, 53),
                         new Point(45, 61),
                         new Point(51, 68),
                         new Point(51, 83),
                         new Point(58, 86),
                         new Point(58, 100),
                         new Point(0, 100),
                         new Point(0, 0),
                         new Point(21, 0),
                         new Point(21, 25) ];
        
    Sprite meng = new Sprite()
        ..addChild(new Bitmap(_meng))
        ..onMouseClick.listen(_onMouseClick)
        ..mask = new Mask.custom(path);    
    this.addChildAt(meng, 1);
  }
  
  _onMouseClick(MouseEvent evt) {
    Bitmap awesome = new Bitmap(_whack);
    awesome.x = evt.stageX - _whack.width / 2;
    awesome.y = evt.stageY - _whack.height / 2;
    
    stage.addChild(awesome);
    
    new Timer(new Duration(milliseconds : 300), () => stage.removeChild(awesome));
//    new Timer(new Duration(milliseconds : 400), () => addChild(new Bitmap(_meng)));
    
    print("meng clicked");
  }
}