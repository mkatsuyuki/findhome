class Direction{

  PVector[] directions;
  int index;
  
  Direction(int s){
    directions = new PVector[s];
    for(int i = 0 ; i < s ; i++){
      directions[i] = PVector.fromAngle(random(PI*2));
    }
  }


}
