//
//  Tile.h
//  MineSweeper
//
//  Created by Qiaoyuan Deng on 2/3/14.
//  Copyright (c) 2014 Qiaoyuan Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
// tile style
typedef enum{
    tileCovered,
    tileRevealedNotMine,
    tileFlagged,  // mark as mine by player
    tileRevealedMine,
    tileCheated // chect to show tiles
} TileState;

@interface Tile : UIButton

@property (nonatomic) TileState tileState;
@property (nonatomic) int tileId;
@property (nonatomic) int tileNumber;

- (id) initWithId:(int)newId frame:(CGRect)aFrame;
- (int) tileId;
- (int) tileNumber;
- (void) addTileNumber;

@end
