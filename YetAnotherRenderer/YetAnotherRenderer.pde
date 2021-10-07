void setup() {
  size(500, 500);
  tris = new ArrayList<Triangle>();
  
  //m1 = new Model("ship.txt");
  //m1.addTo(tris);
  //m1.translate(new Vector(0, -2, 2));
  
  //m2 = new Model("ship.txt");
  //m2.addTo(tris);
  //m2.translate(new Vector(0, 2, 2));
  
  models = new Model[6];
  
  for(int i = 1; i < models.length; i++){
    float theta = map(i, 0, models.length, 0, 2 * PI);
    models[i] = new Model("ship.txt");
    models[i].addTo(tris);
    models[i].translate(new Vector(
      3 * sin(theta),
      3 * cos(theta),
      2
    ));
    models[i].translate(new Vector(
      random(-0.5, 0.5),
      random(-0.5, 0.5),
      random(0.0, 0.5)
    ));
  }
  
  models[0] = new Model("ship.txt");
  models[0].addTo(tris);
  models[0].translate(new Vector(0, 0, 5));
  
  rockets = new Model[50];
  
  for(int i = 0; i < rockets.length; i++){
    Model m = new Model("rocket.txt");
    m.addTo(tris);
    rockets[i] = m;
  }

  cam = new Camera();
  
  frameRate(60);
}

Camera cam;
ArrayList<Triangle> tris;

Model m1, m2;

Model[] models;
Model[] rockets;

void draw() {
  background(0);
  
  cam.render(tris);
  image(cam.img, 0, 0);
  
  //m1.translate(new Vector(
  //  cos((float)(frameCount) / 40.0) / 20.0,
  //  sin((float)(frameCount) / 40.0) / 20.0,
  //  //0,
  //  -cos((float)(frameCount) / 35.0) / 50.0
  //));
  
  //m2.translate(new Vector(
  //  -cos((float)(frameCount + PI) / 40.0) / 20.0,
  //  -sin((float)(frameCount + PI) / 40.0) / 20.0,
  //  //0,
  //  cos((float)(frameCount + PI) / 35.0) / 50.0
  //));
  
  for(int i = 0; i < models.length; i++){
    float theta = map(i, 0, models.length, 0, 2 * PI);
    models[i].translate(new Vector(
      -cos((float)(frameCount) / 40.0 - theta) / 70.0,
      -sin((float)(frameCount) / 40.0 - theta) / 70.0,
      //0.0
      //0.0, 0.0,
      -sin((float)(frameCount) / 35.0 + theta) / 60.0
    ));
    models[i].translate(new Vector(
      sin((float)(frameCount) / 130.0 - theta) / 100.0,
      -cos((float)(frameCount) / 130.0 - theta) / 100.0,
      0.0
      //0.0, 0.0,
    ));
  }
  
  for(int i = 0; i < rockets.length; i++){
    Model m = rockets[i];
    
    if(frameCount % (rockets.length * 2) == i * 2){
      m.translate(vecScale(m.origin, -1));
      m.translate(models[i % models.length].origin);
    }
    
    m.translate(new Vector(0, 0, 0.3));
  }

  fill(255);
  noStroke();
  text("FPS: " + frameRate, 1, 11);
  text("Tris: " + tris.size(), 1, 22);
}
