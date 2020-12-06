class Saver {

  String filename;
  // current save
  String name;
  HashMap<Integer, Integer> truthTable;
  int progress;
  boolean saving;

  Saver(String filename) {
    this.filename = filename;
    this.saving = false;
  }
  void startSave(String name) {
    if (name.equals("")) {
      name = "UNTITLED" + frameCount;
    }
    this.name = name;
    showing = false;
    saving = true;
    progress = 0;
    truthTable = new HashMap();
  }
  void startOfFrame() {
    if (!saving || bitFlip) return;
    int[] desiredInputs = decimalToBinary(progress, numInputs);
    for (int i = 0; i < desiredInputs.length; i++) {
      inputs.get(i).setOn(desiredInputs[i] == 1);
    }
  }
  void endOfFrame() {
    if (!saving || bitFlip) return;
    int[] observedOutputs = new int[outputs.size()];
    for (int i = 0; i < observedOutputs.length; i++) {
      observedOutputs[i] = outputs.get(i).isOn ? 1 : 0;
    }
    truthTable.put(progress, binaryToDecimal(observedOutputs));
    if (++progress >= power(2, inputs.size())) {
      completeSave();
    }
  }
  void completeSave() {
    // write to file
    showing = true;
    saving = false;
    File f = new File(dataPath(filename));
    try {
      PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
      out.println(name + " " + inputs.size() + " " + outputs.size());
      for (int i = 0; i < power(2, inputs.size()); i++) {
        String line = "";
        for (Integer j : decimalToBinary(i, inputs.size())) {
          line += j;
          line += " ";
        }
        Integer result = truthTable.get(i);
        int[] outBits = decimalToBinary(result, outputs.size());
        for (int j = 0; j < outBits.length; j++) {
          line += outBits[j];
          if (j < outBits.length - 1) line += " ";
        }
        out.println(line);
      }
      out.close();
      loadButtons();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}
