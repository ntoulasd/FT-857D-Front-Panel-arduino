import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
PImage bg;
PFont lcdfont,lcdfontbig;
int b,coms,com,i,ch,line,pos,st;
int meter,led,extmeter,backlightr,backlightg,backlightb;
int buttonslight;
int menu,menuid,menuon=0;

int[] line0= new int[22];
int[] line1= new int[22];
int[] line2= new int[22];
int[] line3= new int[22];
int[] line4= new int[22];



void setup() 
{
  size(1720, 630);
  
bg = loadImage("ft857.jpg");
lcdfont = createFont("lcd.otf",24);
lcdfontbig = createFont("lcd.otf",36);
  String portName = "/dev/ttyUSB1";
  myPort = new Serial(this, portName, 115200);
   fill(0, 99);
  textFont(lcdfont);
  cleardisplay();
  background(bg);
}

void draw()
{
   b = readdata();

  if (b == 165) {
     coms = readdata();
     com = readdata();

  if (com == 64) {   // Menu Control hex 40
      menu = readdata();

      if (menu == 0) {//Clear Display
        readdata();
        cleardisplay();
        checksum();
      } else if (menu == 6) { //Writes MENU MODE No
        line0[0] = 77;//MENU MODE
        line0[1] = 69;
        line0[2] = 78;
        line0[3] = 85;

        line0[5] = 77;
        line0[6] = 79;
        line0[7] = 68;
        line0[8] = 69;
        checksum();
      } else if (menu == 7) { //Menu number
        menuid = readdata() + 1;
        for (i = 0; i < 12; i++) {
          line2[i] = 32;
        }
        checksum();
      } else if (menu == 8) { // Unknown 8
        menuon = 1;
        readdata();
        checksum();
      } else if (menu == 45) { //0A Setting: 1KHz/2.5KHz/5KHz
        ch = readdata();
        line2[6] = 75;
        line2[7] = 72;
        line2[8] = 122;
        if (ch == 0) {
          line2[3] = 32;
          line2[4] = 32;
          line2[5] = 49;
        } else if (ch == 1) {
          line2[3] = 50;
          line2[4] = 46;
          line2[5] = 53;
        }
        else if (ch == 2) {
          line2[3] = 32;
          line2[4] = 32;
          line2[5] = 53;
        }
        checksum();
      } else if (menu == 10) { //0A Setting: OFF/ON
        ch = readdata();
        if (ch == 1) {
          line2[8] = 32;
          line2[9] = 79;
          line2[10] = 78;
        } else {
          line2[8] = 79;
          line2[9] = 70;
          line2[10] = 70;
        }
        checksum();
      } else if (menu == 50) { //0A Setting: 1200bps/9600bps
        ch = readdata();
        if (ch == 0) {
          line2[5] = 49;
          line2[6] = 50;
          line2[7] = 48;
          line2[8] = 48;
          line2[9] = 98;
          line2[10] = 112;
          line2[11] = 115;
        } else {
          line2[5] = 57;
          line2[6] = 54;
          line2[7] = 48;
          line2[8] = 48;
          line2[9] = 98;
          line2[10] = 112;
          line2[11] = 115;
        }
        checksum();
      } else if (menu == 55) { // Unknown 37
        readdata();
        checksum();
      } else if (menu == 60) { // Unknown 3C
        readdata();
        checksum();
      } else  if (menu == 78) { //Display S symbol
        line3[0] = 83;
        line3[1] = 32;
        line3[2] = 32;

        //menuon = 0;
        checksum();
      } else if (menu == 80) { //0A Setting: TONE Freq
        ch = readdata();
        line2[5] = 84;
        line2[6] = 58;
        line2[10] = 46;
        line2[8] = ch + 48; // Fix this
        if (ch == 0) {
          line2[8] = 54;
          line2[9] = 55;
          line2[11] = 48;
        }
      }



    }
  //Display text
    if (com == 65) { // hex 41
       line = readdata();
       pos = readdata();
       
      for (i = 0; i < coms - 4; i++) {
         st = readdata();
        //text (char(st), 100+(pos+i)*26,100+(line)*26);
        
        if (line == 0) {
          line0[pos + i] = st;
          
        }
        if (line == 1) {
          line1[pos + i] = st;
          
        }
        if (line == 2) {
          line2[pos + i] = st;
          
        }
        if (line == 3) {
          line3[pos + i] = st;
          
        }
        if (line == 4) {
          line4[pos + i] = st;
          
        }
        
      }
      
      checksum();
    }
     // Meter
    if (com == 67) { // hex 43
      meter = readdata();
      checksum();
    }
    
    //Screen backlight RGB
    if (com == 74) {  // hex 4B
      /*ch = readdata();
      text (ch,200,60);
      ch = readdata();
      text (ch,300,60);*/
      /*
      backlightg=ch/2;
      if (backlightb>128) {
      backlightb=ch-128;
      } else {
        backlightb=ch;
      }
      backlightr = readdata();
      if (backlightr>128) {
      backlightr=backlightr-128;
      }   */    
      checksum();

    }

    //LED
    if (com == 75) {  // hex 4B
      led = readdata();
      checksum();
      
   if (led > 128) {
    led = led - 128;
    buttonslight=1;
  } else {
    buttonslight=0;
  }

    }

    // Ext Meter
    if (com == 76) { // hex 4C
      extmeter = readdata();
      checksum();
    }
}
  displaydata();
}


