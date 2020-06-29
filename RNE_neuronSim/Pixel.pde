class Pixel {
  color col;
  float V;
  float dt = 0.005; //ms
  float C = 1; //in muF/cm^2
  float GKMax = 49;
  float GNaMax = 120;
  float EK = -12; //mV
  float ENa = 115;
  float Gm = 0.3;
  float VRest = 10.613;
  float n = 0.32;
  float m = 0.05;
  float h = 0.60;

  Pixel() {
    V = 1;
  }
  void HH(float Iinj) {  //
    if(col == color(0,0,0)) return;
    if(col != color(255,255,255)){
      V += Iinj * dt;
    }
    float aN = alphaN(V);
    float bN = betaN(V);
    float aM = alphaM(V);
    float bM = betaM(V);
    float aH = alphaH(V);
    float bH = betaH(V);

    float tauN = 1 / (aN + bN);
    float tauM = 1 / (aM + bM);
    float tauH = 1 / (aH + bH);
    float nInf = aN * tauN;
    float mInf = aM * tauM;
    float hInf = aH * tauH;

    n += dt / tauN * (nInf - n);
    m += dt / tauM * (mInf - m);
    h += dt / tauH * (hInf - h);
    float INa = GNaMax * m * m * m * h * (ENa - V);
    float IK = GKMax * n * n * n * n * (EK - V);
    float Im = Gm * (VRest - V);

    V += (1 / C) * (INa + IK + Im + Iinj) * dt;
  }
  float alphaN(float V) {
    if (V==10) return alphaN(V+0.001); // 0/0 -> NaN
    return (10-V) / (100*(exp((10-V)/10)-1));
  }
  float betaN(float V) {
    return 0.125 * exp(-V/80);
  }
  float alphaM(float V) {
    if (V==25) return alphaM(V+0.001);  // 0/0 -> NaN
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
