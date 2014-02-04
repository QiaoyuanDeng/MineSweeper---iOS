//
//  MineSweeprGame.h
//  MineSweeper
//
//  Created by Qiaoyuan Deng on 2/3/14.
//  Copyright (c) 2014 Qiaoyuan Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineSweeprGame : NSObject
typedef enum {
    Beginner,
    Intermediate,
    Expert
}Hardness;

typedef enum {
    ready,
    playing,
    win,
    lose
} GameState;

typedef enum{
    reveal,
    flag
}PlayState;

@property (nonatomic) Hardness hardness;
@property (nonatomic) GameState gameState;
@property (nonatomic) PlayState playSate;
@property (nonatomic) int rows, columns, minesNumber, leftMines;
@property (nonatomic, strong) NSMutableArray *tiles;
@property (nonatomic, strong) NSMutableArray *mines;

- (id) init;
- (void) setGameWithName:(NSString *)aName;
- (void) setMinesFrom:(int)startNumber
                   to:(int)endNumber
              without:(int)exceptNumber;
- (void) setNonMines;
- (BOOL) isFinished;
- (void) flagATile;
- (void) clean;

@end
