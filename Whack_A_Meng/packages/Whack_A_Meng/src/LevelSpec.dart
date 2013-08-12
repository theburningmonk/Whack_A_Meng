part of whack_a_meng;

class LevelSpec {
  int columns;
  int rows;
  
  int minScore;   // min score (number of Mengs whacked!)
  int timeLimit;  // time limit (in seconds) to complete the mission
  
  num duration;   // how long (in seconds) does Meng stay on screen
  num npcChance;  // probability (0.0 - 1.0) of a NPC showing up instead of meng
  
  List<String> npcs;  // NPCs that can show up in this level  
}