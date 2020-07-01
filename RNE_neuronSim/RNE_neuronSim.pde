final int w = 800;
final int h = 800;
final int n = 12;
Pixel pixel[][] = new Pixel[800][800];
float diffuse[][] = new float[800][800];
float nt[][] = new float[800][800];
float R = 1;
int t = 0;
float dt = 0.005; //ms
int dx[] = {n, -n, 0, 0};
int dy[] = {0, 0, n, -n};

color white = color(255, 255, 255);
color black = color(0, 0 ,0);
color red = color(255, 0, 0);
color blue = color(0, 112, 192);
color gray = color(120);

color palate[] = {white, black, red, blue, gray};

PImage img;
void setup() {
  size(800, 800);
  background(0);
  img=loadImage("2.png");
  imageMode(CENTER);
  image(img, width/2, height/2, img.width*3, img.height*3);
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
    }
  }
  for (int i=0; i<w; i+=n) {
    for (int j=0; j<h; j+=n) {
      if (pixel[i][j].col != black) { //white
        pixel[i][j].HH(diffuse[i][j]); 
        float V = pixel[i][j].V;
        if (V>0) fill(150, 0, 0, 2*V);
        if (V<0) fill(0, 0, 150, -V*16);
        rect(i, j, n, n);
      }
      else if(pixel[i][j].col == black){
        fill(255, 255, 0, 1000*nt[i][j]);
        rect(i, j, n, n);
      }
      if (pixel[i][j].col == blue) {
        float nts=0;
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col == black) nts += nt[x][y];
        }
        pixel[i][j].NTin(nts);
        if(nts != 0) println(nts);
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
          if (pixel[x][y].col == color(0)) nt[x][y] += 0.50 * dt;
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
      if (pixel[i][j].col == black) {  //black, diffuse of NT
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col != black) continue;
          a[k] =nt_old[x][y] - nt_old[i][j];
        }
        nt[i][j] += (a[0]+a[1]+a[2]+a[3])*D*dt;
      } 
      else {
        for (int k = 0; k<4; k++) {
          int x = i+dx[k];
          int y = j+dy[k];
          if (x < 0 || y<0 || x>=w || y>=h ) continue;
          if (pixel[x][y].col == black) continue;
          a[k] = pixel[x][y].V - pixel[i][j].V;
        }
        diffuse[i][j] = (a[0]+a[1]+a[2]+a[3])*D;
      }
    }
  }
}

void graph(){
  fill(180);
  rect(0, 0, 600, 150);
}

void mouseClicked() {
  int x = mouseX;
  int y = mouseY;
  pixel[(x/n)*n][(y/n)*n].V += 100;
  nt[(x/n)*n][(y/n)*n] += 0.4;
}

color determineColor(color c){
  float a[] = {0, 0, 0, 0, 0};
  int ans = 0;
  for(int i=0; i<5; i++){
    a[i] = pow((red(c) - red(palate[i])), 2) + pow((green(c) - green(palate[i])), 2) + pow((blue(c) - blue(palate[i])), 2);
  }
  for(int i=0; i<5; i++){
    if(a[i] == min(a)) ans = i;
  }
  return palate[ans];
}
