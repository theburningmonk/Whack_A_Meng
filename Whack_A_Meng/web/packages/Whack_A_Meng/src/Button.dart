part of whack_a_meng;

class Button extends Sprite {
  Bitmap _normal;
  Bitmap _hover;
  Bitmap _down;
  
  Button(this._normal, this._hover, this._down) {
    this.onMouseOver.listen(_onMouseOver);
    this.onMouseOut.listen(_onMouseOut);
    this.onMouseDown.listen(_onMouseDown);
    
    this.addChild(_normal);
  }
  
  _onMouseOver(_) {
    this.removeChildren(0);
    this.addChild(_hover);
  }
  
  _onMouseOut(_) {
    this.removeChildren(0);
    this.addChild(_normal);
  }
  
  _onMouseDown(_) {
    this.removeChildren(0);
    this.addChild(_down);
  }
}