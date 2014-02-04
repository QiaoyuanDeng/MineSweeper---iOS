//
//  MineSweeprGame.m
//  MineSweeper
//
//  Created by Qiaoyuan Deng on 2/3/14.
//  Copyright (c) 2014 Qiaoyuan Deng. All rights reserved.
//

#import "MineSweeprGame.h"
#import "Tile.h"

@interface MineSweeprGame()
@end

@implementation MineSweeprGame
@synthesize hardness,gameState, playSate;
@synthesize rows, columns, minesNumber, leftMines;
@synthesize tiles, mines;

- (id) init{
    self = [super init];
    if (self.tiles == NULL)
        self.tiles = [[NSMutableArray alloc] init];
    if (self.mines == NULL)
        self.mines = [[NSMutableArray alloc] init];
    return self;
}

- (void) setGameWithName:(NSString *)aName{
    // get hardness to set game tiles and mines
    if ([aName isEqualToString:@"Beginner"]){
        rows = 8;
        columns = 8;
        minesNumber = 10;
    }
    else if ([aName isEqualToString:@"Intermediate"]) {
        rows = 8;
        columns = 12;
        minesNumber = 15;
    }
    else if ([aName isEqualToString:@"Expert"]) {
        rows = 10;
        columns = 15;
        minesNumber = 30;
    }
    
    gameState = ready;
    playSate = reveal;
    leftMines = minesNumber;
    
    // clean data before use
    [self clean];
    
    // create tiles
    for (int i = 0; i < self.rows; i++){
        for (int j = 0; j< self.columns; j++){
            Tile *aTile = [[Tile alloc] initWithId:i*self.columns+j
                                             frame:CGRectMake(0, 0, 0, 0)];
            [self.tiles addObject:aTile];
        }
    }
}

- (void) setMinesFrom:(int)startNumber
                   to:(int)endNumber
              without:(int)exceptNumber{
    int randNumber;
    BOOL isRepeated = 0;    // is there two same randomed numbers
    int i = 0;
    
    // error if mines are more than tiles
    if (minesNumber >= rows * columns){
        NSLog(@"Error: Mine number is larger than tile number");
        return;
    }
    
    while (i < minesNumber){
        // get random number from 0 to tiles number
        randNumber = startNumber + arc4random() % (endNumber - startNumber);
        
        // is this a repeated number?
        if (randNumber == exceptNumber)
            isRepeated = 1;
        else for (Tile *aTile in mines){
            if (randNumber == [aTile tileId])
                isRepeated = 1;
        }
        
        // if not repeated, record it as -1 in tile number
        if (isRepeated == 0){
            [[tiles objectAtIndex:randNumber] setTileNumber:-1];
            if ((int)mines.count <= i)
                [mines addObject:[tiles objectAtIndex:randNumber]];
            else
                [mines replaceObjectAtIndex:i withObject:[tiles objectAtIndex:randNumber]];
            i++;
        }
        else{
            isRepeated = 0;
        }
    }
}

- (void)setNonMines{
    int row, column;
    for (Tile *aMine in mines){
        int  aMineId= [aMine tileId];
        row = aMineId / columns;
        column = aMineId % columns;
        
        for (int i = -1; i < 2; i++){
            for (int j = -1; j < 2; j++){
                if (row+i>=0 && row+i<rows)
                    if (column+j>=0 && column+j<columns)
                        if ([[tiles objectAtIndex:(row+i)*columns+column+j] tileNumber]!=-1)
                            [[tiles objectAtIndex:(row+i)*columns+column+j] addTileNumber];
            }
        }
    }
}

- (void) flagATile{
    leftMines --;
    if (leftMines < 0)
        leftMines = 0;
}

- (BOOL)isFinished{
    // is player failed?
    for (Tile *aTile in tiles){
        if (aTile.tileState == tileRevealedMine){
            gameState = lose;
            return YES;
        }
    }
    
    // is player won?
    int coverTiles = 0;
    
    for (Tile *aTile in tiles){
        if (aTile.tileState == tileCovered || aTile.tileState == tileFlagged ||aTile.tileState == tileCheated){
            coverTiles ++;
        }
    }
    if (coverTiles == minesNumber){
        gameState = win;
        return YES;
    }
    
    return NO;
}


- (void) clean{
    [tiles removeAllObjects];
    [mines removeAllObjects];
}
@end
