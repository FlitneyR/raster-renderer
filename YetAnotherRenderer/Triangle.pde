class Triangle {
  Vector a, b, c;
  Vector normal;
  float dist;
  color col;
  boolean visible;
  
  Triangle(Vector a_, Vector b_, Vector c_, color col_){
    a = a_;
    b = b_;
    c = c_;
    
    normal = getNormal();
    dist = getDist();
    col = col_;
    
    visible = true;
  }
  
  void update(){
    normal = getNormal();
    dist = getDist();
  }
  
  Triangle copy(){
    return new Triangle(a.copy(), b.copy(), c.copy(), col);
  }
  
  String toString(){
    return "{" +
      a.toString() + ", " +
      b.toString() + ", " +
      c.toString() + "}";
  }
  
  Vector getNormal(){
    return vecCross(
      vecSub(b, a),
      vecSub(c, a)
    ).norm();
  }
  
  float getDist(){
    // d = a•n
    
    return a.dot(normal);
  }
  
  float getZ(float x, float y){
    
    // ax1 + by1 + c = z1
    // ax2 + by2 + c = z2
    // ax3 + by3 + c = z3
    
    // ax4 + by4 + c = z4
    
    // |x|   |a|
    // |y| • |b| = z
    // |1|   |c|
    
    // |x1 y1 1|   |a|   |ax1 + by1 + c|
    // |x2 y2 1| x |b| = |ax2 + by2 + c|
    // |x3 y3 1|   |c|   |ax3 + by3 + c|
    
    // det = x1 * (y2 - y3) - y1 * (x2 - x3) + (x2 * y3 - x3 * y2)
    
    // min = 
    //   |(y2 - y3) (x2 - x3) (x2 * y3 - x3 * y2)|
    //   |(y1 - y3) (x1 - x3) (x1 * y3 - x3 * y1)|
    //   |(y1 - y2) (x1 - x2) (x1 * y2 - x2 * y1)|
    
    // adj(min) = 
    //   |(y2 - y3)           (y1 - y3)           (y1 - y2)          |
    //   |(x2 - x3)           (x1 - x3)           (x1 - x2)          |
    //   |(x2 * y3 - x3 * y2) (x1 * y3 - x3 * y1) (x1 * y2 - x2 * y1)|
    
    // inv = (1 / det) * adj(min)
    // inv = 
    //   |i11 i12 i13|
    //   |i21 i22 i23|
    //   |i31 i32 i33|
    
    // |a|                         |z1|
    // |b| = (1/ det) * adj(min) x |z2|
    // |c|                         |z3|
    
    // a = (1 / det) * (z1 * (y2 - y3) + z2 * (y1 - y3) + z3 * (y1 - y2))
    // b = (1 / det) * (z1 * (x2 - x3) + z2 * (x1 - x3) + z3 * (x1 - x2))
    // c = (1 / det) * (z1 * (x2 * y3 - x3 * y2) + z2 * (x1 * y3 - x3 * y1) + z3 * (x1 * y2 - x2 * y1))
    
    //float det = a.x * (b.y - c.y) - a.y * (b.x - c.x) + (b.x * c.y - c.x * b.y);
    
    //float A = a.z * (b.y - c.y) +
    //          b.z * (a.y - c.y) +
    //          c.z * (a.y - b.y);
                        
    //float B = a.z * (b.x - c.x) +
    //          b.z * (a.x - c.x) +
    //          c.z * (a.x - c.x);
    
    //float C = a.z * (b.x * c.y - c.x * b.y) +
    //          b.z * (a.x * c.y - c.x * a.y) +
    //          c.z * (a.x * b.y - b.x * a.y);
    
    //println((A * a.x + B * a.y + C) / det, a.z);
    //println((A * b.x + B * b.y + C) / det, b.z);
    //println((A * c.x + B * c.y + C) / det, c.z);
    
    //return (A * x + B * y + C) / det;
    
    // v•n - d = 0
    // (v.x * n.x + v.y * n.y + v.z * n.z) - d = 0
    // v.z = (v.x * n.x + v.y * n.y - d) / -n.z
    
    return (x * normal.x + y * normal.y - dist) / (2 * normal.z);
  }
  
  void transform(Matrix m){
    a.transform(m);
    b.transform(m);
    c.transform(m);
    update();
  }
  
  void translate(Vector v){
    a.add(v);
    b.add(v);
    c.add(v);
    update();
  }
}
