class Camera {
  Matrix toCam;
  float near, far, fov, camWidth, camHeight;
  PImage img, depth;
  
  Camera(){
    
    toCam = new Matrix( new float[][]{
      {1 / width, 0, 0, 0},
      {0, 1 / height, 0, 0},
      {0, 0, -2 / (far - near), - (far + near) / (far - near)},
      {0, 0, 0, 1}
    });
    
    near = 0.1;
    far = 100;
    fov = PI / 2;
    float fovH = width * fov / sqrt(width * width + height * height);
    float fovV = height * fov / sqrt(width * width + height * height);
    camWidth = atan(fovH / 2);
    camHeight = atan(fovV / 2);
  }
  
  Triangle toCameraSpace(Triangle tri){
    Vector a = toCameraSpace(tri.a);
    Vector b = toCameraSpace(tri.b);
    Vector c = toCameraSpace(tri.c);
    return new Triangle(a, b, c, tri.col);
  }
  
  //Vector toCameraSpace(Vector v){
  //  toCam.v[3][3] = 1 / v.z;
    
  //  Vector out = v.toMat().mult(toCam).toVec();
    
  //  toCam.v[3][3] = 1;
    
  //  println(out.toString());
    
  //  return out;
  //}
  
  Vector toCameraSpace(Vector v){
    return new Vector(
      (v.x / abs(v.z)) * camWidth,
      (v.y / abs(v.z)) * camHeight,
      2 * (v.z - near) / (far - near) - 1
    );
  }
  
  PImage render(ArrayList<Triangle> tris){
    img = new PImage(width, height);
    depth = new PImage(width, height);
    
    img.loadPixels();
    depth.loadPixels();
    
    for(Triangle tri : tris){
      if(!tri.visible)
        break;
      
      // get triangle in camera space
      tri = toCameraSpace(tri);
      
      draw(img, depth, tri);
    }
    
    img.updatePixels();
    depth.updatePixels();

    return img;
  }
  
  void drawOutlines(ArrayList<Triangle> tris){
    for(Triangle tri : tris){
      tri = toScreen(toCameraSpace(tri));
      
      stroke(tri.col);
      noFill();
      
      triangle(
        tri.a.x, tri.a.y,
        tri.b.x, tri.b.y,
        tri.c.x, tri.c.y);
    }
  }
  
  //void draw(PImage img, PImage depth, Triangle tri){
  //  float x, y;
    
  //  for(int Y = 0; Y < height; Y++){
  //    for(int X = 0; X < width; X++){
  //      x = map(X, 0, width, 1, -1);
  //      y = map(Y, 0, height, 1, -1);
        
  //      if(tri.contains(x, y)){
  //        float d = tri.getZ(x, y);
          
  //        if(abs(d) > 1)
  //          continue;
          
  //        float c = map(d, -1, 1, 255, 0);
          
  //        int index = Y + X * width;
          
  //        if(c > depth.pixels[index]){
  //          depth.pixels[index] = color(c);
  //          img.pixels[index] = tri.col;
  //        }
  //      }
  //    }
  //  }
  
  Vector topVector(Vector a, Vector b, Vector c){
    return topVector(topVector(a, b), c);
  }
  
  Vector topVector(Vector a, Vector b){
    return a.y > b.y ? a : b;
  }
  
  Vector midVector(Vector a, Vector b, Vector c){
    if((a.y < b.y && b.y < c.y) || (c.y < b.y && b.y < a.y))
      return b;
    
    if((b.y < a.y && a.y < c.y) || (c.y < a.y && a.y < b.y))
      return a;
    
    return c;
  }
  
  Vector lowVector(Vector a, Vector b, Vector c){
    return lowVector(lowVector(a, b), c);
  }
  
  Vector lowVector(Vector a, Vector b){
    return a.y < b.y ? a : b;
  }
  
