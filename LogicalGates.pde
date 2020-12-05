ArrayList<UIObj> objects = new ArrayList();
void setup() {
  size(2000, 1000);
  objects.add(new Bit(width/10, height/2 - 100, 50, true));
  objects.add(new Bit(width/10, height/2 + 100, 50, true));
  objects.add(new And(width/2 - 250, height/2));
  objects.add(new Not(width/2 + 150, height/2));
  objects.add(new Wire(objects.get(0), objects.get(2).children.get(0)));
  objects.add(new Wire(objects.get(1), objects.get(2).children.get(1)));
  objects.add(new Wire(objects.get(2).children.get(2), objects.get(3).children.get(0)));
}

void draw() {
  background(0);
  for (UIObj o : objects) {
    fill(255);
    stroke(255);
    strokeWeight(3);
    o.handleAll();
  }
}

// --- controls
void mousePressed() {
  for (UIObj o : objects) {  
    o.click(mouseX, mouseY);
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
