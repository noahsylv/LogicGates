
class Button extends UIObj {

  String label;
  LoadedGateInfo info;

  Button(int x, int y, String label) {
    super(x, y, 30 + 17 * label.length(), 70, false, false);
    this.label = label;
  }

  Button(int x, int y, LoadedGateInfo info) {
    super(x, y, 30 + 17 * info.name.length(), 70, false, false);
    this.label = info.name;
    this.info = info;
  }

  void show() {
    fill(200);
    stroke(0);
    textAlign(CENTER, CENTER);
    textSize(30);
    rect(x, y, w, h);
    fill(0);
    text(label, x+w/2, y+h/2);
  }

  void subClick(int mx, int my) {
    try {
      switch (label) {
      case "test":
        testMethod();
        return;
      case "Save":
        saveLayout();
        return;
      case "Clear":
        clearLayout();
        return;
      case "+1 Input":
        numInputs++;
        updateInputOutputs();
        return;
      case "-1 Input":
        numInputs = max(1, numInputs - 1);
        updateInputOutputs();
        return;
      case "+1 Output":
        numOutputs++;
        updateInputOutputs();
        return;
      case "-1 Output":
        numOutputs = max(1, numOutputs - 1);
        updateInputOutputs();
        return;
      default:
        instantiateGate(mx, my);
        return;
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
