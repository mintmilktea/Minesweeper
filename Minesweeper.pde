import de.bezier.guido.*;
public static final int NUM_ROWS = 16;
public static final int NUM_COLS = 16;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
   for(int i = 0; i<25; i++){
    setMines();
   }
}
public void setMines()
{
  int row = (int)(Math.random() * NUM_ROWS);
  int col = (int)(Math.random() * NUM_COLS);
  if(!mines.contains(buttons[row][col])){
  mines.add(buttons[row][col]);
  }else setMines();
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(!buttons[r][c].clicked && !mines.contains(buttons[r][c])){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
  for(int i = 0; i < mines.size(); i++){
     if(mines.get(i).flagged == true){
     mines.get(i).flagged = false;
     }
     mines.get(i).clicked = true;
  }
  
  String lose = "YOU LOSE YOU LOS";
  
  for(int i = 0; i < NUM_ROWS; i++){
    for(int j = 0; j < lose.length(); j++){
      buttons[i][j].setLabel(lose.substring(j, j+1));
    }
  }
    
}
public void displayWinningMessage()
{
  String win = "YOU WIN YOU WIN ";
  
  for(int i = 0; i < NUM_ROWS; i++){
    for(int j = 0; j < win.length(); j++){
      buttons[i][j].setLabel(win.substring(j, j+1));
    }
  }
}
public boolean isValid(int r, int c)
{
    return (r < NUM_ROWS && r >=0) && (c < NUM_COLS && c >=0);
   
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row - 1; r < row + 2; r++){
    for(int c = col - 1; c < col + 2; c++){
      if(isValid(r, c)){
        if(mines.contains(buttons[r][c]) && !(r == row && c == col)){
          numMines++;
        }
      }
    }
  }return numMines;
}

    

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT){
          flagged = !flagged;
            if(flagged == false){
              clicked = false;
            }
        }else if(mines.contains(this)){
      displayLosingMessage();
    }else if (countMines(myRow, myCol) > 0){
      setLabel(countMines(myRow, myCol));
    }else{
      for(int r = myRow - 1; r < myRow + 2; r++){
        for(int c = myCol - 1; c < myCol + 2; c++){
          if(isValid(r, c) && !buttons[r][c].clicked){
             buttons[r][c].mousePressed();
          }
        }
      }
    }
    
  }
    
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
