final int w = 800;
final int h = 800;
final int n = 6;
Pixel pixel[][] = new Pixel[800][800];
float diffuse[][] = new float[800][800];
float nt[][] = new float[800][800];
int t = 0;
float dt = 0.005; //ms
int dx[] = {n, -n, 0, 0};
int dy[] = {0, 0, n, -n};

color red = color(255, 0, 0);

PImage img;
void setup() {
  size(800, 800);
  background(0);
  img=loadImage("neu1.png");
  imageMode(CENTER);
  image(img, width/2, height/2, img.width/2.2, img.height/2.2);
  noStroke();
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      pixel[i][j] = new Pixel(); 
      pixel[i][j].col = get(i, j);
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
    }
  }
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].col != color(0)) {
        pixel[i][j].HH(diffuse[i][j]); 
        float V = pixel[i][j].V;
        if (V>0) fill(150, 0, 0, 2*V);
        if (V<0) fill(0, 0, 150, -V*16);
        rect(i, j, n, n);
      } else {
        fill(255, 255, 0, nt[i][j]);
        rect(i, j, n, n);
      }
    }
  }
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].NT()) {
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col == color(0)) nt[x][y] += 10;
        }
      }
    }
  }
  diffusion();
  t++;
}

void diffusion() { //make diffusion of voltage
  float D = 0.8;
  float nt_old[][] = new float[800][800];
  arrayCopy(nt, nt_old);
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      float a[] = {0, 0, 0, 0};
      if (pixel[i][j].col == color(0)) {
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col != color(0)) continue;
          a[k] =nt_old[x][y] - nt_old[i][j];
        }
        nt[i][j] += (a[0]+a[1]+a[2]+a[3])*D*dt;
      } else {
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col == color(0)) continue;
          a[k] = pixel[x][y].V - pixel[i][j].V;
        }
        diffuse[i][j] = (a[0]+a[1]+a[2]+a[3])*D;
      }
    }
  }
}

void mouseClicked() {
  int x = mouseX;
  int y = mouseY;
  pixel[(x/n)*n][(y/n)*n].V += 40;
  nt[(x/n)*n][(y/n)*n] += 40;
}
