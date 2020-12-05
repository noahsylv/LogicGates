class Not extends Gate {
  Not(int x, int y) {
    super(x, y, "NOT", 1, 1);
  }

  int[] evaluate(int[] inputBits) {
    return new int[] {
      inputBits[0] == 1 ? 0 : 1
    };
  }
}
