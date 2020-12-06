class Bit extends UIObj {
  boolean isOn;
  boolean canControl;
  boolean isOutType;
  Wire inWire;
  ArrayList<Wire> outWires;
  Bit(int x, int y, int r, boolean canControl, boolean isOutType) {
    super(x - r/2, y - r/2, r, r, false, false);
    this.isOn = false;
    this.canControl = canControl;
    this.isOutType = isOutType;
    outWires = new ArrayList<Wire>();
  }
  void show() {
    if (this == selectedBit) drawBoundingBox();
    stroke(255);
    fill(isOn ? 255 : 0);
    ellipse(cx(), cy(), w, h);
  }
  void subClick() {
    if (canControl) isOn = !isOn;
    if (selectedBit == null) {
      selectedBit = this;
    }
    // handle selected bit
    else if (selectedBit != null && selectedBit != this) {
      Bit in = selectedBit;
      Bit out = this;
      // swap order if necessary
      if (!in.isOutType && out.isOutType) {
        Bit tmp = in;
        in = out;
        out = tmp;
      }
      // make sure can connect
      if (in.isOutType != out.isOutType) {
        if (!(in.parent == out.parent && in.parent != null)) {
          objectsToSpawn.add(new Wire(in, out));
        }
      }
    } else if (selectedBit == null) {
      selectedBit = this;
    }
  }
}
