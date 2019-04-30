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
    float posX = 0, posY = 0, dist, curDist;
    boolean validNode;
    for (int i = 0; i < ITER; i++) {
      // make random node
      validNode = false;
      //if (random(0, 1) > 0.95) {
      //  posX = gPos.x;
      //  posY = gPos.y;
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
      nodes.get(minId).adj.add(nodes.get(nodes.size()-1).id);
    }
  }
  
  void createObstacles() {
    while(obstacles.size() < MAX_OBS) {
      obstacles.add(new Entity(random(sPos.x, gPos.x), random(sPos.y, gPos.y), random(MIN_OBS_RADIUS, MAX_OBS_RADIUS)));
    }
  }
 
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
        if (agent.path.contains(i) && agent.path.contains(id)) {
          strokeWeight(3);
          stroke(0, 180, 0);
        } else {
          strokeWeight(1);
          stroke(255, 128);
        }
        line(nodes.get(i).pos.x, nodes.get(i).pos.y,
          nodes.get(id).pos.x, nodes.get(id).pos.y);
      }
    }
  }
  
  PVector sPos;  // starting node position
 
  PVector gPos;  // goal node position
  int startId, goalId;
  
  Agent agent;
  ArrayList<Node> nodes;
  ArrayList<Entity> obstacles;
}
