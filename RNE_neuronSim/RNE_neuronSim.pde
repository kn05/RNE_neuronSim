final int w = 600;
final int h = 600;
final int time_max = 10000;

Pixel pixel[][][] = new Pixel[600][600][1000];
float diffuse[][] = new float[600][600];
int t = 0;
PImage img;
void setup() {
  size(800, 800);
  background(0);
  img=loadImage("neuron.png");
  imageMode(CENTER);
  image(img, width/2, height/2);
  for (int i=0; i<w; i++) {
    for (int j=0; j<h; j++) {
      pixel[i][j][0] = new Pixel(); 
      pixel[i][j][0].col = get(i, j);
      if (pixel[i][j][0].col == color(0, 112, 192)) pixel[i][j][0].V = 70 ;
      diffuse[i][j] = 0;
    }
  }
  frameRate(24);
}

void draw() {
  print(t+" ");
  for (int i=0; i<w; i++) {
    for (int j=0; j<h; j++) {
      if (pixel[i][j][0].col == color(0, 0, 0)) continue;
      if (t>0) {
        pixel[i][j][t] = new Pixel();
        pixel[i][j][t].col = pixel[i][j][t-1].col;
      }
      pixel[i][j][t].HH(diffuse[i][j]);
      float V = pixel[i][j][t].V;
      fill(255, 0, 0, V*2);
      noStroke();
      rect(i, j, 1, 1);
    }
  }
  diffusion();
  //println(t++);
}

void diffusion() { //make diffusion of voltage
  float a[] = new float[4];
  int dx[] = {1, -1, 0, 0};
  int dy[] = {0, 0, 1, -1};
  float D = 0.5;
  for (int i=0; i<w; i++) {
    for (int j=0; j<h; j++) {
      if (pixel[i][j][0].col == color(255, 255, 255)) {
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) return;
          if (pixel[x][y][t].col == color(0, 0, 0)) return;
          a[k] = pixel[x][y][t].V - pixel[i][j][t].V;
        }
        diffuse[i][j] = (a[0]+a[1]+a[2]+a[3])*D;
      }
    }
  }
}
void mouseClicked() {
  int x = mouseX;
  int y = mouseY;
  println(pixel[x][y][t].V);
}
