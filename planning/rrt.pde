//final int MAX_NODES = 7;
//final int MAX_EDGE_LENGTH = 40000;
//final int MAX_OBS = 1;
//final int MIN_OBS_RADIUS = 10;
//final int MAX_OBS_RADIUS = 25;
final int DELTA = 50;
final int ITER = 100;

class RRT {
  RRT() {
    // Initialize nodes and specify start/goal positions
    nodes = new ArrayList<Node>();
    sPos = new PVector(50, 50);
    gPos = new PVector(550, 550);
    
    // Initialize agent properties
    agent = new Agent(sPos.x, sPos.y, 12.5);
    
    // Create obstacles
    obstacles = new ArrayList<Entity>();
    createObstacles();
    
    // create starting node
    nodes = new ArrayList<Node>();
    nodes.add(new Node (nodes.size(), sPos.x, sPos.y));
    // start making RRT
    Node rand;
    float posX = 0, posY = 0, dist;
    boolean validNode;
    for (int i = 0; i < ITER; i++) {
      // make random node
      validNode = false;
      //if (random(0, 1) > 0.98) {
        //posX = gPos.x;
        //posY = gPos.y;
      //} else {
        while (!validNode) {
          posX = random(sPos.x+DELTA, gPos.x-DELTA);
          posY = random(sPos.y+DELTA, gPos.y-DELTA);
          for (int j = 0; !validNode && j < obstacles.size(); j++) {
            dist = dist(posX, posY, obstacles.get(j).pos.x, obstacles.get(j).pos.y);
            if (dist > obstacles.get(j).radius + agent.radius) {
              validNode = true;
            }
          }
        }
      //}
      rand = new Node(nodes.size(), posX, posY);
      
      // find node in graph nearest to random node
      int minId = -1;
      float curDist;
      float minDist = Float.POSITIVE_INFINITY;
      for (Node n : nodes) {
        curDist = dist(n.pos.x, n.pos.y, rand.pos.x, rand.pos.y);
        if (curDist < minDist) {
          minDist = curDist;
          minId = n.id;
        }
      }
      
      // create new node to add to graph based on the random node and the nearest node
      PVector dir = PVector.sub(rand.pos, nodes.get(minId).pos);
      dir.normalize().mult(DELTA);
      PVector newPos = PVector.add(nodes.get(minId).pos, dir);
      
      // add node to the graph
      nodes.add(new Node(nodes.size(), newPos.x, newPos.y));
      
      // add edge from nearest node to new node
      if (validPath(nodes.size()-1, minId)) {
        nodes.get(minId).adj.add(nodes.get(nodes.size()-1).id);
      }
    }
    
    // add goal node to the graph
    nodes.add(new Node(nodes.size(), gPos.x, gPos.y));
    
    // set start and goal ID's
    startId = 0;
    goalId = nodes.size()-1;
    
    // add edge from closest node to goal to the actual goal node
    float minDist = Float.POSITIVE_INFINITY;
    float curDist;
    int minId = -1;
    for (Node n : nodes) {
      curDist = dist(n.pos.x, n.pos.y, gPos.x, gPos.y);
      if (n.id != goalId && curDist < minDist) {
        minDist = curDist;
        minId = n.id;
      }      
    }
    println(minId);
    nodes.get(minId).adj.add(goalId);
  }
  
  void createObstacles() {
    while(obstacles.size() < MAX_OBS) {
      obstacles.add(new Entity(random(sPos.x, gPos.x), random(sPos.y, gPos.y), random(MIN_OBS_RADIUS, MAX_OBS_RADIUS)));
    }
  }
 
  // determines if a line crosses through an obstacle or not
  boolean validPath(int id1, int id2) {
    if (id1 == id2) {
      return false;
    }
    
    float dist;
    float distX = nodes.get(id2).pos.x - nodes.get(id1).pos.x;
    float distY = nodes.get(id2).pos.y - nodes.get(id1).pos.y;
    int numSamples = 200;
    
    for (Entity o : obstacles) {
      for (int i = 0; i < numSamples; i++) {
        dist = dist(
        nodes.get(id1).pos.x + distX * (float)i/numSamples,
        nodes.get(id1).pos.y + distY * (float)i/numSamples,
        o.pos.x, o.pos.y);
        if (dist < o.radius + agent.radius) {
          return false;
        }
      }
    }
    return true;
  }
 
  void createAgentPath(int goalId, int searchType) {
    Stack<Integer> temp = new Stack<Integer>();
    int id = goalId;
    while (id != -1) {
      temp.push(id);
      id = nodes.get(id).parentId;
    }// end while
    if (searchType == 0) {
      while (!temp.empty()) {
        agent.dfsPath.add(temp.pop());
      }// end while
    } else if (searchType == 1) {
      while (!temp.empty()) {
        agent.bfsPath.add(temp.pop());
      }// end while
    } else {
      while (!temp.empty()) {
        agent.aStarPath.add(temp.pop());
      }// end while
    }// end else
  }// end function 
 
  // DISPLAY
  void printNodeInfo() {
    for (int i = 0; i < nodes.size(); i++) {
      Node n = nodes.get(i);
      println("ID: " + n.id);
      println("Parent ID: " + n.parentId);
      println("Position: (" + n.pos.x + ", " + n.pos.y + ")");
      //println("Total cost: " + n.f);
      println("Adj: " + n.adj);
      println("==========");
    }
  }
  
  void drawGraph() {
    int id;
    for (int i = 0; i < nodes.size(); i++) {
      for (int j = 0; j < nodes.get(i).adj.size(); j++) {
        id = nodes.get(i).adj.get(j);
        /*if (agent.path.contains(i) && agent.path.contains(id)) {
          strokeWeight(3);
          stroke(0, 180, 0);
        } else {*/
          strokeWeight(1);
          stroke(255, 128);
        //}
        line(nodes.get(i).pos.x, nodes.get(i).pos.y,
          nodes.get(id).pos.x, nodes.get(id).pos.y);
      }
    }
  }
  
  void drawObstacles() {
    for (Entity o : obstacles) {
      //pushMatrix();
      noStroke();
      fill(0, 128, 255);
      circle(o.pos.x, o.pos.y, o.radius);
      //popMatrix();
    }
  }
  
  PVector sPos;  // starting node position
  PVector gPos;  // goal node position
  int startId, goalId;
  
  Agent agent;
  ArrayList<Node> nodes;
  ArrayList<Entity> obstacles;
}
