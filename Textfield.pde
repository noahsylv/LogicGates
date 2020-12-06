class Textfield extends UIObj {
  String text;
  boolean activated;
  int midX;
  int minW;

  Textfield(int x, int y, int minW, int h) {
    super(x, y, minW, h, false, false);
    midX = x;
    this.minW = minW;
    text = "";
    activated = false;
    x -= w/2;
    y -= h/2;
  }

  void show() {
    noStroke();
    fill(activated ? 255 : 150);
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(40);
    text(text, x+w/2, y+h/2);
  }

  void subClick() {
    activated = !activated;
  }

  void keyPressed(char key) {
    if (!activated) return;
    int code = (int) key;
    println(code);
    if (code == 8) {
      text = text.substring(0, max(0, text.length() - 1));
    } else if (code == 10) {
      activated = false;
    } else if ((code >= 97 && code <= 122) || (code >= 65 && code <= 90)) {
      text += key;
    }
    w = text.length() * 20 + minW;
    x = midX - w/2;
  }
}
