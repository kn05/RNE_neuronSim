final int w = 800;
final int h = 800;
color col[][] = new color[w][h];
float current[][] = new float[w][h];
PImage img;
void setup(){
  size(w, h);
  background(0);
  img=loadImage("neuron.png");
  imageMode(CENTER);
  for(int i=0; i<w; i++){
    for(int j=0; j<h; j++){
       col[i][j] = get(i, j);
    }
  }
}
void draw(){
  
  
}

void diffusion(int i, int j){ //make diffusion of voltage
  if(i<0 || i>n-1 || j<0 || j>n-1){
    println("out of range"+i+" : "+j);
    return;
  }
  if(col[i][j] != new color(0, 0, 0)){
    //code
  }
}

void hh(){  //hodgkin-huxley model
}
