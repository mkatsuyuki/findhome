class Direction{
  
  //Vetor de direções da mosca
  PVector[] directions;
  int index;
  
  //Gera vetor de direçoes aleatório de tamanho s
  Direction(int s){
    directions = new PVector[s];
    for(int i = 0 ; i < s ; i++){
      directions[i] = PVector.fromAngle(random(PI*2));
    }
  }
}
