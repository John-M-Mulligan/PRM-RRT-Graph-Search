class RRT {
  RRT(ArrayList<Entity> o) {
    // Initialize nodes and specify start/goal positions
    nodes = new ArrayList<Node>();
    
    // Initialize agent properties
    agent = new Agent(SPOS_X, SPOS_Y, AGENT_RADIUS);
    
    // Create obstacles
    obstacles = new ArrayList<Entity>();
    obstacles.addAll(o);
    
    // create starting node
    nodes = new ArrayList<Node>();
    nodes.add(new Node (nodes.size(), SPOS_X, SPOS_Y));
    // start making RRT
    Node rand;
    float posX = 0, posY = 0, dist;
    boolean validNode;
    for (int i = 0; i < ITER; i++) {
      // make random node
      validNode = false;
      //if (random(0, 1) > 0.8) {
        //posX = GPOS_X;
        //posY = GPOS_Y;
      //} else {
        while (!validNode) {
          posX = random(SPOS_X+DELTA, GPOS_X-DELTA);
          posY = random(SPOS_Y+DELTA, GPOS_Y-DELTA);
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
    nodes.add(new Node(nodes.size(), GPOS_X, GPOS_Y));
    
    // set start and goal ID's
    startId = 0;
    goalId = nodes.size()-1;
    
    //createEdges();
    
    // add edge from closest node to goal to the actual goal node
    float minDist = Float.POSITIVE_INFINITY;
    float curDist;
    int minId = -1;
    for (Node n : nodes) {
      curDist = dist(n.pos.x, n.pos.y, GPOS_X, GPOS_Y);
      if (n.id != goalId && curDist < minDist) {
        minDist = curDist;
        minId = n.id;
      }      
    }
    nodes.get(minId).adj.add(goalId);
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
  
  int startId, goalId;
  
  Agent agent;
  ArrayList<Node> nodes;
  ArrayList<Entity> obstacles;
}
