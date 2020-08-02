class Dir{

  PVector[] dirs;
  int index;
  
  Dir(int s){
    dirs = new PVector[s];
    for(int i = 0 ; i < s ; i++){
      dirs[i] = PVector.fromAngle(random(PI*2));
    }
  }
}
