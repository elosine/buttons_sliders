// DECLARE/INITIALIZE CLASS SET
PushMeSet pushmez = new PushMeSet();
//CLASS - PushMe////////////////////////////////////////////
class PushMe {
  //Constructor Variables /////////////////
  int ix;
  int x, y;
  int mode;
  //Class Variables ///////////////////////
  float l, r, t, b, w, h, c, m;
  int clrnum = 34;
  boolean hasFocus = false;
  int edit = 0;
  int pressed = 0;
  String lbl = "";
  boolean msggate = true;
  //Constructor////////////////////////////
  PushMe(int aix, int ax, int ay, int amode) {
    ix = aix;
    x = ax;
    y = ay;
    mode = amode;

    l=x;
    t=y;
    w=50;
    h=50;
    r=l+w;
    b=t+h;
    c=l+(w/2.0);
    m=t+(h/2.0);
  }//end constructor
  //DRAW METHOD /////////////////
  void drw() {
    //Draw Button////////
    noStroke();
    rectMode(CORNER);
    ////Pressed Behavior
    if (pressed==1) {
      fill(255, 255, 0);
      //OSC Message on MousePress
      if (msggate) {
        osc.send("/bt", new Object[]{ix, lbl, 1}, sc);
        println("fdsa");
        msggate = false;
      }
    }//
    else {
      fill(clr.getByIx(clrnum));
      //OSC Message on MouseRelease
      if (!msggate) {
        osc.send("/bt", new Object[]{ix, lbl, 0}, sc);
        msggate = true;
      }
    }
    ////Has Focus//////////////
    if (hasFocus) rect(l-5, t-5, w+10, h+10, 3);
    else rect(l, t, w, h, 3);
    //Edit Behavior//////
    if (edit==1) {
      //Draw outline to indicate in editing mode
      noFill();
      stroke(255, 255, 0);
      strokeWeight(5);
      rect(l-10, y-10, w+20, h+20, 3);
      //Make a resize square
      noStroke();
      fill(100);
      rect(r-7, b-7, 17, 17, 3);
      //Display GUI Index Num
      fill(255,255,0);
      text(ix, c, t-25);
      //Move button
      if (mousePressed) {
        if (mo(l+8, r-8, t+8, b-8)) {
          x = x-pmouseX+mouseX;
          y = y-pmouseY+mouseY;
          l=x;
          t=y;
          r=l+w;
          b=t+h;
          c=l+(w/2.0);
          m=t+(h/2.0);
        }
        //Resize Button
        if (mo(r-7, r+12, b-7, b+12)) {
          w=w-pmouseX+mouseX;
          h=h-pmouseY+mouseY;
          r=l+w;
          b=t+h;
          c=l+(w/2.0);
          m=t+(h/2.0);
        }
      }
    }
    //Display Label
    fill(0);
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    text(lbl, c, m, w-4, h-4);
  }//end drw
}//end class PushMe
////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////
class PushMeSet {
  ArrayList<PushMe> cset = new ArrayList<PushMe>();
  // Make Instance Method ///////////////////////////////////
  void mk(int ix, int x, int y, int mode) {
    cset.add( new PushMe(ix, x, y, mode) );
  } //end mk method
  // Remove Instance Method ///////////////////////////////////
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      PushMe inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method
  // Draw Set Method //////////////////////////////////////////
  void drw() {
    for (PushMe inst : cset) {
      inst.drw();
    }
  }//end drw method
  // mouse moved //////////////////////////////////////////
  void msmvd() {
    for (PushMe inst : cset) {
      if ( mo(inst.l, inst.r, inst.t, inst.b) ) { //if mouse is over this button
        for (PushMe inst2 : cset) inst2.hasFocus = false; //set all to no focus
        for (Slider inst3 : sliderz.cset) inst3.hasFocus = false; //set all to no focus
        inst.hasFocus = true; //set this instance to focus true
        break;
      }//end  if( mo(inst.l, inst.r, inst.t, inst.b) )
      else inst.hasFocus = false; //for if mouse is not touching any buttons
    }
  }//end msmv method
  // mouse pressed //////////////////////////////////////////
  void msprs() {
    for (PushMe inst : cset) {
      if ( inst.hasFocus ) { 
        //Right Click to enter edit mode
        if (mouseButton==RIGHT) {
          inst.edit = (inst.edit+1)%2;
          break;
        } //
        //Left Click to operate button
        else if (mouseButton==LEFT) { //if left button clicked
          if (inst.edit==0) { //if button is not in editing mode
            if (inst.mode==0) inst.pressed=1;
            else if (inst.mode==1) inst.pressed=(inst.pressed+1)%2;
            break;
          }
        }
      }
    }
  }//end msprs method
  // mouse released //////////////////////////////////////////
  void msrel() {
    for (PushMe inst : cset) {
      if ( inst.hasFocus ) { 
        if (mouseButton==LEFT) { //if left button clicked
          if (inst.edit==0) { //if button is not in editing mode
            if (inst.mode==0) inst.pressed=0; //release for buttons in momentary mode
            break;
          }
        }
      }
    }
  }//end msrel method
  // key pressed //////////////////////////////////////////
  void keyprs() {
    for (PushMe inst : cset) {
      if ( inst.edit==1 ) {
        //Type Label
        if (keyCode == BACKSPACE) {
          if (inst.lbl.length() > 0) inst.lbl = inst.lbl.substring(0, inst.lbl.length()-1);
        } //
        else if (keyCode != SHIFT && keyCode != CONTROL && 
          keyCode != ALT && keyCode != ENTER && keyCode != DELETE
          && key != 'ç') {
          inst.lbl = inst.lbl + key;
        }
        //Toggle color with 'ç'
        if (key=='ç') inst.clrnum = (inst.clrnum + 1)%clr.clrs.size();
        //Delete With '∂'
        if (key=='∂') rmv(inst.ix);
        break;
      }
    }
  }//end keyprs method
} // END CLASS SET CLASS