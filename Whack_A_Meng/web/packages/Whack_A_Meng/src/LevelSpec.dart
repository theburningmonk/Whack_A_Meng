part of whack_a_meng;

class LevelSpec {
  int columns;
  int rows;

  int target;       // min score (number of Mengs whacked!)
  int timeLimit;    // time limit (in seconds) to complete the mission

  num spawnTime;    // num of seconds meng will spawn in (smaller = faster)
  num retreatTime;  // num of seconds meng will retreat in (smaller = faster)
  num stayTime;     // num of seconds meng will stay in the open for

  int maxConcurrentNpc; // the number of NPCs that can visit at the same time
  num npcSpawnProb;     // probability (0.0 - 1.0) of a NPC visiting on each frame

  String tutorialName;  // name of the tutorial screen
}