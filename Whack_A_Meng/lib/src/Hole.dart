part of whack_a_meng;

class Hole extends Sprite {
  ResourceManager _resourceManager;
  
  Hole(this._resourceManager) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("hole"));
    addChild(background);
  }  
}