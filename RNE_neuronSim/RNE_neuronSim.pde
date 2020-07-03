import uibooster.*;
UiBooster File;
UiBooster Mag;
UiBooster H;
UiBooster W;

final int w = 600;
final int h = 600;
final int n = 5;
Pixel pixel[][] = new Pixel[600][600];
float diffuse[][] = new float[600][600];
float nt[][] = new float[600][600];

int t = 0;
float dt = 0.0075; //ms
float R = 1;
int gx, gy;
int dx[] = {n, -n, 0, 0};
int dy[] = {0, 0, n, -n};

float g[] = new float[10000];

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color red = color(255, 0, 0);
color blue = color(0, 112, 192);
color gray = color(120);

color palate[] = {white, black, red, blue, gray};

PImage img;
void setup() {
  size(600, 600);
  background(0);
  File = new UiBooster();
  String filename = File.showTextInputDialog("filename?");
  img=loadImage(filename);
  imageMode(CENTER);
  Mag = new UiBooster();
  String mag =Mag.showTextInputDialog("Magnification of image?");
  float m = float(mag);
  H = new UiBooster();
  String Hig =H.showTextInputDialog("Number of pixels to move on the vertical axis?");
  float hig = float(Hig);
  W = new UiBooster();
  String Wid =W.showTextInputDialog("Number of pixels to move on the horizontal axis?");
  float wid = float(Wid);
  image(img, width/2+wid, height/2+hig, img.width*m, img.height*m);
  noStroke();
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      pixel[i][j] = new Pixel(); 
      pixel[i][j].col = determineColor(get(i, j));
      fill(pixel[i][j].col);
      rect(i, j, n, n);
      diffuse[i][j] = 0;
      nt[i][j] = 0;
    }
  }
  frameRate(60);
}

void draw() {
  // (t+" ");
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      fill(pixel[i][j].col);
      rect(i, j, n, n);
      if (pixel[i][j].col == blue) {
        float nts=0;
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col == black) nts += nt[x][y];
        }
        pixel[i][j].NTin(nts);
      }
    }
  }
  
  diffusion();

  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].col != black) {
        pixel[i][j].HH(diffuse[i][j]); 
        float V = pixel[i][j].V;
        if (V>0) fill(150, 0, 0, 2*V);
        if (V<0) fill(0, 0, 150, -V*16);
        rect(i, j, n, n);
      } else if (pixel[i][j].col == black) {
        fill(255, 255, 0, 5000*nt[i][j]);
        rect(i, j, n, n);
        nt[i][j] *= 0.999;
      }
    }
  }
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].NTout()) {
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col == color(0)) nt[x][y] += 2.0 * dt;
        }
      }
    }
  }

  strokeWeight(2);
  stroke(94, 182, 180);
  fill(0, 0);
  rect(gx, gy, n, n);

  graph();
  t++;
}

void diffusion() { //make diffusion of voltage
  float D = 0.7;
  float nt_old[][] = new float[800][800];
  arrayCopy(nt, nt_old);
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      float a[] = {0, 0, 0, 0};
      if (pixel[i][j].col == black) {  //black, diffuse of NT
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col != black) continue;
          a[k] =nt_old[x][y] - nt_old[i][j];
        }
        nt[i][j] += (a[0]+a[1]+a[2]+a[3])*D*dt;
      } else {
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col == black) continue;
          a[k] = pixel[x][y].V - pixel[i][j].V;
        }
        diffuse[i][j] = (a[0]+a[1]+a[2]+a[3])*D;
        if (Float.isNaN(diffuse[i][j])) {
          for (int k = 0; k<4; k++) {
            int x = i+dx[k];
            int y = j+dy[k];
            a[k] = pixel[x][y].V - pixel[i][j].V;
          }
        }
      }
    }
  }
}

void graph() {
  fill(180);
  t= t%(4*w);
  rect(0, 0, w, 150);
  fill(0, 0, 255);
  g[t%(4*w)] = pixel[gx][gy].V;
  for (int i=0; i<w; i++) {
    rect(i, 110-g[4*i], 1, 1);
  }
  stroke(1);
  line(t/4, 0, t/4, 150);
  noStroke();
}

void mouseClicked() {
  int x = mouseX;
  int y = mouseY;
  if (mouseButton == LEFT) {
    pixel[(x/n)*n][(y/n)*n].V += 100;
    nt[(x/n)*n][(y/n)*n] += 0.04;
  } else if (mouseButton == RIGHT) {
    gx = (x/n)*n;
    gy = (y/n)*n;
    t=0;
  } else {
  }
}


color determineColor(color c) {
  float a[] = {0, 0, 0, 0, 0};
  int ans = 0;
  for (int i=0; i<5; i++) {
    a[i] = pow((red(c) - red(palate[i])), 2) + pow((green(c) - green(palate[i])), 2) + pow((blue(c) - blue(palate[i])), 2);
  }
  for (int i=0; i<5; i++) {
    if (a[i] == min(a)) ans = i;
  }
  return palate[ans];
}
