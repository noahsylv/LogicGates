import java.util.concurrent.Callable;
ArrayList<UIObj> objects = new ArrayList();
ArrayList<UIObj> objectsToSpawn = new ArrayList();
ArrayList<UIObj> objectsToDestroy = new ArrayList();
ArrayList<LoadedGateInfo> gateBlueprints = new ArrayList();
boolean showing = true;
boolean simulating = true;
UIObj placing = null;

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
  // buttons 
  loadGates();
  objects.add(new Button(width/2 - 200, height * 7 / 8, "Save"));
  objects.add(new Button(width/2 + 200, height * 7 / 8, "AND", gateBlueprints.get(0)));
  // TODO: remaining buttons
  //placing = new LoadedGate(width/2, height/2, gateBlueprints.get(0));
  //objects.add(placing);
}

void draw() {
  background(0);
  for (UIObj o : objects) {
    fill(255);
    stroke(255);
    strokeWeight(3);
    o.handleAll(showing, simulating);
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
  // place any placing object
  if (placing != null) {
    placing.place();
  }
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

// --- saving and loading
void saveLayout() {
  // TODO
  println("save");
}
void loadGates() {
  String[] lines = loadStrings("gates.txt");
  int linesInRemainingGates = 0;
  String currentGateName = null;
  int numInputs = 0;
  int numOutputs = 0;
  HashMap<Integer, Integer> truthTable = null;
  for (int i = 0; i < lines.length; i++) {
    String[] parts = lines[i].split(" ");
    // skip empty line
    if (parts.length == 1) continue;
    if (linesInRemainingGates == 0) {
      // load result
      if (currentGateName != null) {
        gateBlueprints.add(new LoadedGateInfo(currentGateName, numInputs, numOutputs, truthTable));
      }
      // process first line
      currentGateName = parts[0];
      numInputs = Integer.parseInt(parts[1]);
      numOutputs = Integer.parseInt(parts[2]);
      truthTable = new HashMap();
      linesInRemainingGates = power(2, numInputs);
      continue;
    }
    // process other lines
    int[] input = new int[numInputs];
    int[] output = new int[numOutputs];
    for (int j = 0; j < numInputs; j++) {
      input[j] = Integer.parseInt(parts[j]);
    }
    for (int j = 0; j < numOutputs; j++) {
      output[j] = Integer.parseInt(parts[j + numInputs]);
    }
    truthTable.put(binaryToDecimal(input), binaryToDecimal(output));
    linesInRemainingGates--;
  }
}

// --- helpers
int power(int base, int exp) {
  int out = 1;
  for (int i = 0; i < exp; i++) {
    out *= base;
  }
  return out;
}

int binaryToDecimal(int[] bits) {
  int total = 0;
  for (int i = 0; i < bits.length; i++) {
    int bit = bits[bits.length - i - 1];
    total += bit * power(2, i);
  }
  return total;
}

int[] decimalToBinary(int n, int digits) {
  int[] binary = new int[digits];
  int idx = 0;
  while (n != 0) {
    binary[idx] = n%2;
    idx++;
    n /= 2;
  }
  // reverse order
  int[] out = new int[digits];
  for (int i = 0; i < out.length; i++) {
    out[i] = binary[binary.length - 1 - i];
  }
  return out;
}
