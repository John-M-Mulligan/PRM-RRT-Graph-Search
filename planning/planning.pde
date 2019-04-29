PRM prm = new PRM();

void setup() {
  size(600, 600);
  
  
  //prm.aStarSearch();
  prm.dfs(prm.startId);
  prm.createAgentPath(prm.goalId, 0);
  prm.aStarSearch();
  prm.createAgentPath(prm.goalId, 2);
  //prm.printNodeInfo();
}

void draw() {
  background(25);
  prm.drawGraph();
  prm.drawObstacles();
}
