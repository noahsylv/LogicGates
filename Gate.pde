class Gate extends UIObj {
  String label;
  ArrayList<Bit> inputs, outputs;
  int bitOffset = 40;

  Gate(int x, int y, String label, int numInputs, int numOutputs) {
    super(x, y, 100 * label.length(), 90 * max(numInputs, numOutputs), true, false);
    this.label = label;
    this.inputs = new ArrayList();
    this.outputs = new ArrayList();

    // create plugs
    for (int i = 0; i < numInputs; i++) {
      int bitY = getY(i, numInputs);
      Bit b = new Bit(x + bitOffset, bitY, 50, false, false);
      inputs.add(b);
    }
    for (int i = 0; i < numOutputs; i++) {
      int bitY = getY(i, numOutputs);
      Bit b = new Bit(x + (w - bitOffset), bitY, 50, false, true);
      outputs.add(b);
    }
    addChildren(inputs);
    addChildren(outputs);
  }
  
  String toString() {
    return label + " GATE";
  }

  int getY(int i, int n) {
    return (int) (h * 1.0 / (n+1) * (i+1)) + y;
  }
  void show() {
    drawBoundingBox();
    textAlign(CENTER, CENTER);
    textSize(50);
    text(label, x+w/2, y+h/2);
  }

  // main evaluation function (will be overwritten)
  int[] evaluate(int[] inputBits) {
    // default is ALL
    int[] outputBits = new int[outputs.size()];
    boolean allOut = true;
    for (int bit : inputBits) {
      allOut = bit == 1 && allOut;
    }
    for (int i = 0; i < outputBits.length; i++) {
      outputBits[i] = allOut ? 1 : 0;
    }
    return outputBits;
  }

  void tick() {
    process();
  }

  void process() {
    int[] inputBits = new int[inputs.size()];
    int i = 0;
    for (Bit bit : inputs) {
      inputBits[i] = bit.isOn ? 1 : 0;
      i++;
    }
    int[] outputBits = evaluate(inputBits);
    i = 0;
    for (Bit bit : outputs) {
      bit.isOn = outputBits[i] == 1;
      i++;
    }
  }
}
