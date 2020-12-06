class LoadedGate extends Gate {

  HashMap<Integer, Integer> truthTable;

  LoadedGate(int x, int y, LoadedGateInfo info) {
    super(x, y, info.name, info.numInputs, info.numOutputs);
    this.truthTable = info.truthTable;
    this.click(mouseX, mouseY);
    this.isDragged = true;
  }

  int[] evaluate(int[] inputBits) {
    int n = binaryToDecimal(inputBits);
    return decimalToBinary(truthTable.get(n), numOutputs());
  }
  
  void place() {
    isDragged = false;
    selected = false;
  }
}
