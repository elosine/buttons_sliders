// DECLARE/INITIALIZE CLASS SET
SampleDisplaySet sampledisplayz = new SampleDisplaySet();
/********
 /// PUT IN SETUP ///
 osc.plug(sampledisplayz, "mk", "/mksamp");
 osc.plug(sampledisplayz, "rmv", "/rmvsamp");
 /// PUT IN DRAW ///
 sampledisplayz.drw();
 ********/
/////////////   CLASS     //////////////////////////////
class SampleDisplay {
  // CONSTRUCTOR VARIALBES //
  int ix, x, y;
  // CLASS VARIABLES //
  float cx, l, r, t, b, w, h, m, c; 
  int edit = 0;
  String[]sampnames = new String[0];
  float[]samparray = new float[0];
  boolean sgate = true;
  // CONSTRUCTORS //
  /// Constructor 1 ///
  SampleDisplay(int aix, int ax, int ay) {
    ix = aix;
    x = ax;
    y = ay;

    l=x;
    t=y;
    w=1000;
    h=150;
    r=l+w;
    b=t+h;
    c = l+(w/2);
    m = t+(h/2);
    cx=x;
  } //end constructor 1
  //  DRAW METHOD //
  void drw() {
    //Sample Names
    rectMode(CORNER);
    noStroke();
    fill(clr.get("sunshine"));
    rect(l, t-36, w, 36);
    strokeWeight(3);
    for (int i=0; i<sampnames.length; i++) {
      fill( clr.getByIx( (i+24)%clr.clrs.size() ) );
      if (mo(l+6+(30*i), l+6+(30*i)+24, t-30, t-30+24)) {
        stroke(255);
        if (mousePressed) {
          if (sgate) {
            osc.send("/getwf", new Object[]{i, w}, sc);
            sgate = false;
          }
        } //
        else {
          if (!sgate) sgate = true;
        }
      } //
      else noStroke();
      rect(l+6+(30*i), t-30, 24, 24);
    }
    //Sample Display Background
    noStroke();
    fill(clr.get("beet"));
    rect(l, t, w, h);
    
    
    //waveform display
  stroke(255, 153, 51);
  strokeWeight(1);
    for (int i=1; i<samparray.length; i++) {
      line( i-1+l,  m+( samparray[i-1]*(h/2) ), i+l,  m+( samparray[i]*(h/2) ) );
    }
    
    
    //Cursor
    if (edit==0) osc.send("/getix", new Object[]{ix}, sc);
    strokeWeight(3);
    stroke(153, 255, 0);
    line(cx, t, cx, b);
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
      fill(255, 255, 0);
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
          cx=x;
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
  } //End drw
  //  ix method //
  void ix(float val) {
    float ixtmp = map(val, 0.0, 1.0, l, r);
    cx = ixtmp;
  }
  //
}  //End class
////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////
class SampleDisplaySet {
  ArrayList<SampleDisplay> cset = new ArrayList<SampleDisplay>();
  // Make Instance Method //
  void mk(int ix, int x, int y) {
    cset.add( new SampleDisplay(ix, x, y) );
  } //end mk method
  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      SampleDisplay inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method
  // Draw Set Method //
  void drw() {
    for (SampleDisplay inst : cset) {
      inst.drw();
    }
  }//end drw method 
  // mouse pressed //////////////////////////////////////////
  void msprs() {
    for (SampleDisplay inst : cset) {
      if (mouseButton==RIGHT) {
        inst.edit = (inst.edit+1)%2;
        break;
      } //
      //Left Click
      else if (mouseButton==LEFT) { 
        if (inst.edit==0) { //if not in editing mode
          break;
        }
      }
    }
  }//end msprs method
  // ix Method //
  void ix(float val) {
    for (SampleDisplay inst : cset) {
      inst.ix(val);
    }
  }//end drw method 
  //
} // END CLASS SET CLASS