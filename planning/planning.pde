ArrayList obstacles = new ArrayList<Entity>();
PRM prm;
RRT rrt;

void setup() {
  size(600, 600);
  
  // Creating a list of obstacles to be used for both PRM and RRT
  while(obstacles.size() < MAX_OBS) {
    obstacles.add(new Entity(random(SPOS_X, GPOS_X), random(SPOS_Y, GPOS_Y), random(MIN_OBS_RADIUS, MAX_OBS_RADIUS)));
  }
  
  prm = new PRM(obstacles);
  rrt = new RRT(obstacles);
  
  /*
  // Run and time dfs path
  long startTime = System.nanoTime();
  prm.dfs(prm.startId);
  long endTime = System.nanoTime();
  prm.createAgentPath(prm.goalId, 0);
  println("DFS run-time: ", (float)((float)(endTime - startTime) / 1000000), "ms");
  
  // Run and time bfs path
  startTime = System.nanoTime();
  prm.bfs(prm.startId);
  endTime = System.nanoTime();
  prm.createAgentPath(prm.goalId, 1);
  println("BFS run-time: ", (float)((float)(endTime - startTime) / 1000000), "ms");
  
  // Run and time a* path
  startTime = System.nanoTime();
  prm.aStarSearch();
  endTime = System.nanoTime();
  prm.createAgentPath(prm.goalId, 2);
  println("A* run-time: ", (float)((float)(endTime - startTime) / 1000000), "ms");

  // Calculate length of dfs path
  float pathLength = 0;
  for (int i = 1; i < prm.agent.dfsPath.size(); i++) {
    pathLength += dist(prm.nodes.get(prm.agent.dfsPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.dfsPath.get(i - 1)).pos.y, 
         prm.nodes.get(prm.agent.dfsPath.get(i)).pos.x, prm.nodes.get(prm.agent.dfsPath.get(i)).pos.y);
  }
  println("DFS Path length: ", pathLength);
  
  // Calculate length of bfs path
  pathLength = 0;
  for (int i = 1; i < prm.agent.bfsPath.size(); i++) {
    pathLength += dist(prm.nodes.get(prm.agent.bfsPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.bfsPath.get(i - 1)).pos.y, 
         prm.nodes.get(prm.agent.bfsPath.get(i)).pos.x, prm.nodes.get(prm.agent.bfsPath.get(i)).pos.y);
  }
  println("BFS Path length: ", pathLength);

  // Calculate length of aStar path
  pathLength = 0;
  for (int i = 1; i < prm.agent.aStarPath.size(); i++) {
    pathLength += dist(prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.y, 
         prm.nodes.get(prm.agent.aStarPath.get(i)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i)).pos.y);
  }
  println("A* Path length: ", pathLength);
  */
  
  // Run and time dfs path
  long startTime = System.nanoTime();
  rrt.dfs(rrt.startId);
  long endTime = System.nanoTime();
  rrt.createAgentPath(rrt.goalId, 0);
  println("DFS run-time: ", (float)((float)(endTime - startTime) / 1000000), "ms");
  
  
  // Run and time bfs path
  startTime = System.nanoTime();
  rrt.bfs(rrt.startId);
  endTime = System.nanoTime();
  rrt.createAgentPath(rrt.goalId, 1);
  println("BFS run-time: ", (float)((float)(endTime - startTime) / 1000000), "ms");
  
  // Run and time a* path
  startTime = System.nanoTime();
  rrt.aStarSearch();
  endTime = System.nanoTime();
  rrt.createAgentPath(rrt.goalId, 2);
  println("A* run-time: ", (float)((float)(endTime - startTime) / 1000000), "ms");

  // Calculate length of dfs path
  float pathLength = 0;
  for (int i = 1; i < rrt.agent.dfsPath.size(); i++) {
    pathLength += dist(rrt.nodes.get(rrt.agent.dfsPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.dfsPath.get(i - 1)).pos.y, 
         rrt.nodes.get(rrt.agent.dfsPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.dfsPath.get(i)).pos.y);
  }
  println("DFS Path length: ", pathLength);
  
  // Calculate length of bfs path
  pathLength = 0;
  for (int i = 1; i < rrt.agent.bfsPath.size(); i++) {
    pathLength += dist(rrt.nodes.get(rrt.agent.bfsPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.bfsPath.get(i - 1)).pos.y, 
         rrt.nodes.get(rrt.agent.bfsPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.bfsPath.get(i)).pos.y);
  }
  println("BFS Path length: ", pathLength);

  // Calculate length of aStar path
  pathLength = 0;
  for (int i = 1; i < rrt.agent.aStarPath.size(); i++) {
    pathLength += dist(rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.y, 
         rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.y);
  }
  println("A* Path length: ", pathLength);
  
  
  // rrt.printNodeInfo();
  // println(rrt.agent.aStarPath);
}

void draw() {
  background(25);
  //prm.drawGraph();
  //prm.drawObstacles();
  rrt.drawGraph();
  rrt.drawObstacles();
}
