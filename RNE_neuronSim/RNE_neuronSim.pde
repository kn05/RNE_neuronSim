final int w = 800;
final int h = 800;
final int n = 4;
Pixel pixel[][] = new Pixel[800][800];
float diffuse[][] = new float[800][800];
int t = 0;
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
    }
  }
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].col == color(0, 112, 192)) pixel[i][j].V = 40 ;
    }
  }
  frameRate(120);
}

void draw() {
  println(t+" ");
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      fill(pixel[i][j].col);
      rect(i, j, n, n);
    }
  }
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].col == color(0, 0, 0)) continue;
      pixel[i][j].HH(diffuse[i][j]); 
      float V = pixel[i][j].V;
      fill(240, 0, 250, V*2);
      rect(i, j, n, n);
    }
  }
  diffusion();
  t++;
}

void diffusion() { //make diffusion of voltage
  float a[] = new float[4];
  int dx[] = {n, -n, 0, 0};
  int dy[] = {0, 0, n, -n};
  float D = 0.9;
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].col == color(0, 0, 0)) continue;
      for (int k = 0; k<4; k++) {
        int x = i+dx[k];
        int y = j+dy[k];
        if (x < 0 || y<0 || x>=w || y>=h ) continue;
        if (pixel[x][y].col == color(0, 0, 0)) continue;
        a[k] = pixel[x][y].V - pixel[i][j].V;
      }
      diffuse[i][j] = (a[0]+a[1]+a[2]+a[3])*D;
    }
  }
}

void mouseClicked() {
  int x = mouseX;
  int y = mouseY;
  println(x, y);
}
