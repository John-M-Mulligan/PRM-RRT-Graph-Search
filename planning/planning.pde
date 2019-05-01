PRM prm;
RRT rrt;

void setup() {
  size(600, 600); 
  
  ArrayList dfsAvgPathLength = new ArrayList<Float>();
  ArrayList bfsAvgPathLength = new ArrayList<Float>();
  ArrayList aStarAvgPathLength = new ArrayList<Float>();
  
  ArrayList dfsAvgRuntime = new ArrayList<Float>();
  ArrayList bfsAvgRuntime = new ArrayList<Float>();
  ArrayList aStarAvgRuntime = new ArrayList<Float>();
  
  float dfsPathLength = 0;
  float bfsPathLength = 0;
  float aStarPathLength = 0;
  
  float dfsRuntime = 0;
  float bfsRuntime = 0;
  float aStarRuntime = 0;
  
  /*
  float maxDfsPathLength = 0.0;
  float minDfsPathLength = 0.0;
  float maxBfsPathLength = 0.0;
  float minBfsPathLength = 0.0;
  float maxAStarPathLength = 0.0;
  float minAStarPathLength = 0.0;
  */
  
  float pathLength = 0;
  long startTime, endTime;
  
  /*for (int j = 0; j < NUM_ITERATIONS; j++) {
      prm = new PRM();
    
      // Run and time dfs path
      startTime = System.nanoTime();
      prm.dfs(prm.startId);
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 0);
      dfsAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
      // Run and time bfs path
      startTime = System.nanoTime();
      prm.bfs(prm.startId);
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 1);
      bfsAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
      // Run and time a* path
      startTime = System.nanoTime();
      prm.aStarSearch();
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 2);
      aStarAvgRuntime.add((float)((float)(endTime - startTime) / 1000));

      // Calculate length of dfs path
      pathLength = 0;
      for (int i = 1; i < prm.agent.dfsPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.dfsPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.dfsPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.dfsPath.get(i)).pos.x, prm.nodes.get(prm.agent.dfsPath.get(i)).pos.y);
      }
      //println("DFS Path length: ", pathLength);
      dfsAvgPathLength.add(pathLength);
      
      // Calculate length of bfs path
      pathLength = 0;
      for (int i = 1; i < prm.agent.bfsPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.bfsPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.bfsPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.bfsPath.get(i)).pos.x, prm.nodes.get(prm.agent.bfsPath.get(i)).pos.y);
      }
      bfsAvgPathLength.add(pathLength);
    
      // Calculate length of aStar path
      pathLength = 0;
      for (int i = 1; i < prm.agent.aStarPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.aStarPath.get(i)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i)).pos.y);
      }
      aStarAvgPathLength.add(pathLength);
      
      prm.agent.dfsPath.clear();
      prm.agent.bfsPath.clear();
      prm.agent.aStarPath.clear();
  }
  
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    dfsPathLength = dfsPathLength + (float)dfsAvgPathLength.get(i);
    bfsPathLength = bfsPathLength + (float)bfsAvgPathLength.get(i);
    aStarPathLength = aStarPathLength + (float)aStarAvgPathLength.get(i); 
    
    dfsRuntime = dfsRuntime + (float)dfsAvgRuntime.get(i);
    bfsRuntime = bfsRuntime + (float)bfsAvgRuntime.get(i);
    aStarRuntime = aStarRuntime + (float)aStarAvgRuntime.get(i);
  }
  println("PRM Avg DFS Path Length: ", dfsPathLength/NUM_ITERATIONS);
  println("PRM Avg BFS Path Length: ", bfsPathLength/NUM_ITERATIONS);
  println("PRM Avg A Star Path Length: ", aStarPathLength/NUM_ITERATIONS);
  println();
  println("PRM Avg DFS Runtime: ", dfsRuntime/NUM_ITERATIONS);
  println("PRM Avg BFS Runtime: ", bfsRuntime/NUM_ITERATIONS);
  println("PRM Avg A Star Runtime: ", aStarRuntime/NUM_ITERATIONS);
  println();*/
  
  /***********************************************************************/
  // RRT
  /***********************************************************************/
  
  dfsAvgPathLength.clear();
  bfsAvgPathLength.clear();
  aStarAvgPathLength.clear();
  
  dfsAvgRuntime.clear();
  bfsAvgRuntime.clear();
  aStarAvgRuntime.clear();
  
  dfsPathLength = 0;
  bfsPathLength = 0;
  aStarPathLength = 0;
  
  dfsRuntime = 0;
  bfsRuntime = 0;
  aStarRuntime = 0;
  
    for (int j = 0; j < NUM_ITERATIONS; j++) {
      rrt = new RRT();
    
      // Run and time dfs path
      startTime = System.nanoTime();
      rrt.dfs(rrt.startId);
      endTime = System.nanoTime();
      rrt.createAgentPath(rrt.goalId, 0);
      dfsAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
      // Run and time bfs path
      startTime = System.nanoTime();
      rrt.bfs(rrt.startId);
      endTime = System.nanoTime();
      rrt.createAgentPath(rrt.goalId, 1);
      bfsAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
      // Run and time a* path
      startTime = System.nanoTime();
      rrt.aStarSearch();
      endTime = System.nanoTime();
      rrt.createAgentPath(rrt.goalId, 2);
      aStarAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
    
      // Calculate length of dfs path
      pathLength = 0;
      for (int i = 1; i < rrt.agent.dfsPath.size(); i++) {
        pathLength += dist(rrt.nodes.get(rrt.agent.dfsPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.dfsPath.get(i - 1)).pos.y, 
             rrt.nodes.get(rrt.agent.dfsPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.dfsPath.get(i)).pos.y);
      }
      //println("DFS Path length: ", pathLength);
      dfsAvgPathLength.add(pathLength);
      
      // Calculate length of bfs path
      pathLength = 0;
      for (int i = 1; i < rrt.agent.bfsPath.size(); i++) {
        println(pathLength);
        pathLength += dist(rrt.nodes.get(rrt.agent.bfsPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.bfsPath.get(i - 1)).pos.y, 
             rrt.nodes.get(rrt.agent.bfsPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.bfsPath.get(i)).pos.y);
      }
      println(rrt.agent.bfsPath);
      println(rrt.agent.dfsPath);
      println(pathLength);
      bfsAvgPathLength.add(pathLength);
      rrt.printNodeInfo();
      
      // Calculate length of aStar path
      pathLength = 0;
      for (int i = 1; i < rrt.agent.aStarPath.size(); i++) {
        pathLength += dist(rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.y, 
             rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.y);
      }
      aStarAvgPathLength.add(pathLength);
      
      
      
      rrt.agent.dfsPath.clear();
      rrt.agent.bfsPath.clear();
      rrt.agent.aStarPath.clear();
      
  }
  
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    dfsPathLength = dfsPathLength + (float)dfsAvgPathLength.get(i);
    bfsPathLength = bfsPathLength + (float)bfsAvgPathLength.get(i);
    aStarPathLength = aStarPathLength + (float)aStarAvgPathLength.get(i); 
    
    dfsRuntime = dfsRuntime + (float)dfsAvgRuntime.get(i);
    bfsRuntime = bfsRuntime + (float)bfsAvgRuntime.get(i);
    aStarRuntime = aStarRuntime + (float)aStarAvgRuntime.get(i);
    
    //println("bfsAvgPathLength: ", (float)bfsAvgPathLength.get(i));
    
  }
  println("RRT Avg DFS Path Length: ", dfsPathLength/NUM_ITERATIONS);
  println("RRT Avg BFS Path Length: ", bfsPathLength/NUM_ITERATIONS);
  println("RRT Avg A Star Path Length: ", aStarPathLength/NUM_ITERATIONS);
  println();
  println("RRT Avg DFS Runtime: ", dfsRuntime/NUM_ITERATIONS);
  println("RRT Avg BFS Runtime: ", bfsRuntime/NUM_ITERATIONS);
  println("RRT Avg A Star Runtime: ", aStarRuntime/NUM_ITERATIONS);
}

void draw() {
  //background(25);
  //prm.drawGraph();
  //prm.drawObstacles();
  //rrt.drawGraph();
  //rrt.drawObstacles();
}
