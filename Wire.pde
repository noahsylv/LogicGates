class Wire extends UIObj {
  Bit in;
  Bit out;
  Wire() {
    super(0, 0, 10, 10, false, false);
  }
  Wire(UIObj in, UIObj out) {
    super(0, 0, 10, 10, false, false);
    if (in instanceof Bit) {
      this.in = (Bit) in;
    }
    if (out instanceof Bit) {
      this.out = (Bit) out;
    }
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