int readdata() {
  
    val = myPort.read();

    println (val);
  return val ;
}

void checksum() {
  ch = readdata();
}

void displaydata() {
    background(bg);
    noStroke();
        //text (backlightr+" "+backlightg+" "+backlightb,200,60);
    fill(backlightr,backlightg,backlightb,90);
    
    rect(350, 214, 390, 128, 7);
  //text (char(st), 100+(pos+i)*26,100+(line)*26);
  for(i=0;i<22;i++){
        fill(#FF0000, 90);
 text (char(line0[i]), 420+(i)*16,250+(0)*24);
 //text (line0[i], 400+(i)*64,200+(0)*24);
     fill(#000000, 90);
 text (char(line1[i]), 400+(i)*16,250+(1)*24);
 textFont(lcdfontbig);
 fill(#000000, 70);
 text (char(line2[i]), 411+(i)*24,261+(2)*24);
 fill(#0000FF, 95);
 text (char(line2[i]), 410+(i)*24,260+(2)*24);
 textFont(lcdfont);
 fill(#000000, 90);
 if (i<4){
   if (line3[0] == 83 && meter > 0) {   //Fix this
   if (round(meter/7)<10) {
        line3[1] = 49+round(meter/7);
        line3[2] = 32;
        } else {
        line3[1] = 57;
        line3[2] = 43;  
        }
   }
 text (char(line3[i]), 380+(i)*16,260+(2)*24);
 }
 ch = line4[i];
      if (ch == 12) {
        ch = 62; // >
      }
      if (ch == 126) {
        ch = 43; // fast +
      }
      if (ch == 127) {
        ch = 45; // fast -
      }
 text (char(ch), 380+(i)*16,270+(3)*22); 
  }
  
  //Meter
  strokeWeight(1);
  stroke(0, 99);
  for (i=0;i<=(100/6);i++){
    line(357, 330-i*6, 360, 330-i*6);
  }
  
  for (i=0;i<meter;i++){
    stroke(i*2,255-i*2,0, 90);
    line(360, 330-i, 365+(i*i/250), 330-i);
  }
  
  noStroke();
  switch (led) {
    case 9:
    fill(#00FF00, 90); //RX GREEN
    rect(830, 130, 20, 40,7);
      break;
    case 10:
    fill(#FF0000, 90);
    rect(830, 130, 20, 40,7); //TX RED
      break;
    case 1:
    fill(#0000FF, 90);
    rect(830, 130, 20, 40,7); //BLUE
      break;
  }
  
  if (buttonslight==1) {
    fill(#FF8000, 90); //Buttons light
    rect(687, 122, 40, 15,7); //power
    
    rect(578, 122, 40, 15,7); //UP
    rect(470, 122, 40, 15,7);
    rect(362, 122, 40, 15,7);
    
    rect(647, 385, 75, 15,7);//ABC
    rect(505, 385, 75, 15,7);
    rect(365, 387, 75, 15,7);
    
    rect(200, 205, 42, 10,7);//Left
    rect(190, 292, 42, 10,7);
    rect(190, 380, 58, 15,7);
    
    fill(#FF8000, 50); //Buttons light
    rect(925, 100, 30, 10,7); //Dial UP 
    rect(1035, 95, 30, 10,7);
    
    fill(#FF8000, 30); //Buttons light
    rect(1170, 205, 10, 30,7); //Dial right
    rect(1170, 350, 10, 30,7);
    
    
  }
  
  //EXTMETER
  strokeWeight(4);
  stroke(#FF0000,90);
  float c = radians(128+(extmeter/2.5));
  translate(1480,325);
  rotate(c);
  rect(0,0,1,220);
  
}

void cleardisplay() {
  for (i = 0; i < 22; i++) {
    line0[i] = 32;
  }
  for (i = 0; i < 22; i++) {
    line1[i] = 32;
  }
  for (i = 0; i < 22; i++) {
    line3[i] = 32;
  }
  for (i = 0; i < 22; i++) {
    line2[i] = 32;
  }
  for (i = 0; i < 22; i++) {
    line4[i] = 32;
  }
}
