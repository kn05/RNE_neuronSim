final int w = 800;
final int h = 800;
final int time_max = 10000;
Pixel pixel[][][] = new Pixel[w][h][time_max];
int t = 0;
PImage img;
void setup(){
  size(800, 800);
  background(0);
  img=loadImage("neuron.png");
  imageMode(CENTER);
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
      pixel[i][j] = new Pixel(); 
      pixel[i][j].col = get(i, j);
    }
  }
}
void draw(){
  

  
  t++;
}

void diffusion(int i, int j){ //make diffusion of voltage
  if(i<0 || i>w-1 || j<0 || j>h-1){
    println("out of range"+i+" : "+j);
    return;
  }
  if(pixel[i][j][t].col != color(0, 0, 0)){
    //code
  }
}

void hh(int i, int j, int t){  //hodgkin-huxley model
  Pixel p1 = pixel[i][j][t];
  Pixel p0 = pixel[i][j][t-1];
  float Cm;
  float Rm;
  float I = Cm*dfdt(p0.vol, p1.vol) + ;

}

float dfdt(float x1, float x2){
  return (x2-x1);
}
