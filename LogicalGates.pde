import java.util.concurrent.Callable;
import java.io.BufferedWriter;
import java.io.FileWriter;

// object management
ArrayList<UIObj> objects = new ArrayList();
ArrayList<UIObj> objectsToSpawn = new ArrayList();
ArrayList<UIObj> objectsToDestroy = new ArrayList();
ArrayList<Bit> inputs;
ArrayList<Bit> outputs;
// in/out bits
int numInputs = 2;
int numOutputs = 1;
// gates
ArrayList<LoadedGateInfo> gateBlueprints = new ArrayList();
// current status
boolean showing = true;
boolean simulating = true;
boolean runDistributeButtons = false;
boolean bitFlip = false;
UIObj placing = null;
// save manager
Saver saver = new Saver("gates.txt");
Textfield namer;

Bit selectedBit = null;
void setup() {
  size(2000, 1000);
  // place inputs and outputs
  updateInputOutputs();
  // default buttons 
  loadButtons();
  namer = new Textfield(width/2, 50, 50, 80);
  objects.add(namer);
}

void draw() {
  background(0);
  bitFlip = false;
  saver.startOfFrame();
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
    for (UIObj child : o.children) {
      objects.remove(child);
    }
    objects.remove(o);
  }
  objectsToSpawn.clear();
  objectsToDestroy.clear();
  // late updates
  if (runDistributeButtons) {
    distributeButtons();
  }
  saver.endOfFrame();
}

// --- user controls
void mousePressed() {
  if (!showing) return;
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
  if (!showing) return;
  for (UIObj o : objects) {
    o.drag(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (!showing) return;
  for (UIObj o : objects) {
    o.release();
  }
}

void keyPressed() {
  if (!showing) return;
    for (UIObj o : objects) {
    o.keyPressed(key);
  }
}
// --- input/output management
void updateInputOutputs() {
  // clear current input/output bits
  for (UIObj o : objects) {
    if (o instanceof Bit) {
      Bit b = (Bit) o;
      if (b.isInput() || b.isOutput()) objectsToDestroy.add(b);
    }
  }
  inputs = new ArrayList();
  outputs = new ArrayList();
  // input side
  for (int i = 0; i < numInputs; i++) {
    int offset = i - (numInputs/2);
    Bit b = new Bit(width/10, height/2 + offset * 60, 50, true, true);
    inputs.add(b);
    objectsToSpawn.add(b);
  }
  // output side
  for (int i = 0; i < numOutputs; i++) {
    int offset = i - (numOutputs/2);
    Bit b = new Bit(width - width/10, height/2 + offset * 60, 50, true, false);
    outputs.add(b);
    objectsToSpawn.add(b);
  }
}
// --- button management
void loadButtons() {
  loadGates();
  for (UIObj o : objects) {
    if (o instanceof Button) {
      objectsToDestroy.add(o);
    }
  }
  objects.add(new Button(width/2 - 200, height * 7 / 8, "Save"));
  objects.add(new Button(width/2 - 300, height * 7 / 8, "Clear"));
  objects.add(new Button(width/2 - 300, height * 7 / 8, "+1 Input"));
  objects.add(new Button(width/2 - 300, height * 7 / 8, "-1 Input"));
  objects.add(new Button(width/2 - 300, height * 7 / 8, "+1 Output"));
  objects.add(new Button(width/2 - 300, height * 7 / 8, "-1 Output"));

  for (int i = 0; i < gateBlueprints.size(); i++) {
    objects.add(new Button(width/2 + 200 * i, height * 7 / 8, gateBlueprints.get(i)));
  }
  invokeDistributeButtons();
}
void invokeDistributeButtons() {
  runDistributeButtons = true;
}
void distributeButtons() {
  ArrayList<Button> buttons = new ArrayList();
  for (UIObj obj : objects) {
    if (obj instanceof Button) {
      buttons.add((Button) obj);
    }
  }
  int numButtons = buttons.size();
  for (int i = 0; i < numButtons; i++) {
    Button b = buttons.get(i);
    b.x = width / (numButtons + 1) * (i + 1) - b.w/2;
  }
  runDistributeButtons = false;
}

// --- saving and loading
void saveLayout() {
  saver.startSave(namer.text);
}
void clearLayout() {
  for (UIObj o : objects) {
    if (o instanceof Gate || o instanceof Wire) {
      objectsToDestroy.add(o);
    }
  }
}
void loadGates() {
  String[] lines = loadStrings("gates.txt");
  int linesInRemainingGates = -1;
  //boolean readyForNext = true;
  String currentGateName = null;
  int numInputs = 0;
  int numOutputs = 0;
  gateBlueprints.clear();
  HashMap<Integer, Integer> truthTable = null;
  for (int i = 0; i < lines.length; i++) {
    String[] parts = lines[i].split(" ");
    if (parts.length == 1) continue;
    if (linesInRemainingGates == -1) {
      // process first line
      currentGateName = parts[0];
      numInputs = Integer.parseInt(parts[1]);
      numOutputs = Integer.parseInt(parts[2]);
      truthTable = new HashMap();
      linesInRemainingGates = power(2, numInputs) - 1;
      continue;
    }
    // process truth table lines
    int[] input = new int[numInputs];
    int[] output = new int[numOutputs];
    for (int j = 0; j < numInputs; j++) {
      input[j] = Integer.parseInt(parts[j]);
    }
    for (int j = 0; j < numOutputs; j++) {
      output[j] = Integer.parseInt(parts[j + numInputs]);
    }
    truthTable.put(binaryToDecimal(input), binaryToDecimal(output));
    if (linesInRemainingGates == 0) {
      // load result
      if (currentGateName != null) {
        gateBlueprints.add(new LoadedGateInfo(currentGateName, numInputs, numOutputs, truthTable));
      }
    }
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
