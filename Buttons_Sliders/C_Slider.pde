// DECLARE/INITIALIZE CLASS SET
SliderSet sliderz = new SliderSet();
//CLASS - Slider////////////////////////////////////////////
class Slider {
  //Constructor Variables
  int ix;
  int x, y;
  //Class Variables
  float l, r, t, b, c, m, w, h;
  float sl, sr, st, sb, sctr, sm, sw, sh;
  float vlo = 0.0;
  float vhi = 1.0;
  String lbl;
  int clrnum;
  float sv = 0.5;
  boolean hasFocus = false;
  int edit = 0;
  boolean editlbl = false;
  boolean editlo = false;
  boolean edithi = false;
  String svlo = "";
  String svhi = "";
  //Constructor
  Slider(int aix, int ax, int ay) {
    ix = aix;
    x = ax;
    y = ay;

    l = x;
    t = y;
    w = 60;
    h = 200;
    r = l+w;
    b = t+h;
    c = l+(w/2.0);
    m = t+(h/2.0);
    sl=l;
    st = m-12;
    sw = w;
    sh = 25;
    sr = sl+sw;
    sb=st+sh;
    sctr = sl+(sw/2.0);
    sm = st+(sh/2.0);
    clrnum = 34;
    lbl="";
  } //end constructor

  void drw() {
    //slider background
    noStroke();
    rectMode(CORNER);
    fill( clr.getByIx(clrnum) );
    rect(l, t, w, h, 3);
    //slider
    if (hasFocus) fill(255, 255, 0);
    else fill(255);
    noStroke();
    rect(sl, st, sw, sh);
    //slider y-axis
    stroke(0);
    strokeWeight(2);
    strokeCap(SQUARE);
    line(c, t, c, b);
    //slider middle
    stroke(0);
    strokeWeight(2);
    line(l, sm, r, sm);
    //slider value
    noStroke();
    fill(0);
    rect(l, b+1, w, 18, 3);
    fill(0, 255, 0);
    textAlign(LEFT, CENTER);
    text(sv, c-38, b+10);
    //label
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    text(lbl, c, t-10); 
    //Edit Behavior//////
    if (edit==1) {
      //Draw outline to indicate in editing mode
      noFill();
      stroke(255, 255, 0);
      strokeWeight(5);
      rect(l-10, y-22, w+20, h+44, 3);
      //Make a resize square
      noStroke();
      fill(100);
      rect(r-3, b-7, 17, 17, 3);
      //Display GUI Index Num
      fill(255, 255, 0);
      text(ix, c, t-35);
      //Edit Label
      noStroke();
      if (editlbl) fill(255, 0, 255, 100);
      else fill(128, 100);
      rect(l-7, y-19, w+16, 20, 3);
      //Edit vhi
      noStroke();
      if (edithi) fill(255, 0, 255, 100);
      else fill(128, 100);
      rect(l-7, t+10, w+16, 20, 3);
      fill(255, 255, 0);
      text(svhi, c, t+20);
      //Edit vlo
      noStroke();
      if (editlo) fill(255, 0, 255, 100);
      else fill(128, 100);
      rect(l-7, b-30, w+16, 20, 3);
      fill(255, 255, 0);
      text(svlo, c, b-20);
      //Move
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
          sl=l;
          st = m-12;
          sr = sl+sw;
          sb=st+sh;
          sctr = sl+(sw/2.0);
          sm = st+(sh/2.0);
        }
        //Resize
        if (mo(r-7, r+12, b-7, b+12)) {
          w=w-pmouseX+mouseX;
          h=h-pmouseY+mouseY;
          r=l+w;
          b=t+h;
          c=l+(w/2.0);
          m=t+(h/2.0);
          sw = w;
          sr = sl+sw;
          sb=st+sh;
          sctr = sl+(sw/2.0);
          sm = st+(sh/2.0);
        }
      }
    }
  }//end drw method
  void msdrg() {
    if (edit==0) {
      if (mouseX>=sl&&mouseX<=sr&&mouseY>=st&&mouseY<=sb) {
        st = constrain(st + (mouseY-pmouseY), t, b-sh);
        sb = st+sh;
        sm = st+(sh/2);
        sv = map(sm, t+(sh/2), b-(sh/2), vhi, vlo);
        osc.send("/sl", new Object[]{ix, lbl, sv}, sc);
      }
    }
  }//end msdrg method
} //end class

