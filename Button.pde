
class Button extends UIObj {

  String label;
  LoadedGateInfo info;

  Button(int x, int y, String label) {
    super(x, y, 40 * label.length(), 100, false, false);
    this.label = label;
  }
  
  Button(int x, int y, String label, LoadedGateInfo info) {
    super(x, y, 40 * label.length(), 100, false, false);
    this.label = label;
    this.info = info;
  }

  void show() {
    fill(200);
    stroke(0);
    textAlign(CENTER, CENTER);
    textSize(40);
    rect(x, y, w, h);
    fill(0);
    text(label, x+w/2, y+h/2);
  }

  void subClick(int mx, int my) {
    try {
      switch (label) {
      case "test":
        testMethod();
      case "Save":
        saveLayout();
      default:
        instantiateGate(mx, my);
      //case "test":
      //  testMethod();
      //case "test":
      //  testMethod();
      }
    } 
    catch (Exception e) {
      println("failed");
    }
  }
  
  void instantiateGate(int mx, int my) {
    placing = new LoadedGate(mx, my, info);
    objectsToSpawn.add(placing);
  }
  
  void testMethod() {
    println("ran");
  }
}
