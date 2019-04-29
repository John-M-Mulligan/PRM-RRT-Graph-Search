import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.Stack;

final int MAX_NODES = 70;
final int MAX_EDGE_LENGTH = 400;
final int MAX_OBS = 3;
final int MIN_OBS_RADIUS = 10;
final int MAX_OBS_RADIUS = 25;

class PRM {
  PRM() {
    // Initialize nodes and specify start/goal positions
    nodes = new ArrayList<Node>();
    sPos = new PVector(50, 50);
    gPos = new PVector(550, 550);
    
    // Initialize agent properties
    agent = new Agent(sPos.x, sPos.y, 12.5);
    
    // Create obstacles
    obstacles = new ArrayList<Entity>();
    createObstacles();
    
    // Create the PRM in 2 steps:
    // 1) Create nodes in random (but valid) locations
    // 2) Create valid edges between nodes that don't
    createNodes();
    createEdges();
  }
  
  void createObstacles() {
    while(obstacles.size() < MAX_OBS) {
      obstacles.add(new Entity(random(sPos.x, gPos.x), random(sPos.y, gPos.y), random(MIN_OBS_RADIUS, MAX_OBS_RADIUS)));
    }
  }
  
  void createNodes() {
    // add starting position to the node list
    nodes.add(new Node(nodes.size(), sPos.x, sPos.y));
    nodes.get(nodes.size()-1).g = 0;
    
    float posX, posY, dist;
    while(nodes.size() < MAX_NODES - 1) {
      posX = random(sPos.x, gPos.x);
      posY = random(sPos.y, gPos.y);
      for (Entity o : obstacles) {
        dist = dist(posX, posY, o.pos.x, o.pos.y);
        if (dist > o.radius + agent.radius) {
          nodes.add(new Node(nodes.size(), posX, posY));
        }
      }
    }
    
    // add goal position to the node list
    nodes.add(new Node(nodes.size(), gPos.x, gPos.y));
   
    startId = 0;
    goalId = nodes.size()-1;
  }
  
  void createEdges() {
    for (int i = 0; i < nodes.size(); i++) {
      for (int j = 0; j < nodes.size(); j++) {
        float dist = nodes.get(i).calcNodeDistance(nodes.get(j));
        if (i != j && dist < MAX_EDGE_LENGTH && validPath(i, j)) {
          nodes.get(i).adj.add(j);
        }
      }
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
          agent.bfsPath.add(temp.pop());
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
      println("Total cost: " + n.f);
      println("Adj: " + n.adj);
      println("==========");
    }
  }
  
  void drawGraph() {
    int id;
    for (int i = 0; i < nodes.size(); i++) {
      for (int j = 0; j < nodes.get(i).adj.size(); j++) {
        id = nodes.get(i).adj.get(j);
        if (agent.dfsPath.contains(i) && agent.dfsPath.contains(id)) {
          strokeWeight(3);
          stroke(0, 180, 0);
        } else if (agent.bfsPath.contains(i) && agent.bfsPath.contains(id)){
          strokeWeight(3);
          stroke(180, 0, 0);
        } else if (agent.aStarPath.contains(i) && agent.aStarPath.contains(id)){
          strokeWeight(3);
          stroke(0, 0, 180);
        } else {
          strokeWeight(1);
          stroke(255, 128);
        }
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
  
  // SEARCH
  void aStarSearch() {
    // initalize open and closed list
    ArrayList<Node> closedList = new ArrayList<Node>();
    PriorityQueue<Node> openList = new PriorityQueue<Node>( 
      new Comparator<Node>(){
      //override compare method
        public int compare(Node i, Node j){
          if(i.f > j.f){
            return 1;
          } else if (i.f < j.f) {
            return -1;
          } else { 
            return 0;
          }
        }
      });
  
    // place the starting node into open, with inital cost of 0
    nodes.get(startId).f = 0;
    openList.add(nodes.get(startId));
    
    while (!openList.isEmpty()) {
      // grab the node with the smallest f value
      Node current = openList.poll();
      
      if (current.id == goalId) {
        return;
      }
      
      // add the expanded node to the closed list
      closedList.add(current);
      
      // for each neighbor of the current node
      for (Integer i : current.adj) {
        Node neighbor = nodes.get(i);
        if (closedList.contains(neighbor)) {
          continue;  // ignore neighbor that has already been expanded
        }
        
        // calculate the g value for each neighbor
        float temp_g = current.g + current.calcNodeDistance(neighbor);
        
        // if the neighbor is not in the open set
        if (!openList.contains(neighbor)) {
          openList.add(neighbor);
        } else if (temp_g >= neighbor.g) {
          continue;
        }
        
        // record the best path, parent ID and g/f values
        neighbor.parentId = current.id;
        neighbor.g = temp_g;
        neighbor.calcF(nodes.get(goalId));
      }
    }
  }
  
  // Recursive DFS
  public void dfs(int currentId)
  {
    
    if (currentId == goalId) {
      return;
    }
    
    Node node = nodes.get(currentId);
    node.visited=true;
    for (int i = 0; i < node.adj.size(); i++) {
      Node n = nodes.get(node.adj.get(i));
      if(n != null && !n.visited) {
        n.parentId = currentId;
        dfs(n.id);
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
