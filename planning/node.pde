// SEARCH
class Node {
  Node(int i) {
    id = i;
    //posX = 0;
    //posY = 0;
    pos = new PVector(0, 0);
    g = Float.POSITIVE_INFINITY;
    parentId = -1;
    adj = new ArrayList<Integer>();
  }
  Node(int i, float x, float y) {
    id = i;
    //posX = x;
    //posY = y;
    pos = new PVector(x, y);
    g = Float.POSITIVE_INFINITY;
    parentId = -1;
    adj = new ArrayList<Integer>();
  }
  Node(Node n) {
    id = n.id;
    //posX = n.posX;
    //posY = n.posY;
    pos = new PVector(n.pos.x, n.pos.y);
    g = n.g;
    parentId = n.parentId;
    h = n.h;
    adj = new ArrayList<Integer>(n.adj);
  }
  
  float calcNodeDistance(Node n) {
    return dist(pos.x, pos.y, n.pos.x, n.pos.y);
  }
  
  float calcEuclideanHeuristic(Node n) {
    return calcNodeDistance(n);
  }
  
  void calcF(Node n) {
    f = g + calcEuclideanHeuristic(n);
  }
  
  int id, parentId;
  PVector pos;
  float f, g, h;
  ArrayList<Integer> adj;
}