class SliderSet {
  ArrayList<Slider> cset = new ArrayList<Slider>();
  //Make Instance Method
  void mk(int ix, int x, int y) {
    cset.add( new Slider(ix, x, y) );
  }//end mk
  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Slider inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method
  void drw() {
    for (Slider inst : cset) inst.drw();
  }//end drw method
  void msdrg() {
    for (Slider inst : cset) {
      if (inst.hasFocus) {
        inst.msdrg();
        break;
      }
    }
  }//end drw method
  // mouse moved //////////////////////////////////////////
  void msmvd() {
    for (Slider inst : cset) {
      if ( mo(inst.l, inst.r, inst.t, inst.b) ) { //if mouse is over this button
        for (Slider inst2 : cset) inst2.hasFocus = false; //set all to no focus
        for (PushMe inst3 : pushmez.cset) inst3.hasFocus = false; //set all to no focus
        inst.hasFocus = true; //set this instance to focus true
        break;
      }//end  if( mo(inst.l, inst.r, inst.t, inst.b) )
      else inst.hasFocus = false; //for if mouse is not touching any buttons
    }
  }//end msmv method
  // mouse pressed //////////////////////////////////////////
  void msprs() {
    for (Slider inst : cset) {
      if ( inst.hasFocus ) { 
        //Right Click to enter edit mode
        if (mouseButton==RIGHT) {
          inst.edit = (inst.edit+1)%2;
          inst.svhi = str(inst.vhi);
          inst.svlo = str(inst.vlo);
          break;
        } //
      }
      if (inst.edit==1) {
        if (mouseButton==LEFT) {
          //edit label
          if (mo(inst.l-7, inst.l-7+inst.w+16, inst.y-19, inst.y-19+20)) {
            inst.editlbl=true;
            inst.editlo=false;
            inst.edithi=false;
          }
          //edit vhi
          if (mo(inst.l-7, inst.l-7+inst.w+16, inst.y+10, inst.y+10+20)) {
            inst.editlbl=false;
            inst.editlo=false;
            inst.edithi=true;
          }
          //edit vlo
          if (mo(inst.l-7, inst.l-7+inst.w+16, inst.b-30, inst.b-30+20)) {
            inst.editlbl=false;
            inst.editlo=true;
            inst.edithi=false;
          }
        }
      }
    }
  }//end msprs method
  // key pressed //////////////////////////////////////////
  void keyprs() {
    for (Slider inst : cset) {
      if ( inst.edit==1 ) {
        //Type Label
        if (keyCode == BACKSPACE) {
          if (inst.editlbl) if (inst.lbl.length() > 0) inst.lbl = inst.lbl.substring(0, inst.lbl.length()-1);
          if (inst.edithi) if (inst.svhi.length() > 0) inst.svhi = inst.svhi.substring(0, inst.svhi.length()-1);
          if (inst.editlo) if (inst.svlo.length() > 0) inst.svlo = inst.svlo.substring(0, inst.svlo.length()-1);
        } //
        else if (keyCode != SHIFT && keyCode != CONTROL && 
          keyCode != ALT && keyCode != ENTER && keyCode != DELETE
          && key != 'ç'&& key != '∂') {
          if (inst.editlbl) inst.lbl = inst.lbl + key;
          else if (inst.edithi) {
            if (key=='0'||key=='1'||key=='2'||key=='3'||key=='4'||key=='5'||
              key=='6'||key=='7'||key=='8'||key=='9'||key=='.'||key=='-') {
              inst.svhi = inst.svhi + key;
              inst.vhi = float(inst.svhi);
            }
          }
          else if (inst.editlo) {
            if (key=='0'||key=='1'||key=='2'||key=='3'||key=='4'||key=='5'||
              key=='6'||key=='7'||key=='8'||key=='9'||key=='.'||key=='-') {
              inst.svlo = inst.svlo + key;
              inst.vlo = float(inst.svlo);
            }
          }
        }
        //Toggle color with 'ç'
        if (key=='ç') inst.clrnum = (inst.clrnum + 1)%clr.clrs.size();
        //Delete With '∂'
        if (key=='∂') rmv(inst.ix);
        break;
      }
    }
  }//end keyprs method
}//end class set