void fogPP(PImage img, PImage depth){
  img.loadPixels();
  
  for(int y = 0; y < img.height; y++){
    for(int x = 0; x < img.width; x++){
      int index = y * img.width + x;
      float d = getDepth(depth, x, y);
      color c = img.pixels[index];
      
      color newC = color(
        map(d, 1, -1, red(c), 0),
        map(d, 1, -1, green(c), 0),
        map(d, 1, -1, blue(c), 0)
      );
      
      img.pixels[index] = newC;
    }
  }
  
  img.updatePixels();
}
