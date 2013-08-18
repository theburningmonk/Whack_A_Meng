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
    ..columns     = 3
    ..rows        = 3
    ..target      = 5
    ..timeLimit   = 10
    ..spawnTime   = 5.0
    ..retreatTime = 0.2
    ..stayTime    = 5.0
    ..maxConcurrentNpc = 2
    ..npcSpawnProb     = 0.01;

  LevelSpec lvl2 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 10
    ..timeLimit   = 20
    ..spawnTime   = 3.0
    ..retreatTime = 0.2
    ..stayTime    = 4.0
    ..maxConcurrentNpc = 2
    ..npcSpawnProb     = 0.01;

  resourceManager = new ResourceManager()

    // character headshots
    ..addBitmapData("bashak", "images/BASHAK.png")
    ..addBitmapData("meng",   "images/MENG.png")

    // NPCs
    ..addBitmapData("gnome",  "images/MARKETPLACE_MONSTER_GNOME.png")
    ..addBitmapData("goblin", "images/MARKETPLACE_MONSTER_GOBLIN_GARDEN.png")
    ..addBitmapData("gui",    "images/MARKETPLACE_MONSTER_GUI.png")
    ..addBitmapData("taotie", "images/MARKETPLACE_MONSTER_TAOTIE.png")
    ..addBitmapData("yeti",   "images/MARKETPLACE_MONSTER_YETI.png")
    ..addBitmapData("meng_npc",         "images/MARKETPLACE_MONSTER_MOGWAI.png")
    ..addBitmapData("drop_bear",        "images/MARKETPLACE_MONSTER_DROPBEAR.png")
    ..addBitmapData("mermaid_blonde",   "images/MARKETPLACE_MONSTER_MERMAID_BLONDE.png")
    ..addBitmapData("mermaid_red",      "images/MARKETPLACE_MONSTER_MERMAID_RED.png")
    ..addBitmapData("pixie_banksia",    "images/MARKETPLACE_MONSTER_PIXIE_BANKSIA.png")
    ..addBitmapData("pixie_dandelion",  "images/MARKETPLACE_MONSTER_PIXIE_DANDELION.png")
    ..addBitmapData("pixie_orchid",     "images/MARKETPLACE_MONSTER_PIXIE_ORCHID.png")
    ..addBitmapData("selkie_blonde",    "images/MARKETPLACE_MONSTER_SELKIE_BLONDE.png")
    ..addBitmapData("selkie_red",       "images/MARKETPLACE_MONSTER_SELKIE_RED.png")
    ..addBitmapData("selkie_violet",    "images/MARKETPLACE_MONSTER_SELKIE_VIOLET.png")
    ..addBitmapData("vege_lamb",        "images/MARKETPLACE_MONSTER_VEGETABLELAMB.png")

    // background tiles
    ..addBitmapData("arctic_plain", "images/TILE_ARCTIC_PLAIN.png")
    ..addBitmapData("arctic_river", "images/TILE_ARCTIC_RIVER.png")
    ..addBitmapData("arid_plain",   "images/TILE_ARID_PLAIN.png")
    ..addBitmapData("arid_river",   "images/TILE_ARID_RIVER.png")
    ..addBitmapData("sand_plain",   "images/TILE_SAND_PLAIN.png")
    ..addBitmapData("sand_river",   "images/TILE_SAND_RIVER.png")
    ..addBitmapData("snow_plain",   "images/TILE_SNOW_PLAIN.png")
    ..addBitmapData("snow_river",   "images/TILE_SNOW_RIVER.png")
    ..addBitmapData("spooky_plain", "images/TILE_SPOOKY_PLAIN.png")
    ..addBitmapData("spooky_river", "images/TILE_SPOOKY_RIVER.png")
    ..addBitmapData("temperate_plain",  "images/TILE_TEMPERATE_PLAIN.png")
    ..addBitmapData("temperate_river",  "images/TILE_TEMPERATE_RIVER.png")
    ..addBitmapData("tropical_plain",   "images/TILE_TROPICAL_PLAIN.png")
    ..addBitmapData("tropical_river",   "images/TILE_TROPICAL_RIVER.png")
    ..addCustomObject("tile_types", tileTypes)

    // welcome screen
    ..addBitmapData("welcome",      "images/WELCOME.png")
    ..addBitmapData("start",        "images/START.png")
    ..addBitmapData("start_hover",  "images/START_HOVER.png")
    ..addBitmapData("start_click",  "images/START_DOWN.png")

    // timeout screen
    ..addBitmapData("timeout",      "images/TIME_OUT.png")
    ..addBitmapData("retry",        "images/RETRY.png")
    ..addBitmapData("retry_hover",  "images/RETRY_HOVER.png")
    ..addBitmapData("retry_click",  "images/RETRY_DOWN.png")
    ..addBitmapData("timeout_gnome_overlay",          "images/TIME_OUT_GNOME_OVERLAY.png")
    ..addBitmapData("timeout_gui_overlay",            "images/TIME_OUT_GUI_OVERLAY.png")
    ..addBitmapData("timeout_meng_overlay",           "images/TIME_OUT_MENG_OVERLAY.png")
    ..addBitmapData("timeout_mermaid_red_overlay",    "images/TIME_OUT_MERMAID_RED_OVERLAY.png")
    ..addBitmapData("timeout_selkie_violet_overlay",  "images/TIME_OUT_SELKIE_VIOLET_OVERLAY.png")
    ..addBitmapData("timeout_vege_lamb_overlay",      "images/TIME_OUT_VEGE_LAMB_OVERLAY.png")
    ..addBitmapData("timeout_yeti_overlay",           "images/TIME_OUT_YETI_OVERLAY.png")

    // well done screen
    ..addBitmapData("win",            "images/WIN.png")
    ..addBitmapData("continue",       "images/CONTINUE.png")
    ..addBitmapData("continue_hover", "images/CONTINUE_HOVER.png")
    ..addBitmapData("continue_click", "images/CONTINUE_DOWN.png")
    ..addBitmapData("win_gnome_overlay",              "images/WIN_GNOME_OVERLAY.png")
    ..addBitmapData("win_gui_overlay",                "images/WIN_GUI_OVERLAY.png")
    ..addBitmapData("win_meng_overlay",               "images/WIN_MENG_OVERLAY.png")
    ..addBitmapData("win_mermaid_red_overlay",        "images/WIN_MERMAID_RED_OVERLAY.png")
    ..addBitmapData("win_selkie_violet_overlay",      "images/WIN_SELKIE_VIOLET_OVERLAY.png")
    ..addBitmapData("win_vege_lamb_overlay",          "images/WIN_VEGE_LAMB_OVERLAY.png")
    ..addBitmapData("win_yeti_overlay",               "images/WIN_YETI_OVERLAY.png")

    ..addBitmapData("hole",         "images/MARKETPLACE_ENV_HOLE_RABBIT.png")
    ..addBitmapData("hole_over",    "images/MARKETPLACE_ENV_HOLE_RABBIT_OVER.png")
    ..addBitmapData("hammer",       "images/HAMMER.png")
    ..addBitmapData("whack",        "images/WHACK.png")
    ..addBitmapData("great",        "images/GREAT.png")
    ..addBitmapData("awesome",      "images/AWESOME.png")
    ..addBitmapData("ouch",         "images/OUCH.png")
    ..addBitmapData("wood_sign",    "images/WOOD_SIGN.png")

    ..addBitmapData("clock_background", "images/CLOCK_BACKGROUND.png")
    ..addBitmapData("score_board",      "images/SCORE_BOARD.png")

    // levels
    ..addCustomObject("level_1_spec", new Future.value(lvl1))
    ..addCustomObject("level_2_spec", new Future.value(lvl2));

  resourceManager.load().then((_) {

    stage.removeChild(loadingBitmap);
    stage.removeChild(loadingTextField);
    renderLoop.juggler.remove(loadingBitmapTween);

    WelcomeScreen welcome = new WelcomeScreen(resourceManager);
    stage.addChild(welcome);

    welcome.onRemovedFromStage.listen((_) {
      Game game = new Game(resourceManager);
      stage.addChild(game);
    });
  }).catchError((error) {
    for(var resource in resourceManager.failedResources) {
      print("Loading resouce failed: ${resource.kind}.${resource.name} - ${resource.error}");
    }
  });
}