import 'dart:async';
import 'dart:math';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import '../lib/whack_a_meng.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

Bitmap _loadingBitmap;
Tween _loadingBitmapTween;
TextField _loadingTextField;

void main() {
  stage = new Stage("Stage", html.query('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  resourceManager = new ResourceManager();

  BitmapData.load("images/LOADING.png").then((bitmapData) {

    _loadingBitmap = new Bitmap(bitmapData)
      ..pivotX = 20
      ..pivotY = 20
      ..x      = 400
      ..y      = 270;
    stage.addChild(_loadingBitmap);

    _loadingTextField = new TextField()
      ..defaultTextFormat = new TextFormat("Arial", 20, 0xA0A0A0, bold:true)
      ..width  = 240
      ..height = 40
      ..text   = "... loading ...";
    _loadingTextField
      ..x      = 400 - _loadingTextField.textWidth / 2
      ..y      = 320
      ..mouseEnabled = false;
    stage.addChild(_loadingTextField);

    _loadingBitmapTween = new Tween(_loadingBitmap, 100, TransitionFunction.linear)
      ..animate.rotation.to(100.0 * 2.0 * PI);
    renderLoop.juggler.add(_loadingBitmapTween);

    loadResources();
  });
}

void loadResources() {
  Future<List<String>> tileTypes = new Future.value([ "arctic", "arid", "sand", "snow", "spooky", "temperate", "tropical" ]);
  LevelSpec lvl1 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 3
    ..timeLimit   = 10
    ..spawnTime   = 3.0
    ..retreatTime = 0.2
    ..stayTime    = 5.0
    ..maxConcurrentNpc = 0 // no NPCs for this level
    ..npcSpawnProb     = 0.01
    ..tutorialName     = "tutorial_play";

  LevelSpec lvl2 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 5
    ..timeLimit   = 15
    ..spawnTime   = 3.0
    ..retreatTime = 0.2
    ..stayTime    = 4.0
    ..maxConcurrentNpc = 0 // no npc for this level
    ..npcSpawnProb     = 0.01;

  LevelSpec lvl3 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 8
    ..timeLimit   = 20
    ..spawnTime   = 2.5
    ..retreatTime = 0.2
    ..stayTime    = 3.5
    ..maxConcurrentNpc = 1
    ..npcSpawnProb     = 0.01
    ..tutorialName     = "tutorial_npc";

  LevelSpec lvl4 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 12
    ..timeLimit   = 25
    ..spawnTime   = 2.25
    ..retreatTime = 0.2
    ..stayTime    = 3.25
    ..maxConcurrentNpc = 1
    ..npcSpawnProb     = 0.01;

  LevelSpec lvl5 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 16
    ..timeLimit   = 30
    ..spawnTime   = 2.0
    ..retreatTime = 0.2
    ..stayTime    = 3.0
    ..maxConcurrentNpc = 2
    ..npcSpawnProb     = 0.01;

  LevelSpec lvl6 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 20
    ..timeLimit   = 35
    ..spawnTime   = 2.0
    ..retreatTime = 0.2
    ..stayTime    = 3.0
    ..maxConcurrentNpc = 2
    ..npcSpawnProb     = 0.01;

  LevelSpec lvl7 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 24
    ..timeLimit   = 38
    ..spawnTime   = 1.8
    ..retreatTime = 0.2
    ..stayTime    = 2.8
    ..maxConcurrentNpc = 2
    ..npcSpawnProb     = 0.02;

  LevelSpec lvl8 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 29
    ..timeLimit   = 44
    ..spawnTime   = 1.6
    ..retreatTime = 0.2
    ..stayTime    = 2.6
    ..maxConcurrentNpc = 3
    ..npcSpawnProb     = 0.018;

  LevelSpec lvl9 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 35
    ..timeLimit   = 49
    ..spawnTime   = 1.4
    ..retreatTime = 0.2
    ..stayTime    = 2.4
    ..maxConcurrentNpc = 3
    ..npcSpawnProb     = 0.025;

  LevelSpec lvl10 = new LevelSpec()
    ..columns     = 3
    ..rows        = 3
    ..target      = 40
    ..timeLimit   = 50
    ..spawnTime   = 1.2
    ..retreatTime = 0.2
    ..stayTime    = 2.2
    ..maxConcurrentNpc = 3
    ..npcSpawnProb     = 0.03;

  var levelSpecs = [ lvl1, lvl2, lvl3, lvl4, lvl5, lvl6, lvl7, lvl8, lvl9, lvl10 ];

  resourceManager = new ResourceManager()

    // character headshots
    ..addBitmapData("bashak", "images/BASHAK.png")
    ..addBitmapData("meng",   "images/MENG.png")

    // NPCs
    ..addBitmapData("gnome",            "images/MARKETPLACE_MONSTER_GNOME.png")
    ..addBitmapData("goblin",           "images/MARKETPLACE_MONSTER_GOBLIN_GARDEN.png")
    ..addBitmapData("gui",              "images/MARKETPLACE_MONSTER_GUI.png")
    ..addBitmapData("taotie",           "images/MARKETPLACE_MONSTER_TAOTIE.png")
    ..addBitmapData("yeti",             "images/MARKETPLACE_MONSTER_YETI.png")
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
    ..addBitmapData("arctic_plain",     "images/TILE_ARCTIC_PLAIN.png")
    ..addBitmapData("arctic_river",     "images/TILE_ARCTIC_RIVER.png")
    ..addBitmapData("arid_plain",       "images/TILE_ARID_PLAIN.png")
    ..addBitmapData("arid_river",       "images/TILE_ARID_RIVER.png")
    ..addBitmapData("sand_plain",       "images/TILE_SAND_PLAIN.png")
    ..addBitmapData("sand_river",       "images/TILE_SAND_RIVER.png")
    ..addBitmapData("snow_plain",       "images/TILE_SNOW_PLAIN.png")
    ..addBitmapData("snow_river",       "images/TILE_SNOW_RIVER.png")
    ..addBitmapData("spooky_plain",     "images/TILE_SPOOKY_PLAIN.png")
    ..addBitmapData("spooky_river",     "images/TILE_SPOOKY_RIVER.png")
    ..addBitmapData("temperate_plain",  "images/TILE_TEMPERATE_PLAIN.png")
    ..addBitmapData("temperate_river",  "images/TILE_TEMPERATE_RIVER.png")
    ..addBitmapData("tropical_plain",   "images/TILE_TROPICAL_PLAIN.png")
    ..addBitmapData("tropical_river",   "images/TILE_TROPICAL_RIVER.png")
    ..addCustomObject("tile_types",     tileTypes)

    // welcome screen
    ..addBitmapData("welcome",          "images/WELCOME.png")
    ..addBitmapData("start",            "images/START.png")
    ..addBitmapData("start_hover",      "images/START_HOVER.png")
    ..addBitmapData("start_click",      "images/START_DOWN.png")

    // timeout screen
    ..addBitmapData("timeout",          "images/TIME_OUT.png")
    ..addBitmapData("retry",            "images/RETRY.png")
    ..addBitmapData("retry_hover",      "images/RETRY_HOVER.png")
    ..addBitmapData("retry_click",      "images/RETRY_DOWN.png")
    ..addBitmapData("timeout_gnome_overlay",          "images/TIME_OUT_GNOME_OVERLAY.png")
    ..addBitmapData("timeout_gui_overlay",            "images/TIME_OUT_GUI_OVERLAY.png")
    ..addBitmapData("timeout_meng_overlay",           "images/TIME_OUT_MENG_OVERLAY.png")
    ..addBitmapData("timeout_mermaid_red_overlay",    "images/TIME_OUT_MERMAID_RED_OVERLAY.png")
    ..addBitmapData("timeout_selkie_violet_overlay",  "images/TIME_OUT_SELKIE_VIOLET_OVERLAY.png")
    ..addBitmapData("timeout_vege_lamb_overlay",      "images/TIME_OUT_VEGE_LAMB_OVERLAY.png")
    ..addBitmapData("timeout_yeti_overlay",           "images/TIME_OUT_YETI_OVERLAY.png")

    // well done screen
    ..addBitmapData("win",              "images/WIN.png")
    ..addBitmapData("continue",         "images/CONTINUE.png")
    ..addBitmapData("continue_hover",   "images/CONTINUE_HOVER.png")
    ..addBitmapData("continue_click",   "images/CONTINUE_DOWN.png")
    ..addBitmapData("win_gnome_overlay",              "images/WIN_GNOME_OVERLAY.png")
    ..addBitmapData("win_gui_overlay",                "images/WIN_GUI_OVERLAY.png")
    ..addBitmapData("win_meng_overlay",               "images/WIN_MENG_OVERLAY.png")
    ..addBitmapData("win_mermaid_red_overlay",        "images/WIN_MERMAID_RED_OVERLAY.png")
    ..addBitmapData("win_selkie_violet_overlay",      "images/WIN_SELKIE_VIOLET_OVERLAY.png")
    ..addBitmapData("win_vege_lamb_overlay",          "images/WIN_VEGE_LAMB_OVERLAY.png")
    ..addBitmapData("win_yeti_overlay",               "images/WIN_YETI_OVERLAY.png")

    // tutorials
    ..addBitmapData("tutorial_play",    "images/TUTORIAL_PLAY.png")
    ..addBitmapData("tutorial_npc",     "images/TUTORIAL_NPC.png")

    ..addBitmapData("hole",             "images/MARKETPLACE_ENV_HOLE_RABBIT.png")
    ..addBitmapData("hole_over",        "images/MARKETPLACE_ENV_HOLE_RABBIT_OVER.png")
    ..addBitmapData("hammer",           "images/HAMMER.png")
    ..addBitmapData("whack",            "images/WHACK.png")
    ..addBitmapData("great",            "images/GREAT.png")
    ..addBitmapData("awesome",          "images/AWESOME.png")
    ..addBitmapData("hey",              "images/HEY.png")
    ..addBitmapData("ouch",             "images/OUCH.png")
    ..addBitmapData("stop_it",          "images/STOP_IT.png")
    ..addBitmapData("sad_face",         "images/SAD_FACE.png")

    ..addBitmapData("clock_background", "images/CLOCK_BACKGROUND.png")
    ..addBitmapData("score_board",      "images/SCORE_BOARD.png")

    ..addBitmapData("start_level",        "images/START_LEVEL_BANNER.png")
    ..addBitmapData("start_level_ready",  "images/START_LEVEL_READY_OVERLAY.png")
    ..addBitmapData("start_level_go",     "images/START_LEVEL_GO_OVERLAY.png")

    ..addBitmapData("end_game", "images/END_GAME.png")

    // levels
    ..addCustomObject("level_specs", new Future.value(levelSpecs));

  resourceManager.load().then((_) {

    stage.removeChild(_loadingBitmap);
    stage.removeChild(_loadingTextField);
    renderLoop.juggler.remove(_loadingBitmapTween);

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