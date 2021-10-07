class Matrix {
  float[][] v;
  int width, height;
  
  Matrix(float[][] v_){
    v = v_;
    height = v.length;
    width = v[0].length;
  }
  
  Matrix(int width, int height){
    v = new float[height][width];
    this.width = width;
    this.height = height;
  }
  
  Vector toVec(){
    if((width == 1) && (height == 4)){
      return new Vector(
        v[0][0],
        v[1][0],
        v[2][0],
        v[3][0]
      );
    }
    return null;
  }
  
  Matrix mult(Matrix m) {
    v = matMult(this, m).v;
    return this;
  }
}

Matrix matMult(Matrix a, Matrix b) {
  if(a.height != b.width){
    println("Dimension mismatch: " +
            a.width + ", " + a.height + " : " +
            b.width + ", " + b.height);
    return null;
  }
  
  Matrix m = new Matrix(b.width, a.height);
  
  for(int x = 0; x < m.width; x++){
    for(int y = 0; y < m.height; y++){
      float sum = 0;
      
      for(int i = 0; i < a.width; i++){
        sum += a.v[y][x + i] * b.v[y + i][x];
      }
      
      m.v[y][x] = sum;
    }
  }
  
  return m;
}
