// 0 = purple, 1 = blue, 2 = green, 3 = yellow, 4 = orange, 5 = red
//color[] colorChoiceRollOver = {#9E63C9,#6CACDB,#4A8642,#FFF27E,#F5CE79,#F57D79};

class MasterCode
{
  int [] code = {-1,-1,-1,-1};
  boolean [] correct = new boolean[4];
  final int FOR_COUNTER_4 = 4;
  
  MasterCode()
  {
    for(int x = 0; x < FOR_COUNTER_4; x++)
    {
      code[x] = int(random(0,6));
      correct[x] = false;
      if(x > 0)
        if(code[x] == code[x-1])
          x--;  
    }
  }
  
  int getCode(int x)
  {
    return code[x];
  }
  
  int checkCode(int x, int guess)
  {
    if(code[x] == guess)
    {
      correct[x] = true;
      return 1;
    }
    else
      return 0;
  }
  
  int checkCode(int guess)
  {
    int check = 0;
    for(int x = 0; x < FOR_COUNTER_4; x++)
      if(!correct[x])
      {
        if(code[x] == guess)
        {
          check = 2;
          correct[x] = true;
          break;
        }
        else
        {
          check = 0;
        }
      }
    return check;
  }
  
  void resetCorrect()
  {
    for(int x = 0; x < FOR_COUNTER_4; x++)
      correct[x] = false;
  }
}