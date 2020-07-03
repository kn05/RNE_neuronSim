class Pixel {
  color col;
  float V;
  float C = 1; //in muF/cm^2
  float GKMax = 40;
  float GNaMax = 140;
  float EK = -12; //mV
  float ENa = 115;
  float Gm = 0.3;
  float VRest = 10.613;
  float n = 0.32;
  float m = 0.05;
  float h = 0.60;
  float Vlim = 20;

  Pixel() {
    V = 1;
  }

  boolean NTout() {
    if (col != red) return false;
    if (V > Vlim) return true;
    else return false;
  }

  void NTin(float O) {
    float g = 47;
    float Ent = -10;
    if (col == blue) {
      V += (g*O*(V-Ent)/R)*dt;
    }
    return;
  }

  void HH(float Iinj) {  //
    if (col == black) return;
    else{
      if(Float.isNaN(Iinj)){
        print("Injh");
        delay(100000);
      }
      V += Iinj * dt;
    }
    if (col == white) {
      float aN = alphaN(V);
      float bN = betaN(V);
      float aM = alphaM(V);
      float bM = betaM(V);
      float aH = alphaH(V);
      float bH = betaH(V);

      n += (aN * (1-n) - bN * n) * dt;
      m += (aM * (1-m) - bM * m) * dt;
      h += (aH * (1-h) - bH * h) * dt;

      float INa = GNaMax * m * m * m * h * (ENa - V);
      float IK = GKMax * n * n * n * n * (EK - V);
      float Im = Gm * (VRest - V);

      V += (1 / C) * (INa + IK + Im ) * dt;
    }
  }
  float alphaN(float V) {
    if (V==10) return alphaN(V+1e-8); // 0/0 -> NaN
    return (10-V) / (100*(exp((10-V)/10)-1));
  }
  float betaN(float V) {
    return 0.125 * exp(-V/80);
  }
  float alphaM(float V) {
    if (V==25) return alphaM(V+1e-8);  // 0/0 -> NaN
    return (25-V) / (10 * (exp((25-V)/10)-1));
  }
  float betaM(float V) {
    return 4 * exp(-V/18);
  }

  float alphaH(float V) {
    return 0.07*exp(-V/20);
  }
  float betaH(float V) {
    return 1 / (exp((30-V)/10)+1);
  }
}
