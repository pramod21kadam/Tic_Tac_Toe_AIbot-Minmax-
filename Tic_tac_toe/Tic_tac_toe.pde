PImage cross,dot;
float[][] board = new float[3][3];
float[] scores = new float[3];
float human,ai,currentPlayer;
int playX,playY;
float win;
void setup(){
  size(650,650);
  playX = 25;
  playY = 25;
  human = 0;
  ai = 1;
  currentPlayer =  human;
  scores[0] = -10;
  scores[1] = 10;
  scores[2] = 0;
  
  for(int i = 0;i<3 ; i++)
    for(int j = 0;j<3 ; j++)
     board[i][j] = -1;
  bestMove();
  cross = loadImage("cross.png");
  dot = loadImage("dot.png");
}

void draw(){
  background(255);
  for(int i = 200 + playX; i<600 ; i+= 200){
    stroke(127);
    strokeWeight(5);
    line(i,playY,i,600);
    line(playX,i,600,i);
  }
  for(int i = 0 ; i<3 ; i++)
    for(int j = 0 ; j<3 ; j++){
      if(board[i][j] == human){
          image(dot, i*205+playX, j*205+playY, 190, 190);
      }
      if(board[i][j] == ai){
          image(cross,i*205+playX, j*200+5+playY, 190, 190);
      }
    }
}

void mousePressed(){
  int x = floor(mouseX/200);
  int y = floor(mouseY/200);
  if (currentPlayer == human){
    if(board[x][y] == -1){
      board[x][y] = human;
      currentPlayer = ai;
      bestMove();
    }
  }
} 

void bestMove(){
  float bestScore = -99999999;
  int x,y;
  x = 1;
  y = 1;
  for(int i=0;i<3;i++)
    for(int j = 0 ; j<3 ; j++){
       if(board[i][j] == -1){
         board[i][j] = ai;
         float score = minmax(board ,0, false);
         board[i][j] = -1 ;
         if(score > bestScore){
           bestScore = score;
           x = i;
           y = j;
         }
       }
     }
     
   board[x][y] = ai;
   currentPlayer = human;
}

float minmax(float[][] board,float depth,boolean isMaximizing){
  float result = checkWinner();
  if(result != -1){
    return scores[(int)result];
  }
  if(isMaximizing){
    float bestScore = -99999999;
    for(int i = 0;i<3 ;i++ )
      for(int j = 0 ; j<3 ; j++){
      if (board[i][j] == -1) {
          board[i][j] = ai;
          float  score = minmax(board, depth + 1, false);
          board[i][j] = -1;
          bestScore = max(score, bestScore);
        }
      }
    return bestScore;  
  }
  else{
     float bestScore = 99999999;
     for(int i = 0;i<3 ;i++ )
       for(int j = 0 ; j<3 ; j++){
         if (board[i][j] == -1) {
          board[i][j] = human;
          float score = minmax(board, depth + 1, true);
          board[i][j] = -1;
          bestScore = min(score, bestScore);
        }
       }
     return bestScore;
  }
}

float checkWinner(){
  float winner = -1;
  for(int i = 0 ; i < 3 ; i++){
    if(board[i][0] != -1){
      if(board[i][0] == board[i][1] && board[i][1] == board[i][2]){
        return board[i][0];
      }
      if(board[0][i] == board[1][i] && board[1][i] == board[2][i]){
        return board[0][i];
      }
    }  
  }
  
  if(board[0][0] == board[1][1] && board[1][1] == board[2][2]){
        return board[1][1];
  }
  if(board[0][2] == board[1][1] && board[1][1] == board[2][0]){
        return board[1][1];
  }
  return winner;
}
