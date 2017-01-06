/*
 * Name: Arenas, Enzo 
 * Program: MasterMind
 * Date: 1/6/15
 */
 
//------------------------Global variables/Objects Declarations-------------------------------------// 
// All Colors needed
color[] colorChoice = {#871EC9, #268BDB, #238617, #FFEA00, #F7B014, #F71C14};
color[] colorChoiceRollOver = {#9E63C9, #6CACDB, #6AC160, #FFF27E, #F5CE79, #F57D79};
color[] titlePalette = {#00B1F0, #5300F0, #A077F0};
color[] resetButton = {#E327B4, #E370C6};

//Arrays used to help with the math of the program along with some logistics
//
int[][] pGuesses = new int[4][10];
int [] check = new int[4];

//Used for "gates" to restrict player until certain requirements are meet
boolean [] info = {false, false, false, false};
boolean win = false;
boolean title = true;

//Logistic integer variables to help with math and actually drawing onto the screen
int guess = 0;
int pGuessY = 0;

//Commonly used counters for 'for' loops
final int FOR_COUNTER_4 = 4;
final int FOR_COUNTER_6 = 6;
final int FOR_COUNTER_10 = 10;

//All Objects Declarations
Player player;
MasterCode masterCode;
PFont win_Font;
PFont title_Font;

//-----------------------------Basic Setup---------------------------//
/*
 * setup() - used to intialize all objects and to fill large arrays
 */
void setup()
{
  //Screen Setup
  size(600, 768);
  background(255);
  
  //Fonts intialiazed
  title_Font = createFont("Andalus", 48);
  win_Font = createFont("BookAntiqua", 48);
  
  //objects intialized
  player = new Player();
  masterCode = new MasterCode();

  //For loop to fill the double array with empty placeholder variables
  for (int x = 0; x < FOR_COUNTER_4; x++)
    for (int y : pGuesses[x])
      pGuesses[x][y] = 0;
}//End of setup()

/*
 * draw() - the draw method is only used to call the basic drawing methods
 */
void draw()
{
  //if-else statment to end game when user has lost or won
  if (win)
  {
  } 
  else
  {
    drawGameBoard();
    rollOver();
  }
}//end of draw()

//------------------------------------User Interactivity--------------------------------------------------------//
/*
 * mousePressed() - the interactive componet of the program; used for basically everything that involves the user
 *                  clicking a button and sends the program to the correct method depending on what button was 
 *                  clicked
 */
void mousePressed()
{
  //initial if-else statment for only certain buttons responding when they are actually displated on the screen
  //for when the game is cleared/lost
  if (win)
  {
  } 
  //for the buttons on the title screen
  else if(title)
  {
    //If the 'PLAY' button was pressed; the game will exit the title screen and the game will be playable
    if(mouseX > width/3-25 && mouseX < width/3+215 && mouseY > height/2 && mouseY < height/2 + 100)
    {
      title = !title;
      background(255);
    }
  }
  //for the buttons on the actually gameboard
  else
  {
    //if the user has clicked a button involving choosing a color or entering their answer
    if (mouseX < 300)
    {
      //If the player has clicked the 'ENTER' button meaning they want ot sumbit
      //their guess; sends program to 'transit method'
      if (guess == 3 && mouseX < 300 && mouseY > 672)
        doneGuess();
      //if there is an empty slot before the current guess, the program will reset the guess conunter
      //to make the next guess go into the empty slot
      else if ((player.getGuess(guess) == -1 && guess == 0) || player.getGuess(0) == -1)
        guess = 0;
      //if the current guess is filled already, then move towards the next guess
      else if(mouseX < 96 && player.getGuess(guess) != -1)
        guess++;
      //if the user has inputted a guess and ther is a free slot, the program will add the color choosen into
      //the choice array inside the Player Object 
      if (guess != 4)
      {  
        player.pickGuess(guess);
        //ensures the player has clicked a color and that the player can make a guess
        if(mouseX < 96 && pGuessY < 10)        
          setGuesses(guess);
      }
    } 
    //if the user has clicekd the 'RESET' button; then emptys all of their current choice to pick new ones 
    else if (mouseY > 672 )
      resetGuess();
  }
}//end of mousePressed()

/*
 * rollOver() - This interactive method is called when the user scrolls over a button; when this occurs
 *              the program will provide and output to show you that the button is clickable
 */
void rollOver()
{
  //For all buttons located in the title Screen
  if(title)
  {
    //when the mosue is over the 'PLAY' button, it will be highlighted
    if(mouseX > width/3-25 && mouseX < width/3+215 && mouseY > height/2 && mouseY < height/2 + 100)
    {
      //changes color of button
      fill(titlePalette[2]);
      rect(width/3 - 25, height/2, 240, 100);
      //reversed color of text to make it stand out more
      fill(0);
      textFont(win_Font);
      text("PLAY",width/3+20,height/2+67);
    }
  }
  //For all buttons located on the game board
  else
  {
    //for color choices -- checks every button to see which one the mouse is over
    for (int x = 0; x < FOR_COUNTER_6; x++)
      //ensures the mouse in the correct X position
      if (mouseX < 96)
        //procedurally checks every button to locate which the user has hovered over
        if (mouseY > x*(112) && mouseY < x*(112)+112)
        {
          //changes color of button
          fill(colorChoiceRollOver[x]);
          rect(0, x*(112), 96, 112);
        }  
    //If the user has his mouse over the 'ENTER' button, it will light up
    if (mouseX < 300 && mouseY > 672)
    {
      //Changes color of button
      fill(80);
      rect(0, 672, 300, 96);
      //rewrites the 'ENTER' font
      textFont(win_Font);
      fill(255);
      textSize(76);
      text("ENTER", 25, 747);
    } 
    //If the user has his mouse over the 'RESET' button, it will light up
    else if (mouseX > 300 && mouseY > 672)
    {
      //Changes color of button
      fill(resetButton[1]);
      rect(300, 672, 300, 96);
      //rewrites the 'RESET' font
      textSize(76);
      fill(0);
      text("RESET", 325, 747);
    }
  }
}//end of rollOver()

//-----------------------------------Drawing Methods------------------------------------------------------//
/*
 * drawGameBoard() - This methods draws the game board where the user will try to answer an unknown code and 
 *                   in a limited amount of guess
 */
void drawGameBoard()
{
  //if the game is still on the title screen; skip drawing gameboard and go to drawTitleScreen()
  if (title)
    drawTitleScreen();
  else
  {
    //Initial setup for drawing
    stroke(0);
    noFill();
    strokeWeight(3);
    rectMode(CORNER);

    //Adds a border to the game board
    rect(0, 0, width-1, height-1);

    //Encases the area where the has to click on to select a color
    rect(0, 0, 96, height-1);

    //Line seperator between guess/answer
    line(0, 672, width, 672);

    //Line Seperator for every previous guess
    for (int x = 0; x < FOR_COUNTER_10; x++)
    {
      line(96, 67.2*x, width, 67.2*x);
      line(96, (67.2*x)+33.6, 192, (67.2*x)+33.6);
    }

    //Line seperator for the previous guess corrections
    line(192, 0, 192, height);
    //Spilts the info lines into halves
    line(144, 0, 144, 672);
    //Splits the info lines into quarters
    for (int x = 1; x <= 4; x++)
      line(192+(x*102), 0, 192+(x*102), height);

    //Draws in all of the color choices and fills them in with their respective colors
    for (int x = 0; x < FOR_COUNTER_6; x++)
    {
      fill(colorChoice[x]);
      rect(0, x*(112), 96, 112);
    }

    //This final section is dedicated to the font on the 'ENTER' and 'RESET' buttons
    //Font that will used(same as win/lose screen font
    textFont(win_Font);
    
    //"ENTER" button
    fill(50);
    rect(0, 672, 300, 96);
    fill(255);
    textSize(76);
    text("ENTER", 25, 747);

    //'RESET' button
    fill(resetButton[0]);
    rect(300, 672, 300, 96);
    fill(0);
    text("RESET", 325, 747);

    //noFill in case the fill crosses over into an unwanted area
    noFill();
  }
}//End of drawGameBoard()

/*
 *  drawTitleScreen() - This method is used to draw the main menu of the game
 */
void drawTitleScreen()
{
  //For the background/Basic setup
  fill(titlePalette[0]);
  rectMode(CORNER);
  rect(0, 0, width-1, height-1);
  
  //Title/Subtitle
  fill(0);
  textFont(title_Font);
  text("MasterMind", width/3 - 25, height/4);
  textSize(24);
  text("By:  Enzo Arenas", width/3 + 10, height/3);

  //'PLAY' button
  fill(titlePalette[1]);
  rect(width/3 - 25, height/2,240, 100);
  fill(255);
  textFont(win_Font);
  text("PLAY",width/3+20,height/2+67);
}//end of drawTitleScreen


/*
 * setGuesses(int x) - this draw method is used to display the choices the user has inputted onto the gameboard
 */
void setGuesses(int x)
{
  //Grabs the color chosen for that specific slot (stored in the Player object) and stores it into the pGuesses 2D array
  pGuesses[x][pGuessY] = player.getGuess(x);
  
  //Basic draw setup
  rectMode(CORNER);
  noStroke();
  
  //Using the newly acquired number, the program will display the color that represents that number
  //---picks the color--//
  //purple was chosen
  if (pGuesses[x][pGuessY] == 0)
    fill(colorChoice[0]);
  //blue was chosen
  else if (pGuesses[x][pGuessY] == 1)
    fill(colorChoice[1]);
  //green was chosen
  else if (pGuesses[x][pGuessY] == 2)
    fill(colorChoice[2]);
  //yellow was chosen
  else if (pGuesses[x][pGuessY] == 3)
    fill(colorChoice[3]);
  //orange was chosen
  else if (pGuesses[x][pGuessY] == 4)
    fill(colorChoice[4]);
  //red was chosen
  else if (pGuesses[x][pGuessY] == 5)
    fill(colorChoice[5]);
  //if the chocie was resetted, changes it back to white
  else
    fill(255); 

  //Draw the square with the color chosen
  //for first coloum
  if (pGuessY == 0)    
    rect(192+(x*102), 66*pGuessY, 102, 66);
  //for every folowing coloumn (since a strokeWeight of 3 was used, was necessary to space the color boxs out more
  else
    rect(192+(x*102), 67*pGuessY, 102, 68);
    
}//End of setGuesses(int x)

/*
 * drawInfo() - displays what colors the user has guessed correctly and what colors were correct but in the wrong column
 */
void drawInfo()
{
  //checks to see if any of the choices were correct; if so then add a balck box to an open info slot
  for (int x = 0; x < FOR_COUNTER_4; x++)
  {
    switch(check[x])
    {
      //if the choice was absolutley correct(in the correct spot)
      case 1:
      {
        //lighter black to signify it is correct
        fill(20);
        //fill in top right corner if empty
        if (!info[0])
        {
          rect(96, (pGuessY-1)*67.2, 48, 33.6);
          info[0] = !info[0];
        } 
        //fill in top left box if empty
        else if (!info[1])
        {
          rect(144, (pGuessY-1)*67.2, 48, 33.6);
          info[1] = !info[1];
        } 
        //fill in bottom right box if empty
        else if (!info[2])
        {
          rect(96, (pGuessY-1)*67.2+33.6, 48, 33.6);
          info[2] = !info[2];
        } 
        //fill in bottom left box
        else
        {
          rect(144, (pGuessY-1)*67.2+33.6, 48, 33.6);
          info[3] = !info[3];
        }
        continue;
      }
       //if only the color was correct correct(in the wrong spot)
      case 2:
      {
        fill(150);
        //fill in top right box if empty
        if (!info[0])
        {
          rect(96, (pGuessY-1)*67.2, 48, 33.6);
          info[0] = !info[0];
        }
        //fill in top left box if empty
        else if (!info[1])
        {
          rect(144, (pGuessY-1)*67.2, 48, 33.6);
          info[1] = !info[1];
        } 
        //fill in bottom right box if empty
        else if (!info[2])
        {
          rect(96, (pGuessY-1)*67.2+33.6, 48, 33.6);
          info[2] = !info[2];
        } 
        //fill in bottom left box
        else
        {
          rect(144, (pGuessY-1)*67.2+33.6, 48, 33.6);
          info[3] = !info[3];
        }
        continue;
      }
      default:
      {
        continue;
      }
    }
  }
}//end of drawInfo()

//------------------------------'Transit Methods'-------------------------------------//
/*
 * doneGuess() - the only transit method; which is a mehtod dedicated to calling upon
 *               other methods in a specified order
 */
void doneGuess()
{
  //moves guess to next column
  pGuessY++;
  //resets guess counter
  guess = 0;
  //check checkGuess()
  checkGuess();
  //check resetGuess()
  player.resetGuess();
  //check resetInfo()
  resetInfo();
  //check checkWin()
  checkWin();
}//end of doneGuess()


//----------------------Logistic Methods--------------------------//
void checkGuess()
{
  for (int x = 0; x < FOR_COUNTER_4; x++)
  {
    check[x] = masterCode.checkCode(x, player.getGuess(x));
  }

  for (int x = 0; x < FOR_COUNTER_4; x++)
  {
    if (check[x] != 1)
    {
      check[x] = masterCode.checkCode(player.getGuess(x));
    }
  }
  masterCode.resetCorrect();
  drawInfo();
}

//------------------------------Reseting Methods----------------------------//

void resetInfo()
{
  for (int x = 0; x < FOR_COUNTER_4; x++)
  {
    info[x] = false;
  }
}

void resetGuess()
{
  player.resetGuess();
  for (int x = 0; x < FOR_COUNTER_4; x++)
    setGuesses(x);
}


//--------------------------Game Clearing Methods------------------------//
void checkWin()
{
  textFont(win_Font);
  if (check[0] == 1 && check[1] == 1 && check[2] == 1 && check[3] == 1)
  {
    pGuessY = 11;
    win = !win;
    background(255);
    text("You Win!!", width/4+20, height/2 - 100);
    text("The Code", width/4+20, height/2 + height/10 - 100);
    for (int x = 0; x < FOR_COUNTER_4; x++)
    {
      fill(colorChoice[masterCode.getCode(x)]);
      rect(20+(x*150), 450, 100, 50);
    }
  }
  if (pGuessY == 10)
    userLost();
}

void userLost()
{
  fill(0);
  textFont(win_Font);
  background(255);
  text("You Lost", width/4+23, height/2 - 100);
  text("The Code", width/4+20, height/2 + height/10 - 100);
  for (int x = 0; x < FOR_COUNTER_4; x++)
  {
    fill(colorChoice[masterCode.getCode(x)]);
    rect(20+(x*150), 450, 100, 50);
  }
  win = !win;
}