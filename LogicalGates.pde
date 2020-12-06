ArrayList<UIObj> objects = new ArrayList();
ArrayList<UIObj> objectsToSpawn = new ArrayList();
ArrayList<UIObj> objectsToDestroy = new ArrayList();


Bit selectedBit = null;
void setup() {
  size(2000, 1000);
  // TODO: below should be generated based on # inputs, # outputs
  // input side
  objects.add(new Bit(width/10, height/2 - 100, 50, true, true));
  objects.add(new Bit(width/10, height/2 + 100, 50, true, true));
  // output side
  objects.add(new Bit(width - width/10, height/2 + 100, 50, false, false));
  // other
  objects.add(new And(width/2 - 250, height/2));
  objects.add(new Not(width/2 + 150, height/2));
}

void draw() {
  background(0);
  for (UIObj o : objects) {
    fill(255);
    stroke(255);
    strokeWeight(3);
    o.handleAll();
  }
  for (UIObj o : objectsToSpawn) {
    objects.add(o);
  }
  for (UIObj o : objectsToDestroy) {
    objects.remove(o);
  }
  objectsToSpawn.clear();
}

// --- controls
void mousePressed() {
  boolean hasSelectedBit = selectedBit != null;
  for (UIObj o : objects) {  
    o.click(mouseX, mouseY);
  }
  // clear any selected bit
  if (hasSelectedBit) {
    selectedBit = null;
  }
}

void mouseDragged() {
  for (UIObj o : objects) {
    o.drag(mouseX, mouseY);
  }
}

void mouseReleased() {
  for (UIObj o : objects) {
    o.release();
  }
}
