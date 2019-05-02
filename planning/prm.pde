import java.util.PriorityQueue;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.Set;
import java.util.HashSet;
import java.util.Comparator;
import java.util.Stack;

class PRM {
  PRM(ArrayList<Entity> o) {
    // Initialize nodes and specify start/goal positions
    nodes = new ArrayList<Node>();
    
    // Initialize// agent properties
    agent = new Agent(SPOS_X, SPOS_Y, AGENT_RADIUS);
    
    // Create obstacles
    obstacles = new ArrayList<Entity>();
   
  obstacles.addAll(o);   
    // Create the PRM in 2 steps:
    // 1) Create nodes in random (but valid) locations
    // 2) Create valid edges between nodes that don't
    createNodes();
    createEdges();
  }
  
  void createNodes() {
    // add starting position to the node list
    nodes.add(new Node(nodes.size(), SPOS_X, SPOS_Y));
    nodes.get(nodes.size()-1).g = 0;
    
    float posX, posY, dist;
    while(nodes.size() < MAX_NODES - 2) {
      posX = random(SPOS_X, GPOS_X);
      posY = random(SPOS_Y, GPOS_Y);
      for (Entity o : obstacles) {
        dist = dist(posX, posY, o.pos.x, o.pos.y);
        if (dist > o.radius + agent.radius) {
          nodes.add(new Node(nodes.size(), posX, posY));
        }
      }
    }
    
    // add goal position to the node list
    nodes.add(new Node(nodes.size(), GPOS_X, GPOS_Y));
   
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
      //println(id);
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
    } else if (searchType == 2){
      while (!temp.empty()) {
        agent.aStarPath.add(temp.pop());
      }// end while
    } else {
      while (!temp.empty()) {
        agent.ucPath.add(temp.pop());
      }
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
        } /*else if (agent.bfsPath.contains(i) && agent.bfsPath.contains(id)){
          strokeWeight(1);
          stroke(255, 128);
        } */else if (agent.aStarPath.contains(i) && agent.aStarPath.contains(id)){
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
 public void aStarSearch(){
    Set<Node> explored = new HashSet<Node>();
    PriorityQueue<Node> queue = new PriorityQueue<Node>(20, 
            new Comparator<Node>() {
              //override compare method
             public int compare(Node i, Node j){
                if(i.f > j.f){
                    return 1;
                } else if (i.f < j.f){
                    return -1;
                } else {
                    return 0;
                } // end else
             } // end compare
            } // end comparator
    );
  
    //cost from start
    nodes.get(startId).g = 0;
    queue.add(nodes.get(startId));
    boolean found = false;
  
    while((!queue.isEmpty()) && (!found)){
  
            //the node in having the lowest f_score value
            Node current = queue.poll();
  
            explored.add(current);
  
            //goal found
            if(current.id == goalId){
                    found = true;
            } // end if
  
            //check every child of current node
            for(int e : current.adj){                        
                    Node child = nodes.get(e);
                    float cost = dist(current.pos.x, current.pos.y, child.pos.x, child.pos.y);
                    float temp_g_scores = current.g + cost;
                    float temp_f_scores = temp_g_scores + child.h;
  
  
                    /*if child node has been evaluated and 
                    the newer f_score is higher, skip*/
                    
                    if((explored.contains(child)) && 
                            (temp_f_scores >= child.f)){
                            continue;
                    } // end if
  
                    /*else if child node is not in queue or 
                    newer f_score is lower*/
                    
                    else if((!queue.contains(child)) || 
                            (temp_f_scores < child.f)){
  
                            child.parentId = current.id;
                            child.g = temp_g_scores;
                            child.f = temp_f_scores;
  
                            if(queue.contains(child)) {
                                    queue.remove(child);
                            } // end if
                            queue.add(child);
                    }// end else if
            } // end for
    } // end while
} // end A star    

  
  // Recursive DFS
  public void dfs(int currentId) {
    
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
  
  // prints BFS traversal from a given source s 
  void bfs(int currentId) { 
    // Mark all the vertices as not visited(By default 
    // set as false) 
    boolean visited[] = new boolean[nodes.size()]; 

    // Create a queue for BFS 
    LinkedList<Integer> queue = new LinkedList<Integer>(); 

    // Mark the current node as visited and enqueue it 
    visited[currentId]=true; 
    queue.add(currentId); 
    int parent = -1;

    while (queue.size() != 0) 
    { 
        // Dequeue a vertex from queue and print it
        
        currentId = queue.poll(); 
        nodes.get(currentId).parentId = parent;
        if (currentId == goalId) {
          return;
        }
        
        // Get all adjacent vertices of the dequeued vertex s 
        // If a adjacent has not been visited, then mark it 
        // visited and enqueue it 
        for (int i = 0; i < nodes.get(currentId).adj.size(); i++) {
          if (!visited[nodes.get(currentId).adj.get(i)]) { 
            visited[nodes.get(currentId).adj.get(i)] = true; 
            queue.add(nodes.get(currentId).adj.get(i)); 
          } 
        }
        parent = currentId;
    } 
  }
  
  void uniformCost() {
    nodes.get(startId).f = 0;
    PriorityQueue<Node> q = new PriorityQueue<Node>(nodes.size(),
      new Comparator<Node>() {
        // override compare method
        public int compare(Node i, Node j) {
          if (i.f > j.f) {
            return 1;
          } else if (i.f < j.f) {
            return -1;
          } else {
            return 0;
          }
        }
      }
    );
  
    q.add(nodes.get(startId));
    Set<Node> explored = new HashSet<Node>();
    //boolean found = false;
    
    // while frontier is not empty
    do {
      Node current = q.poll();
      explored.add(current);
      
      //if (current.id == goalId) {
      //  found = true;
      //}
      
      for (int i : current.adj) {
        Node neighbor = nodes.get(i);
        neighbor.f = current.f + dist(neighbor.pos.x, neighbor.pos.y, current.pos.x, current.pos.y);
        
        if (!explored.contains(neighbor) && !q.contains(neighbor)) {
          neighbor.parentId = current.id;
          q.add(neighbor);
          
          //println(neighbor.id);
          //println(q);
        } else if (q.contains(neighbor) && neighbor.f > current.f) {
          neighbor.parentId = current.id;
          
          // next two calls decrease the key of the node in the queue
          q.remove(neighbor);
          q.add(neighbor);
        }
      }
    } while (!q.isEmpty());
  }
  
  int startId, goalId;
  
  Agent agent;
  ArrayList<Node> nodes;
  ArrayList<Entity> obstacles;
}
