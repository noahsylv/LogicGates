class Wire extends UIObj {
  Bit in;
  Bit out;
  Wire() {
    super(0, 0, 10, 10, false, false);
  }
  Wire(UIObj in, UIObj out) {
    super(0, 0, 10, 10, false, false);
    if (in instanceof Bit && out instanceof Bit) {
      this.in = (Bit) in;
      this.out = (Bit) out;
      handlePreviousBits();
    }
  }

  void handlePreviousBits() {
    // remove other wire going to out bit
    if (out.inWire != null) {
      objectsToDestroy.add(out.inWire);
    }
    out.inWire = this;
    // add to list of wires out of in bit
    in.outWires.add(this);
    
  }

  void show() {
    if (in != null && out != null) {
      stroke(in.isOn ? 255 : 150);
      line(in.cx(), in.cy(), out.cx(), out.cy());
    }
  }

  void tick() {
    if (in != null && out != null) out.isOn = in.isOn;
  }
}
