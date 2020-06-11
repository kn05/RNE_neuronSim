final int n = 800;
color col[][] = new color[n][n];
PImage img;
void setup(){
  size(800, 800);
  background(0);
  img=loadImage("neuron.png");
  imageMode(CENTER);
  for(int i=0; i<n; i++){
    for(int j=0; j<n; j++){
       col[i][j] = get(i, j);
    }
  }
}
void draw(){
  
  
}

void diffusion(){ //make diffusion of voltage
}

void hh(){  //hodgkin-huxley model
}
