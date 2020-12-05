class Bit extends UIObj {
  boolean isOn;
  boolean canControl;
  Bit(int x, int y, int r, boolean canControl) {
    super(x - r/2, y - r/2, r, r, false, false);
    this.isOn = false;
    this.canControl = canControl;
  }
  void show() {
    stroke(255);
    fill(isOn ? 255 : 0);
    ellipse(cx(), cy(), w, h);
  }
  void subClick() {
    if (canControl) isOn = !isOn;
  }
}
