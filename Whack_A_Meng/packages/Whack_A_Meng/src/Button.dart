part of whack_a_meng;

class Button extends Sprite {
  Bitmap _normal;
  Bitmap _hover;
  Bitmap _down;

  Button(this._normal, this._hover, this._down) {
    onMouseOver.listen(_onMouseOver);
    onMouseOut.listen(_onMouseOut);
    onMouseDown.listen(_onMouseDown);

    addChild(_normal);
  }

  _onMouseOver(_) {
    removeChildren(0);
    addChild(_hover);
  }

  _onMouseOut(_) {
    removeChildren(0);
    addChild(_normal);
  }

  _onMouseDown(_) {
    removeChildren(0);
    addChild(_down);
  }
}