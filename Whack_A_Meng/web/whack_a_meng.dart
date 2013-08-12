import 'dart:async';
import 'dart:math';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import '../lib/whack_a_meng.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

Bitmap loadingBitmap;
Tween loadingBitmapTween;
TextField loadingTextField;

void main() {
  stage = new Stage("Stage", html.query('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  resourceManager = new ResourceManager();

  BitmapData.load("images/LOADING.png").then((bitmapData) {

    loadingBitmap = new Bitmap(bitmapData);
    loadingBitmap.pivotX = 20;
    loadingBitmap.pivotY = 20;
    loadingBitmap.x = 400;
    loadingBitmap.y = 270;
    stage.addChild(loadingBitmap);

    loadingTextField = new TextField();
    loadingTextField.defaultTextFormat = new TextFormat("Arial", 20, 0xA0A0A0, bold:true);;
    loadingTextField.width = 240;
    loadingTextField.height = 40;
    loadingTextField.text = "... loading ...";
    loadingTextField.x = 400 - loadingTextField.textWidth / 2;
    loadingTextField.y = 320;
    loadingTextField.mouseEnabled = false;
    stage.addChild(loadingTextField);

    loadingBitmapTween = new Tween(loadingBitmap, 100, TransitionFunction.linear);
    loadingBitmapTween.animate.rotation.to(100.0 * 2.0 * PI);
    renderLoop.juggler.add(loadingBitmapTween);

    loadResources();
  });
}

void loadResources() {
  Future<List<String>> tileTypes = new Future.value([ "arctic", "arid", "sand", "snow", "spooky", "temperate", "tropical" ]);
  LevelSpec lvl1 = new LevelSpec()
                        ..columns = 3
                        ..rows = 3
                        ..minScore = 10
                        ..timeLimit = 30
                        ..duration = 3.0;
  
  var resourceManager = new ResourceManager()
  
      // character headshots
      ..addBitmapData("bashak", "images/BASHAK.png")
      ..addBitmapData("meng", "images/MENG.png")
      
      // background tiles
      ..addBitmapData("arctic_plain", "images/TILE_ARCTIC_PLAIN.png")
      ..addBitmapData("arctic_river", "images/TILE_ARCTIC_RIVER.png")
      ..addBitmapData("arid_plain", "images/TILE_ARID_PLAIN.png")
      ..addBitmapData("arid_river", "images/TILE_ARID_RIVER.png")
      ..addBitmapData("sand_plain", "images/TILE_SAND_PLAIN.png")
      ..addBitmapData("sand_river", "images/TILE_SAND_RIVER.png")
      ..addBitmapData("snow_plain", "images/TILE_SNOW_PLAIN.png")
      ..addBitmapData("snow_river", "images/TILE_SNOW_RIVER.png")
      ..addBitmapData("spooky_plain", "images/TILE_SPOOKY_PLAIN.png")
      ..addBitmapData("spooky_river", "images/TILE_SPOOKY_RIVER.png")
      ..addBitmapData("temperate_plain", "images/TILE_TEMPERATE_PLAIN.png")
      ..addBitmapData("temperate_river", "images/TILE_TEMPERATE_RIVER.png")
      ..addBitmapData("tropical_plain", "images/TILE_TROPICAL_PLAIN.png")
      ..addBitmapData("tropical_river", "images/TILE_TROPICAL_RIVER.png")
      ..addCustomObject("tile_types", tileTypes)
      
      // graphical assets
      ..addBitmapData("hole", "images/MARKETPLACE_ENV_HOLE_RABBIT.png")
      ..addBitmapData("hammer", "images/HAMMER.png")
      
      // levels
      ..addCustomObject("level_1_spec", new Future.value(lvl1));
  
  resourceManager.load().then((res) {

    stage.removeChild(loadingBitmap);
    stage.removeChild(loadingTextField);
    renderLoop.juggler.remove(loadingBitmapTween);
    
    Game game = new Game(resourceManager); 
    stage.addChild(game);
  }).catchError((error) {
    for(var resource in resourceManager.failedResources) {
      print("Loading resouce failed: ${resource.kind}.${resource.name} - ${resource.error}");
    }
  });
}