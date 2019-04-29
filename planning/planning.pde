PRM prm = new PRM();

void setup() {
  size(600, 600);
  
  prm.aStarSearch();
  prm.createAgentPath(prm.goalId);
  prm.printNodeInfo();
}

void draw() {
  background(25);
  prm.drawGraph();
  prm.drawObstacles();
}
