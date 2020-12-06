abstract class UIObj {

  // position and size
  int x, y;
  int w, h;
  // moving
  int mxOffset, myOffset;
  boolean canMove, selected, isDragged;
  ArrayList<UIObj> children;
  UIObj parent;

  UIObj(int x, int y, int w, int h, boolean canMove, boolean selected) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.canMove = canMove;
    this.selected = selected;
    this.isDragged = false;
    this.children = new ArrayList();
  }

  void addToChildren(UIObj obj) {
    children.add(obj);
    obj.parent = this;
  }

  void addChildren(Iterable objects) {
    for (Object obj : objects) {
      UIObj uiObj = (UIObj) obj;
      addToChildren(uiObj);
    }
  }

  int cx() {
    return x + w/2;
  }
  int cy() {
    return y + h/2;
  }

  // must be implemented
  abstract void show();

  void tick() {
  }

  void handleAll(boolean show, boolean tick) {
    if (show) this.show();
    if (tick) this.tick();
    for (UIObj child : children) {
      if (show) child.show();
      if (tick) child.tick();
    }
    if (isDragged && canMove) {
      drag(mouseX, mouseY);
    }
  }

  void place() {
  }

  void drawBoundingBox() {
    stroke(0, 200, 0);
    noFill();
    rect(x, y, w, h);
  }

  // -- secondary affects of top level interaction
  void subClick(int mx, int my) {
  }
  void subClick() {
  }
  void subDrag(int mx, int my) {
  }
  void subDrag() {
  }
  void subRelease() {
  }

  void click(int mx, int my) {
    // apply to children
    for (UIObj child : children) {
      child.click(mx, my);
    }
    // check if click is in bounding box
    if (mx >= x && mx <= x + w) {
      if (my >= y && my <= y + h) {
        // select if movable
        if (canMove) {
          if (!selected) {
            // record mouse displacement from top right
            mxOffset = x - mx;
            myOffset = y - my;
          } 
          // select/unselect
          selected = !selected;
        }
        // invoke other click method
        subClick(mx, my);
        subClick();
      }
    }
  }
  
  void keyPressed(char key) {
    
  }

  void drag(int mx, int my) {
    // apply to children
    for (UIObj child : children) {
      child.drag(mx, my);
    }
    if (canMove && selected) {
      int oldX = this.x;
      int oldY = this.y;
      this.x = mxOffset + mx;
      this.y = myOffset + my;
      for (UIObj child : children) {
        child.x += (this.x - oldX);
        child.y += (this.y - oldY);
      }
      subDrag(mx, my);
      subDrag();
    }
  }

  void release() {
    // apply to children
    for (UIObj child : children) {
      child.release();
    }
    if (!isDragged) {
      selected = false;
      subRelease();
    }
  }
}
