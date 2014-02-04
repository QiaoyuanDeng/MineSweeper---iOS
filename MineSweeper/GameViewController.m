//
//  GameViewController.m
//  MineSweeper
//
//  Created by Qiaoyuan Deng on 2/3/14.
//  Copyright (c) 2014 Qiaoyuan Deng. All rights reserved.
//

#import "GameViewController.h"
#import "MineSweeprGame.h"
#import "Tile.h"

#define MAX_TILE_SIDE 40.00
#define MIN_TILE_SIDE 20.00

@interface GameViewController ()
// pressed button name from main view controller
@property (weak, nonatomic) NSString *buttonName;

// game state view on the left side of window
@property (weak, nonatomic) IBOutlet UIView *GameStateView;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UILabel *minesLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMinesLabel;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
- (IBAction)returnButtonPressed:(UIButton *)sender;
- (IBAction)restartButtonPressed:(UIButton *)sender;
- (IBAction)flagButtonPressed:(UIButton *)sender;

// game view on right side of window
@property (weak, nonatomic) IBOutlet UIView *GameView;
@property (nonatomic, strong) IBOutlet UIButton *cheatButton;
@property (nonatomic, strong) MineSweeprGame *game;
@property (nonatomic) float tileSide;
@property (nonatomic) float blankSide;
- (IBAction)cheatButtonPressed:(UIButton *)sender;

// timer controller for game
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic) int seconds, minutes;

// tile controller
- (IBAction)tilePressed:(UIButton *)sender;

@end

@implementation GameViewController
@synthesize buttonName;
@synthesize GameStateView, returnButton, timerLabel, minutesLabel, colonLabel, secondsLabel;
@synthesize restartButton, minesLabel, leftMinesLabel, flagButton;
@synthesize GameView,cheatButton, game, tileSide, blankSide, timer, seconds, minutes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) segueIsCreated:(NSString *)pressedButtonName{
    buttonName = pressedButtonName;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self newGame];
}

- (void) newGame{
    // init a new game with button name pressed on main menu
    if (game == NULL)
        game = [[MineSweeprGame alloc] init];
    [game setGameWithName:buttonName];
    
    // set defult settings
    seconds = 0;
    minutes = 0;
    [secondsLabel setText:@"00"];
    [minutesLabel setText:@"00"];
    [flagButton setEnabled:YES];
    [flagButton setSelected:NO];
    [[flagButton layer] setBorderWidth:0.0f];
    [restartButton setBackgroundImage:[UIImage imageNamed:@"/ready.gif"]
                             forState:UIControlStateNormal];
    [leftMinesLabel setText:[NSString stringWithFormat:@"%d", game.leftMines]];
    if (game.hardness == Beginner)
        [[cheatButton layer] setBorderWidth:0.0f];
    
    // calculate tile side
    [self makeTileSideWithRow:game.rows Columns:game.columns frame:GameView.frame];
    
    //map tiles
    [self mapTiles];
}

// Set tile side in the range from MIN_TILE_SIDE to MAX_TILE_SIDE
- (void) makeTileSideWithRow: (float)rowNumber Columns:(float)columnNumber frame:(CGRect)aFrame{
    float rows = rowNumber;
    float columns = columnNumber;
    tileSide = MIN(aFrame.size.height/rows, aFrame.size.width/columns);
    if (tileSide > MAX_TILE_SIDE)
        tileSide = MAX_TILE_SIDE;
    if (tileSide < MIN_TILE_SIDE)
        tileSide = MIN_TILE_SIDE;
    
    blankSide  = (aFrame.size.width - columns*tileSide)/2;
    
    if  (blankSide < 0)
        blankSide = 0;
}

