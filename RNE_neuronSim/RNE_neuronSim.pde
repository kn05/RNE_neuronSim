final int w = 800;
final int h = 800;
Pixel pixel[][] = new Pixel[w][h];
PImage img;
void setup(){
  size(w, h);
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
  
  
}

void diffusion(int i, int j){ //make diffusion of voltage
  if(i<0 || i>w-1 || j<0 || j>h-1){
    println("out of range"+i+" : "+j);
    return;
  }
  if(pixel[i][j].col != color(0, 0, 0)){
    //code
  }
}

void hh(){  //hodgkin-huxley model
}
