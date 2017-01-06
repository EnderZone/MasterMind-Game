// 0 = purple, 1 = blue, 2 = green, 3 = yellow, 4 = orange, 5 = red
//color[] colorChoiceRollOver = {#9E63C9,#6CACDB,#4A8642,#FFF27E,#F5CE79,#F57D79};

class Player
{
  int [] guess = {-1,-1,-1,-1};
  
  Player()
  {
  }
  
    void pickGuess(int x)
  {
           if(guess[x] == -1)
           {
             if(mouseY > 0 && mouseY < 112)
                 guess[x] = 0;
             else if (mouseY > 112 && mouseY < 224)
                 guess[x] = 1;
             else if (mouseY > 224 && mouseY < 336)
                 guess[x] = 2;
             else if (mouseY > 336 && mouseY < 448)
                 guess[x] = 3;
             else if (mouseY > 448 && mouseY < 560)
                 guess[x] = 4;
             else if (mouseY > 560 && mouseY < 672)
                 guess[x] = 5; 
           }
           
   }
  
  void resetGuess()
  {
    for(int x = 0;x < guess.length; x++)
      guess[x] = -1;
  }
  
  int getGuess(int x)
  {
    if(x >= 0 && x < guess.length)
      return guess[x];
    else
      return -1;
  }
}
