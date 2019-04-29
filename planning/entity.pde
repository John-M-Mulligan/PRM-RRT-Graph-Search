class Entity {
  Entity() {
    pos = new PVector(0, 0);
    radius = 10;
  }
  Entity(float x, float y) {
    pos = new PVector(x, y);
    radius = 10;
  }
  Entity(float x, float y, float r) {
    pos = new PVector(x, y);
    radius = r;
  }
  Entity(PVector v) {
    pos = new PVector(v.x, v.y);
    radius = 10;
  }
  Entity(PVector v, float r) {
    pos = new PVector(v.x, v.y);
    radius = r;
  }
  
  PVector pos;
  float radius;
}

class Agent extends Entity {
  Agent(float x, float y, float r) {
    path = new ArrayList<Integer>();
    pos = new PVector(x, y);
    radius = r;
  }
  
  ArrayList<Integer> path;
}
