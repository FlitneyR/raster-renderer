class KinematicBody {
  Vector pos, vel;
  Model model;
  
  KinematicBody(Model m, Vector pos_){
    model = m;
    pos = pos_;
  }
  
  void update(){
    model.translate(vecScale(model.origin, -1));
    model.translate(pos);
  }
}
