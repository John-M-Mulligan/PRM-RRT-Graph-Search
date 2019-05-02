ArrayList obstacles = new ArrayList<Entity>();
PRM prm;
RRT rrt;

void setup() {
  size(600, 600);
  
  // Creating a list of obstacles to be used for both PRM and RRT
  while(obstacles.size() < MAX_OBS) {
    obstacles.add(new Entity(random(SPOS_X, GPOS_X), random(SPOS_Y, GPOS_Y), random(MIN_OBS_RADIUS, MAX_OBS_RADIUS)));
  }
  
  ArrayList dfsAvgPathLength = new ArrayList<Float>();
  ArrayList ucAvgPathLength = new ArrayList<Float>();
  ArrayList aStarAvgPathLength = new ArrayList<Float>();
  
  ArrayList dfsAvgRuntime = new ArrayList<Float>();
  ArrayList ucAvgRuntime = new ArrayList<Float>();
  ArrayList aStarAvgRuntime = new ArrayList<Float>();
  
  float dfsPathLength = 0;
  float ucPathLength = 0;
  float aStarPathLength = 0;
  
  float dfsRuntime = 0;
  float ucRuntime = 0;
  float aStarRuntime = 0;
  
  /*
  float maxDfsPathLength = 0.0;
  float minDfsPathLength = 0.0;
  float maxUCPathLength = 0.0;
  float minUCPathLength = 0.0;
  float maxAStarPathLength = 0.0;
  float minAStarPathLength = 0.0;
  */
  
  float pathLength = 0;
  long startTime, endTime;
  
  for (int j = 0; j < NUM_ITERATIONS; j++) {
      prm = new PRM(obstacles);
          
      // Run and time dfs path
      /*startTime = System.nanoTime();
      prm.dfs(prm.startId);
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 0);
      dfsAvgRuntime.add((float)((float)(endTime - startTime) / 1000));*/
      
      // Run and time uc path
      startTime = System.nanoTime();
      prm.uniformCost();
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 3);
      ucAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
      // Run and time a* path
      /*startTime = System.nanoTime();
      prm.aStarSearch();
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 2);
      aStarAvgRuntime.add((float)((float)(endTime - startTime) / 1000));*/

      // Calculate length of dfs path
      /*pathLength = 0;
      for (int i = 1; i < prm.agent.dfsPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.dfsPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.dfsPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.dfsPath.get(i)).pos.x, prm.nodes.get(prm.agent.dfsPath.get(i)).pos.y);
      }
      dfsAvgPathLength.add(pathLength);*/
      
      // Calculate length of uc path
      pathLength = 0;
      for (int i = 1; i < prm.agent.ucPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.ucPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.ucPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.ucPath.get(i)).pos.x, prm.nodes.get(prm.agent.ucPath.get(i)).pos.y);
      }
      ucAvgPathLength.add(pathLength);
    
      println(prm.agent.ucPath);
    
      // Calculate length of aStar path
      /*pathLength = 0;
      for (int i = 1; i < prm.agent.aStarPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.aStarPath.get(i)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i)).pos.y);
      }
      aStarAvgPathLength.add(pathLength);*/
      
      //prm.agent.dfsPath.clear();
      prm.agent.ucPath.clear();
      //prm.agent.aStarPath.clear();
  }
  
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    //dfsPathLength = dfsPathLength + (float)dfsAvgPathLength.get(i);
    ucPathLength = ucPathLength + (float)ucAvgPathLength.get(i);
    //aStarPathLength = aStarPathLength + (float)aStarAvgPathLength.get(i); 
    
    //dfsRuntime = dfsRuntime + (float)dfsAvgRuntime.get(i);
    ucRuntime = ucRuntime + (float)ucAvgRuntime.get(i);
    //aStarRuntime = aStarRuntime + (float)aStarAvgRuntime.get(i);
  }
  //println("PRM Avg DFS Path Length: ", dfsPathLength/NUM_ITERATIONS);
  println("PRM Avg UC Path Length: ", ucPathLength/NUM_ITERATIONS);
  //println("PRM Avg A Star Path Length: ", aStarPathLength/NUM_ITERATIONS);
  println();
  //println("PRM Avg DFS Runtime: ", dfsRuntime/NUM_ITERATIONS);
  println("PRM Avg UC Runtime: ", ucRuntime/NUM_ITERATIONS);
  //println("PRM Avg A Star Runtime: ", aStarRuntime/NUM_ITERATIONS);
  println();
  
  /***********************************************************************/
  // RRT
  /***********************************************************************/
  /*
  dfsAvgPathLength.clear();
  ucAvgPathLength.clear();
  aStarAvgPathLength.clear();
  
  dfsAvgRuntime.clear();
  ucAvgRuntime.clear();
  aStarAvgRuntime.clear();
  
  dfsPathLength = 0;
  ucPathLength = 0;
  aStarPathLength = 0;
  
  dfsRuntime = 0;
  ucRuntime = 0;
  aStarRuntime = 0;
  
    for (int j = 0; j < NUM_ITERATIONS; j++) {
      rrt = new RRT(obstacles);
    
      // Run and time dfs path
      startTime = System.nanoTime();
      rrt.dfs(rrt.startId);
      endTime = System.nanoTime();
      rrt.createAgentPath(rrt.goalId, 0);
      dfsAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
      // Run and time uc path
      startTime = System.nanoTime();
      rrt.uniformCost();
      endTime = System.nanoTime();
      rrt.createAgentPath(rrt.goalId, 3);
      ucAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
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
      
      dfsAvgPathLength.add(pathLength);
      
      // Calculate length of uc path
      pathLength = 0;
      for (int i = 1; i < rrt.agent.ucPath.size(); i++) {
        pathLength += dist(rrt.nodes.get(rrt.agent.ucPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.ucPath.get(i - 1)).pos.y, 
             rrt.nodes.get(rrt.agent.ucPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.ucPath.get(i)).pos.y);
      }     
      ucAvgPathLength.add(pathLength);
      
      // Calculate length of aStar path
      pathLength = 0;
      for (int i = 1; i < rrt.agent.aStarPath.size(); i++) {
        pathLength += dist(rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.y, 
             rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.y);
      }
      aStarAvgPathLength.add(pathLength);
      
      rrt.agent.dfsPath.clear();
      rrt.agent.ucPath.clear();
      rrt.agent.aStarPath.clear();   
  }
  
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    dfsPathLength = dfsPathLength + (float)dfsAvgPathLength.get(i);
    ucPathLength = ucPathLength + (float)ucAvgPathLength.get(i);
    aStarPathLength = aStarPathLength + (float)aStarAvgPathLength.get(i); 
    
    dfsRuntime = dfsRuntime + (float)dfsAvgRuntime.get(i);
    ucRuntime = ucRuntime + (float)ucAvgRuntime.get(i);
    aStarRuntime = aStarRuntime + (float)aStarAvgRuntime.get(i);    
  }
  
  println("RRT Avg DFS Path Length: ", dfsPathLength/NUM_ITERATIONS);
  println("RRT Avg UC Path Length: ", ucPathLength/NUM_ITERATIONS);
  println("RRT Avg A Star Path Length: ", aStarPathLength/NUM_ITERATIONS);
  println();
  println("RRT Avg DFS Runtime: ", dfsRuntime/NUM_ITERATIONS);
  println("RRT Avg UC Runtime: ", ucRuntime/NUM_ITERATIONS);
  println("RRT Avg A Star Runtime: ", aStarRuntime/NUM_ITERATIONS);  
  */
}

void draw() {
  //background(25);
  //prm.drawGraph();
  //prm.drawObstacles();
  //rrt.drawGraph();
  //rrt.drawObstacles();
}
