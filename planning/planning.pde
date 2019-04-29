PRM prm = new PRM();

void setup() {
  size(600, 600);
  
  
  //prm.aStarSearch();
  prm.dfs(prm.startId);
  prm.createAgentPath(prm.goalId);
  println(prm.agent.path);
  //prm.printNodeInfo();
}

void draw() {
  background(25);
  prm.drawGraph();
  prm.drawObstacles();
}
