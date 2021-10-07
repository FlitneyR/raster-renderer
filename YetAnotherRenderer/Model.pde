class Model {
  Triangle[] tris, relTris;
  Matrix transform;
  Vector origin, relX, relY, relZ;
  boolean visible = true;
  
  Model(Triangle[] tris_){
    tris = relTris = tris_;
    
    transform = new Matrix(new float[][]{
      {1.0, 0.0, 0.0, 0.0},
      {0.0, 1.0, 0.0, 0.0},
      {0.0, 0.0, 1.0, 0.0},
      {0.0, 0.0, 0.0, 1.0}
    });
    
    origin = new Vector(0, 0, 0);
    
    relX = new Vector(1, 0, 0);
    relY = new Vector(0, 1, 0);
    relZ = new Vector(0, 0, 1);
    
    update();
  }
  
  Model(String filename){
    String[] lines = loadStrings(filename);
    String line;
    int i = 0;
    
    ArrayList<Vector> vectors = new ArrayList<Vector>();
    
    while(i < lines.length){
      line = lines[i];
      
      float[] values = getFloats(line);
      
      if(values == null){
        i++;
        break;
      }
      
      vectors.add(new Vector(
        values[0],
        values[1],
        (values.length > 2 ? values[2] : 0.0),
        (values.length > 3 ? values[3] : 1.0)
      ));
      
      i++;
    }
    
    ArrayList<Integer> colors = new ArrayList<Integer>();
    
    while(i < lines.length){
      line = lines[i];
      
      int[] values = getInts(line);
      
      if(values == null){
        i++;
        break;
      }
      
      colors.add(color(
        values[0],
        values[1],
        values[2]
      ));
      
      i++;
    }
    
    ArrayList<Triangle> tris = new ArrayList<Triangle>();
    
    while(i < lines.length){
      line = lines[i];
      
      int[] indices = getInts(line);
      
      if(indices == null){
        i++;
        break;
      }
      
      tris.add(new Triangle(
        vectors.get(indices[0]),
        vectors.get(indices[1]),
        vectors.get(indices[2]),
        colors.get(indices[3])
      ));
      
      i++;
    }
    
    Triangle[] tris_ = new Triangle[tris.size()];
    
    for(i = 0; i < tris_.length; i++){
      tris_[i] = tris.get(i);
    }
    
    this.tris = relTris = tris_;
    
    transform = new Matrix(new float[][]{
      {1.0, 0.0, 0.0, 0.0},
      {0.0, 1.0, 0.0, 0.0},
      {0.0, 0.0, 1.0, 0.0},
      {0.0, 0.0, 0.0, 1.0}
    });
    
    origin = new Vector(0, 0, 0);
    
    relX = new Vector(1, 0, 0);
    relY = new Vector(0, 1, 0);
    relZ = new Vector(0, 0, 1);
    
    update();
  }
  
  void setVisible(boolean v){
    for(Triangle tri : tris){
      tri.visible = false;
    }
  }
  
  float[] getFloats(String line){
    String[] strings = line.split(",");
    float[] out = new float[strings.length];
    
    if(strings.length == 1)
      return null;
    
    for(int i = 0; i < strings.length; i++){
      out[i] = Float.parseFloat(strings[i]);
    }
    
    return out;
  }
  
  int[] getInts(String line){
    String[] strings = line.split(",");
    int[] out = new int[strings.length];
    
    if(strings.length == 1)
      return null;
    
    for(int i = 0; i < strings.length; i++){
      out[i] = Integer.parseInt(strings[i]);
    }
    
    return out;
  }
  
  void update(){
    for(int i = 0; i < relTris.length; i++){
      tris[i].a = vecScale(relX, tris[i].a.x)
              .add(vecScale(relY, tris[i].a.y))
              .add(vecScale(relZ, tris[i].a.z));
      
      tris[i].b = vecScale(relX, tris[i].b.x)
              .add(vecScale(relY, tris[i].b.y))
              .add(vecScale(relZ, tris[i].b.z));
      
      tris[i].c = vecScale(relX, tris[i].c.x)
              .add(vecScale(relY, tris[i].c.y))
              .add(vecScale(relZ, tris[i].c.z));
    }
  }
  
  void rotateY(float theta){
    // | cos  0.0 -sin |   |x|   |x * cos - z * sin|
    // | 0.0  1.0  0.0 | x |y| = |y                |
    // | sin  0.0  cos |   |z|   |x * sin + z * cos|
    
    float c = cos(theta);
    float s = sin(theta);
    
    float x, y, z;
    
    x = relX.x; y = relX.y; z = relX.z;
    
    relX.x = c * x - z * s;
    relX.y = s * x + z * c;
    
    x = relY.x; y = relY.y; z = relY.z;
    
    relY.x = c * x - z * s;
    relY.y = s * x + z * c;
    
    x = relZ.x; y = relZ.y; z = relZ.z;
    
    relZ.x = c * x - z * s;
    relZ.y = s * x + z * c;
    
    update();
  }
  
  void translate(Vector v){
    origin.add(v);
    
    for(Triangle tri : tris){
      tri.translate(v);
    }
  }
  
  void transform(Matrix m){
    for(Triangle tri : tris){
      tri.transform(m);
    }
  }
  
  void addTo(ArrayList<Triangle> t){
    for(Triangle tri : tris){
      t.add(tri);
    }
  }
}
