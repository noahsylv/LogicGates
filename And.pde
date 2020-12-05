class And extends Gate {
  And(int x, int y) {
    super(x, y, "AND", 2, 1);
  }
  
  int[] evaluate(int[] inputBits) {
    boolean a = inputBits[0] == 1;
    boolean b = inputBits[1] == 1;
    return new int[]{(a && b) ? 1 : 0};
  }
}