// map tiles on the Game View
- (void)mapTiles{
    int tileIndex = 0;
    
    // add tiles on Game View
    for (int i = 0; i < game.rows; i++){
        for (int j = 0; j < game.columns; j++) {
            tileIndex = i*game.columns + j;
            Tile *aTile =[game.tiles objectAtIndex:tileIndex];
            [self drawTile:aTile];
            [aTile addTarget:self
                      action:@selector(tilePressed:)
            forControlEvents: UIControlEventTouchUpInside];
            [aTile setFrame:CGRectMake(blankSide+tileSide*j, tileSide*i, tileSide, tileSide)];
            [[self GameView] addSubview:aTile];
        }
    }
    
    // add cheat button for beginner
    if (game.hardness == Beginner){
        if (blankSide <= 0)
            return;
        
        if (cheatButton == NULL){
            cheatButton = [[UIButton alloc] init];
        }
        
        [cheatButton setEnabled:YES];
        
        int cheatButtonSide = blankSide;
        if (cheatButtonSide > 40)
            cheatButtonSide = 40;
        [cheatButton setImage:[UIImage imageNamed:@"cheat.gif"] forState:UIControlStateNormal];
        [cheatButton setFrame:CGRectMake((blankSide-cheatButtonSide)/2,
                                         (GameView.frame.size.height-cheatButtonSide)/2,
                                         cheatButtonSide,
                                         cheatButtonSide)];
        [[self GameView] addSubview:cheatButton];
        [cheatButton addTarget:self action:@selector(cheatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) drawTile:(Tile *)aTile{
    [[aTile layer] setBorderWidth:1.0f];
    [aTile setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    switch (aTile.tileState) {
        case tileCovered:
            [aTile setBackgroundImage:[UIImage imageNamed:@"/tile.gif"]
                             forState:UIControlStateNormal];
            break;
        case tileRevealedNotMine:
            [self drawTileNumeber:aTile];
            break;
        case tileFlagged:
            [aTile setBackgroundImage:[UIImage imageNamed:@"/flag.gif"]
                             forState:UIControlStateNormal];
            break;
        case tileRevealedMine:
            [aTile setBackgroundImage:[UIImage imageNamed:@"/bombrevealed.gif"]
                             forState:UIControlStateNormal];
            break;
            // for cheating mode
        case tileCheated:
            [aTile setBackgroundImage:[UIImage imageNamed:@"/bombcovered.gif"]
                             forState:UIControlStateNormal];
            break;
        default:
            break;
            
    }
}

- (void) drawTileNumeber:(Tile *)aTile{
    // tile is zero then show a blank
    if (aTile.tileNumber == 0){
        [aTile setTitle:@"" forState:(UIControlStateNormal)];
        [aTile setBackgroundImage:nil forState:UIControlStateNormal];
        [aTile setBackgroundColor:[UIColor whiteColor]];
        [self revealSurroundingNonZeroTileUntilZero:aTile];
        return;
    }
    
    [aTile setTitle:[NSString stringWithFormat:@"%d", aTile.tileNumber]
           forState:UIControlStateNormal];
    [aTile setBackgroundImage:nil forState:UIControlStateNormal];
    [aTile setBackgroundColor:[UIColor whiteColor]];
    
    // different number draws in different color
    switch (aTile.tileNumber) {
        case 1:
            [aTile setTitleColor:[UIColor blueColor]
                        forState:UIControlStateNormal];
            break;
        case 2:
            [aTile setTitleColor:[UIColor greenColor]
                        forState:UIControlStateNormal];
            break;
        case 3:
            [aTile setTitleColor:[UIColor redColor]
                        forState:UIControlStateNormal];
            break;
        case 4:
            [aTile setTitleColor:[UIColor purpleColor]
                        forState:UIControlStateNormal];
            break;
        case 5:
            // Maroon
            [aTile setTitleColor:[UIColor
                                  colorWithRed:128 green:0 blue:0 alpha:1]
                        forState:UIControlStateNormal];
            break;
        case 6:
            // Turquoise
            [aTile setTitleColor:[UIColor
                                  colorWithRed:64 green:224 blue:208
                                  alpha:1]
                        forState:UIControlStateNormal];
            break;
        case 7:
            [aTile setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
            break;
            
            
        case 8:
            [aTile setTitleColor:[UIColor grayColor]
                        forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)revealSurroundingNonZeroTileUntilZero:(Tile *)aTile{
    if (aTile.tileNumber != 0)
        return;
    
    int row = aTile.tileId / game.columns;
    int column = aTile.tileId % game.columns;
    Tile *currentTile;
    
    // does left tile exists
    if (column-1 >= 0 ){
        // is left tile revealed
        currentTile =[game.tiles objectAtIndex:aTile.tileId - 1];
        if (([currentTile tileState]!=tileRevealedNotMine)&&
            ([currentTile tileState]!=tileRevealedMine)){
            [currentTile setTileState:tileRevealedNotMine];
            [self tilePressed:currentTile];
        }
    }
    
    // does right tile exists
    if (column+1 < game.columns ){
        // is right tile revealed
        currentTile =[game.tiles objectAtIndex:aTile.tileId + 1];
        if (([currentTile tileState]!=tileRevealedNotMine)&&
            ([currentTile tileState]!=tileRevealedMine)){
            [currentTile setTileState:tileRevealedNotMine];
            [self tilePressed:currentTile];
        }
    }
    
    // does top tile exists
    if (row-1 >= 0 ){
        // is top tile revealed
        currentTile =[game.tiles objectAtIndex:aTile.tileId - game.columns];
        if (([currentTile tileState]!=tileRevealedNotMine)&&
            ([currentTile tileState]!=tileRevealedMine)){
            [currentTile setTileState:tileRevealedNotMine];
            [self tilePressed:currentTile];
        }
    }
    
    // does bottom tile exists
    if (row+1 < game.rows ){
        // is bottom tile revealed
        currentTile =[game.tiles objectAtIndex:aTile.tileId + game.columns];
        if (([currentTile tileState]!=tileRevealedNotMine)&&
            ([currentTile tileState]!=tileRevealedMine)){
            [currentTile setTileState:tileRevealedNotMine];
            [self tilePressed:currentTile];
        }
    }
}


- (IBAction)tilePressed:(id)aTile{
    NSLog(@"Tile[%d][%d] is pressed",
          [aTile tileId] /game.columns,
          [aTile tileId]%game.columns);
    
    // game starts when player presses a tile at the first time
    // set random mines and tile numbers
    if (game.gameState == ready && game.playSate == reveal){
        [game setGameState:playing];
        
        // set mines randomly
        [game setMinesFrom:0 to:game.rows*game.columns
                   without:[aTile tileId]];
        [game setNonMines];
        
        [self timerStarts];
    }
    
    // player reveals a tile or flags it
    switch (game.playSate) {
        case reveal:
            // tile is mine if tile number is -1
            if ([aTile tileNumber] == -1)
                [aTile setTileState:tileRevealedMine];
            else
                [aTile setTileState:tileRevealedNotMine];
            break;
        case flag:
            [game flagATile];
            [leftMinesLabel setText:[NSString stringWithFormat:@"%d",
                                     game.leftMines]];
            if ([aTile tileState]!=tileRevealedNotMine)
                [aTile setTileState:tileFlagged];
            break;
        default:
            break;
    }
    [self drawTile:aTile];
    
    if ([game isFinished])
        [self gameFinished];
}

- (void) timerStarts{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCounting:) userInfo:nil repeats:YES];
}

- (void) timeCounting:(NSTimer *)aTimer{
    // add one second when it is called
    seconds ++;
    
    // set minute
    if (seconds == 60) {
        minutes ++;
        seconds=0;
        [minutesLabel setText:[NSString stringWithFormat:@"%d", minutes]];
    }
    [secondsLabel setText:[NSString stringWithFormat:@"%d", seconds]];
}

- (void) gameFinished{
    if (game.gameState == lose){
        NSLog(@"Player lose!");
        [restartButton setBackgroundImage:[UIImage imageNamed:@"/lose.gif"] forState:UIControlStateNormal];
    }
    else{
        NSLog(@"Player win!");
        [restartButton setBackgroundImage:[UIImage imageNamed:@"/win.gif"]
                                 forState:UIControlStateNormal];
    }
    
    // show all mines
    for (Tile *aTile in game.mines){
        [aTile setTileState:tileRevealedMine];
        [self drawTile:aTile];
    }
    
    for (Tile *aTile in game.tiles){
        [aTile setEnabled:NO];
    }
    
    [timer invalidate];
    [flagButton setEnabled:NO];
    if (cheatButton != NULL)
        [cheatButton setEnabled:NO];
}

- (IBAction)cheatButtonPressed:(UIButton *)sender {
    if (game.gameState == ready)
        return;
    NSLog(@"cheat button pressed");
    
    if (cheatButton.selected){
        NSLog(@"Unselect cheat button");
        if (game.mines.count == 0)
            return;
        for (Tile *aTile in game.mines){
            [aTile setTileState:tileCovered];
            [self drawTile:aTile];
            [[cheatButton layer] setBorderWidth:0.0f];
        }
        [cheatButton setSelected:NO];
    }else {
        NSLog(@"Select cheat button");
        [[cheatButton layer] setBorderWidth:1.0f];
        if (game.mines.count == 0)
            return;
        for (Tile *aTile in game.mines){
            [aTile setTileState:tileCheated];
            [self drawTile:aTile];
        }
        [cheatButton setSelected:YES];
    }
}

- (IBAction)returnButtonPressed:(UIButton *)sender {
    [cheatButton removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)restartButtonPressed:(UIButton *)sender {
    // clean Game View before use
    if ([GameView subviews].count != 0){
        for (UIView *subView in [GameView subviews]){
            [subView removeFromSuperview];
        }
    }
    [timer invalidate];
    timer = nil;
    [self newGame];
}

- (IBAction)flagButtonPressed:(UIButton *)sender {
    if (game.playSate == flag){
        [flagButton setSelected:NO];
        [[flagButton layer] setBorderWidth:0.0f];
        game.playSate = reveal;
        return;
    }
    
    [flagButton setSelected:YES];
    [[flagButton layer] setBorderWidth:1.0f];
    game.playSate = flag;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
