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
    stroke(in.isOn ? 255 : 150);
    PVector[] surfacePoints = surfacePoint(in.cx(), in.cy(), out.cx(), out.cy(), in.w/2);
    line(surfacePoints[0].x, surfacePoints[0].y, surfacePoints[1].x, surfacePoints[1].y);
    //line(in.cx(), in.cy(), out.cx(), out.cy());
  }


  PVector[] surfacePoint(int x1, int y1, int x2, int y2, int r) {
    float d = dist(x1, y1, x2, y2);
    float dx = (x2-x1)*r/d;
    float dy = (y2-y1)*r/d;
    PVector p1 = new PVector(x1 + dx, y1 + dy);
    PVector p2 = new PVector(x2 - dx, y2 - dy);
    return new PVector[]{p1, p2};
  }

  void tick() {
    if (in.parent == null && !objects.contains(in)) {
      objectsToDestroy.add(this);
      in = null;
    }
    if (out.parent == null && !objects.contains(out)) {
      objectsToDestroy.add(this);
      out = null;
    }
    if (in != null && out != null) {
      out.setOn(in.isOn);
    } else {
      objectsToDestroy.add(this);
      out.setOn(false);
    }
  }
}
