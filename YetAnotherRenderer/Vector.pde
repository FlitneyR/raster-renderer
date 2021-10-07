class Vector {
  float x, y, z, w;
  
  Vector(float x_, float y_){
    x = x_;
    y = y_;
    z = 0;
    w = 0;
  }
  
  Vector(float x_, float y_, float z_){
    x = x_;
    y = y_;
    z = z_;
    w = 0;
  }
  
  Vector(float x_, float y_, float z_, float w_){
    x = x_;
    y = y_;
    z = z_;
    w = w_;
  }
  
  String toString(){
    return "(" + x + ", " + y + ", " + z + ", " + w + ")";
  }
  
  Vector copy(){
    return new Vector(x, y, z, w);
  }
  
  Matrix toMat(){
    return new Matrix( new float[][]{
     {x}, {y}, {z}, {w}
    });
  }
  
  void clone(Vector v){
    x = v.x;
    y = v.y;
    z = v.z;
    w = v.w;
  }
  
  Vector add(Vector b){
    clone(vecAdd(this, b));
    return this;
  }
  
  Vector sub(Vector b){
    clone(vecSub(this, b));
    return this;
  }
  
  Vector cross(Vector b){
    clone(vecCross(this, b));
    return this;
  }
  
  Vector scale(float s){
    clone(vecScale(this, s));
    return this;
  }
  
  Vector norm(){
    clone(vecNorm(this));
    return this;
  }
  
  float dot(Vector v){
    return vecDot(this, v);
  }
  
  float mag(){
    return sqrt(dot(this));
  }
  
  void transform(Matrix m){
    // |m11 m12 m13 m14|   |x|   |m11 * x + m12 * y + m13 * z + m14 * w|
    // |m21 m22 m23 m24| x |y| = |m21 * x + m22 * y + m23 * z + m24 * w|
    // |m31 m32 m33 m34|   |z|   |m31 * x + m32 * y + m33 * z + m34 * w|
    // |m41 m42 m43 m44|   |w|   |m41 * x + m42 * y + m43 * z + m44 * w|
    
    float newX = m.v[0][0] * x + m.v[0][1] * y + m.v[0][2] + m.v[0][3] * w;
    float newY = m.v[1][0] * x + m.v[1][1] * y + m.v[1][2] + m.v[1][3] * w;
    float newZ = m.v[2][0] * x + m.v[2][1] * y + m.v[2][2] + m.v[2][3] * w;
    float newW = m.v[3][0] * x + m.v[3][1] * y + m.v[3][2] + m.v[3][3] * w;
    
    x = newX;
    y = newY;
    z = newZ;
    w = newW;
  }
}

Vector vecAdd(Vector a, Vector b){
  return new Vector(
    a.x + b.x,
    a.y + b.y,
    a.z + b.z,
    a.w + b.w
  );
}

Vector vecSub(Vector a, Vector b){
  return new Vector(
    a.x - b.x,
    a.y - b.y,
    a.z - b.z,
    a.w - b.w
  );
}

Vector vecCross(Vector a, Vector b){
  //     | i  j  k|
  // mag |x1 y1 z1| = i mag |y1 z1| - j mag |x1 z1| + k mag |x1 y1|
  //     |x2 y2 z2|         |y2 z2|         |x2 z2|         |x2 y2|
  
  return new Vector(
    a.y * b.z - a.z * b.y,
    a.z * b.x - a.x * b.z,
    a.x * b.y - a.y * b.x,
    1
  );
}

float vecDot(Vector a, Vector b){
  return (
    a.x * b.x +
    a.y * b.y +
    a.z * b.z
  );
}

Vector vecScale(Vector v, float s){
  return new Vector(
    v.x * s,
    v.y * s,
    v.z * s,
    v.w * s
  );
}

Vector vecNorm(Vector v){
  return vecScale(v, 1.0 / v.mag());
}