  void draw(PImage img, PImage depth, Triangle tri){
    Triangle t = toScreen(tri);
    
    //int xStart = (int)min(t.a.x, t.b.x, t.c.x);
    //int yStart = (int)min(t.a.y, t.b.y, t.c.y);
    //int xEnd = (int)max(t.a.x, t.b.x, t.c.x);
    //int yEnd = (int)max(t.a.y, t.b.y, t.c.y);
    
    //xStart = 0;
    //yStart = 0;
    //xEnd = width;
    //yEnd = height;
    
    Vector top = topVector(tri.a, tri.b, tri.c);
    Vector mid = midVector(tri.a, tri.b, tri.c);
    Vector low = lowVector(tri.a, tri.b, tri.c);
    
    // a = 9, b = 7, c = 5
    // top = max(max(a, b), c) = max(max(5, 9), 7) = max(9, 7) = 9
    // mid = min(max(a, b), c) = min(max(9, 7), 5) = min(9, 5) = 5
    // low = min(min(a, b), c) = min(min(5, 9), 7) = max(5, 9) = 5
    
    int yStart = (int)map(top.y, 1, -1, 0, height);
    int yEnd = (int)map(low.y, 1, -1, 0, height);
    
    for(int Y = max(yStart, 0); Y < min(yEnd, height); Y++){
      float y = map(Y, 0, height, 1, -1);
      
      float longSide = map(y, top.y, low.y, top.x, low.x);
      
      float shortSide = y > mid.y ?
        map(y, top.y, mid.y, top.x, mid.x):
        map(y, mid.y, low.y, mid.x, low.x);
      
      float left = min(longSide, shortSide);
      float right = max(longSide, shortSide);
      
      left = max(left, min(top.x, mid.x, low.x));
      right = min(right, max(top.x, mid.x, low.x));
      
      int xStart = (int)map(left, -1, 1, 0, width);
      int xEnd = (int)map(right, -1, 1, 0, width);
      
      for(int X = max(xStart, 0); X < min(xEnd, width); X++){
        float x = map(X, 0, width, -1, 1);
        
        if(insideTri(tri, x, y)){
          float z = tri.getZ(x, y);
          
          if(z > 0.5 || z < -1)
            break;
          
          if(z > getDepth(depth, X, Y)){
            setDepth(depth, X, Y, z);
            img.pixels[Y * width + X] = tri.col;
          }
        }
      }
    }
  }
  
  color depthToCol(float depth){
    int d = (int)map(depth, -1, 1, 1 << 24, 0);
    
    int red = d % 255;
    int green = (d >> 8) % 255;
    int blue = (d >> 16) % 255;
    
    return color(red, green, blue);
  }
  
  float colToDepth(color shade){
    int d = 0;
    
    d += (int)red(shade);
    d += (int)green(shade) << 8;
    d += (int)blue(shade) << 16;
    
    return map(d, 0, 1 << 24, 1, -1);
  }
  
  boolean insideTri(Triangle tri, float x, float y){
    Vector up = new Vector(0, 0, -1, 0);
    Vector v = new Vector(x, y, 0, 0);
    
    Vector diffA = vecSub(tri.b, tri.a);
    Vector diffB = vecSub(tri.c, tri.b);
    Vector diffC = vecSub(tri.a, tri.c);
    
    diffA.z = 0;
    diffB.z = 0;
    diffC.z = 0;
    
    Vector normA = vecCross(diffA, up);
    Vector normB = vecCross(diffB, up);
    Vector normC = vecCross(diffC, up);
    
    float dotA = vecSub(v, tri.a).dot(normA);
    float dotB = vecSub(v, tri.b).dot(normB);
    float dotC = vecSub(v, tri.c).dot(normC);
    
    float t = 0.0;
    
    return ((dotA >= -t) && (dotB >= -t) && (dotC >= -t)) ||
           ((dotA <= t) && (dotB <= t) && (dotC <= t));
  }
  
  Triangle toScreen(Triangle tri){
    return new Triangle(
      toScreen(tri.a),
      toScreen(tri.b),
      toScreen(tri.c),
      tri.col);
  }
  
  Vector toScreen(Vector v){
    return new Vector(
      map(v.x, -1, 1, 0, width),
      map(v.y, -1, 1, height, 0),
      v.z, v.w
    );
  }
}

float getDepth(PImage depth, int x, int y){
  int index = y * depth.width + x;
  //return (depth.pixels[index] / 1000000) - 2.0;
  return map(red(depth.pixels[index]), 0, 255, -1, 1);
  //return map(depth.pixels[index], 0, 1 << 32, 1, -1);
}

void setDepth(PImage depth, int x, int y, float z){
  int index = y * depth.width + x;
  //depth.pixels[index] = (int)((z + 2.0) * 1000000);
  depth.pixels[index] = color(map(z, 1, -1, 255, 0));
  //depth.pixels[index] = (int)map(z, -1, 1, 1 << 32, 0);
}
