PRM prm = new PRM();

void setup() {
  size(600, 600);
  
  
  //prm.aStarSearch();
  prm.dfs(prm.startId);
  prm.createAgentPath(prm.goalId, 0);
  prm.bfs(prm.startId);
  prm.createAgentPath(prm.goalId, 1);
  prm.aStarSearch();
  prm.createAgentPath(prm.goalId, 2);
}

void draw() {
  background(25);
  prm.drawGraph();
  prm.drawObstacles();
}
