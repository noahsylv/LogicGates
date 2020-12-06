class LoadedGateInfo {
  String name;
  int numInputs, numOutputs;
  HashMap<Integer, Integer> truthTable;
  LoadedGateInfo(String name, int numInputs, int numOutputs, HashMap<Integer, Integer> truthTable) {
    this.name = name;
    this.numInputs = numInputs;
    this.numOutputs = numOutputs;
    this.truthTable = truthTable;
  }
}
