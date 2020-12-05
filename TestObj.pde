class TestObj extends UIObj {
  class TestChildObj extends UIObj {
    int val;
    TestChildObj(int x, int y) {
      super(x - 150, y, 50, 50, false, false);
    }

    void subClick(int mx, int my) {
      val++;
    }
    void show() {
      fill(0, 100 + min(100,10*val), 100);
      rect(x, y, w, h);
    }
  }
  TestObj(int x, int y) {
    super(x, y, 100, 100, true, false);
    TestChildObj child = new TestChildObj(x, y);
    this.children.add(child);
  }

  void show() {
    fill(255);
    if (selected) fill(200, 0, 0);
    rect(x, y, w, h);
  }
}
