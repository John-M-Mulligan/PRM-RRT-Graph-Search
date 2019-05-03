ArrayList obstacles = new ArrayList<Entity>();
PRM prm;
RRT rrt;

void setup() {
  size(600, 600);
  
  // Creating a list of obstacles to be used for both PRM and RRT
  while(obstacles.size() < MAX_OBS) {
    obstacles.add(new Entity(random(SPOS_X+100, GPOS_X-100), random(SPOS_Y+100, GPOS_Y-100), random(MIN_OBS_RADIUS, MAX_OBS_RADIUS)));
  }
  
  ArrayList dfsAvgPathLength = new ArrayList<Float>();
  ArrayList ucAvgPathLength = new ArrayList<Float>();
  ArrayList aStarAvgPathLength = new ArrayList<Float>();
  
  ArrayList dfsAvgNumNodes = new ArrayList<Integer>();
  ArrayList ucAvgNumNodes = new ArrayList<Integer>();
  ArrayList aStarAvgNumNodes = new ArrayList<Integer>();
  
  ArrayList dfsAvgRuntime = new ArrayList<Float>();
  ArrayList ucAvgRuntime = new ArrayList<Float>();
  ArrayList aStarAvgRuntime = new ArrayList<Float>();
  
  float dfsPathLength = 0;
  float ucPathLength = 0;
  float aStarPathLength = 0;
  
  int dfsNumNodes = 0;
  int ucNumNodes = 0;
  int aStarNumNodes = 0;
  
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
  long startTime = 0, endTime = 0;
  
  for (int j = 0; j < NUM_ITERATIONS; j++) {
      prm = new PRM(obstacles);
          
      // Run and time dfs path
      startTime = System.nanoTime();
      prm.dfs(prm.startId);
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 0);
      dfsAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
      // Run and time uc path
      startTime = System.nanoTime();
      prm.uniformCost();
      endTime = System.nanoTime();
      prm.createAgentPath(prm.goalId, 3);
      ucAvgRuntime.add((float)((float)(endTime - startTime) / 1000));
      
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
      dfsAvgPathLength.add(pathLength);
      dfsAvgNumNodes.add(prm.agent.dfsPath.size());
      
      // Calculate length of uc path
      pathLength = 0;
      for (int i = 1; i < prm.agent.ucPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.ucPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.ucPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.ucPath.get(i)).pos.x, prm.nodes.get(prm.agent.ucPath.get(i)).pos.y);
      }
      ucAvgPathLength.add(pathLength);
      ucAvgNumNodes.add(prm.agent.ucPath.size());
      
      // Calculate length of aStar path
      pathLength = 0;
      for (int i = 1; i < prm.agent.aStarPath.size(); i++) {
        pathLength += dist(prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i - 1)).pos.y, 
             prm.nodes.get(prm.agent.aStarPath.get(i)).pos.x, prm.nodes.get(prm.agent.aStarPath.get(i)).pos.y);
      }
      aStarAvgPathLength.add(pathLength);
      aStarAvgNumNodes.add(prm.agent.aStarPath.size());
      
      prm.agent.dfsPath.clear();
      prm.agent.ucPath.clear();
      prm.agent.aStarPath.clear();
  }
  
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    dfsPathLength = dfsPathLength + (float)dfsAvgPathLength.get(i);
    ucPathLength = ucPathLength + (float)ucAvgPathLength.get(i);
    aStarPathLength = aStarPathLength + (float)aStarAvgPathLength.get(i); 
    
    dfsRuntime = dfsRuntime + (float)dfsAvgRuntime.get(i);
    ucRuntime = ucRuntime + (float)ucAvgRuntime.get(i);
    aStarRuntime = aStarRuntime + (float)aStarAvgRuntime.get(i);
    
    dfsNumNodes = dfsNumNodes + (int)dfsAvgNumNodes.get(i);
    ucNumNodes = ucNumNodes + (int)ucAvgNumNodes.get(i);
    aStarNumNodes = aStarNumNodes + (int)aStarAvgNumNodes.get(i);
  }
  
  println("PRM Avg DFS Path Length: ", dfsPathLength/NUM_ITERATIONS);
  println("PRM Avg UC Path Length: ", ucPathLength/NUM_ITERATIONS);
  println("PRM Avg A Star Path Length: ", aStarPathLength/NUM_ITERATIONS);
  println();
  println("PRM Avg DFS Runtime: ", dfsRuntime/NUM_ITERATIONS);
  println("PRM Avg UC Runtime: ", ucRuntime/NUM_ITERATIONS);
  println("PRM Avg A Star Runtime: ", aStarRuntime/NUM_ITERATIONS);
  println();
  println("RRT Avg DFS Num Nodes: ", (float)dfsNumNodes/NUM_ITERATIONS);
  println("RRT Avg UC Num Nodes: ", (float)ucNumNodes/NUM_ITERATIONS);
  println("RRT Avg A Star Num Nodes: ", (float)aStarNumNodes/NUM_ITERATIONS);
  println();
  
  /***********************************************************************/
  // RRT
  /***********************************************************************/
  
  dfsAvgPathLength.clear();
  ucAvgPathLength.clear();
  aStarAvgPathLength.clear();
  
  dfsAvgNumNodes.clear();
  ucAvgNumNodes.clear();
  aStarAvgNumNodes.clear();

  dfsAvgRuntime.clear();
  ucAvgRuntime.clear();
  aStarAvgRuntime.clear();
  
  dfsPathLength = 0;
  ucPathLength = 0;
  aStarPathLength = 0;
  
  dfsNumNodes = 0;
  ucNumNodes = 0;
  aStarNumNodes = 0;
  
  dfsRuntime = 0;
  ucRuntime = 0;
  aStarRuntime = 0;
  
    for (int j = 0; j < NUM_ITERATIONS; j++) {
      rrt = new RRT(obstacles);
    
      // Run and time dfs path
      while (!(rrt.agent.dfsPath.contains(rrt.goalId) && rrt.agent.dfsPath.contains(rrt.startId))) {
        rrt = new RRT(obstacles);
        startTime = System.nanoTime();
        rrt.dfs(rrt.startId);
        endTime = System.nanoTime();
        rrt.createAgentPath(rrt.goalId, 0);
      }
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
      dfsAvgNumNodes.add(rrt.agent.dfsPath.size());
      
      // Calculate length of uc path
      pathLength = 0;
      for (int i = 1; i < rrt.agent.ucPath.size(); i++) {
        pathLength += dist(rrt.nodes.get(rrt.agent.ucPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.ucPath.get(i - 1)).pos.y, 
             rrt.nodes.get(rrt.agent.ucPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.ucPath.get(i)).pos.y);
      }     
      ucAvgPathLength.add(pathLength);
      ucAvgNumNodes.add(rrt.agent.ucPath.size());
      
      // Calculate length of aStar path
      pathLength = 0;
      for (int i = 1; i < rrt.agent.aStarPath.size(); i++) {
        pathLength += dist(rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i - 1)).pos.y, 
             rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.x, rrt.nodes.get(rrt.agent.aStarPath.get(i)).pos.y);
      }
      aStarAvgPathLength.add(pathLength);
      aStarAvgNumNodes.add(rrt.agent.aStarPath.size());
      
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
    
    dfsNumNodes = dfsNumNodes + (int)dfsAvgNumNodes.get(i);
    ucNumNodes = ucNumNodes + (int)ucAvgNumNodes.get(i);
    aStarNumNodes = aStarNumNodes + (int)aStarAvgNumNodes.get(i);
  }
  
  println("RRT Avg DFS Path Length: ", dfsPathLength/NUM_ITERATIONS);
  println("RRT Avg UC Path Length: ", ucPathLength/NUM_ITERATIONS);
  println("RRT Avg A Star Path Length: ", aStarPathLength/NUM_ITERATIONS);
  println();
  println("RRT Avg DFS Runtime: ", dfsRuntime/NUM_ITERATIONS);
  println("RRT Avg UC Runtime: ", ucRuntime/NUM_ITERATIONS);
  println("RRT Avg A Star Runtime: ", aStarRuntime/NUM_ITERATIONS);
  println();
  println("RRT Avg DFS Num Nodes: ", (float)dfsNumNodes/NUM_ITERATIONS);
  println("RRT Avg UC Num Nodes: ", (float)ucNumNodes/NUM_ITERATIONS);
  println("RRT Avg A Star Num Nodes: ", (float)aStarNumNodes/NUM_ITERATIONS);
}

int mode = 1;
void draw() {
  background(25);
  if (mode == 1) {
    prm.drawGraph();
    prm.drawObstacles();
  }
  if (mode == 2) {
    rrt.drawGraph();
    rrt.drawObstacles();
  }
}

void keyPressed() {
  if (key == '1') {
    mode = 1;
  }
  if (key == '2') {
    mode = 2;
  }
}
