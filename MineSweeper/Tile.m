//
//  Tile.m
//  MineSweeper
//
//  Created by Qiaoyuan Deng on 2/3/14.
//  Copyright (c) 2014 Qiaoyuan Deng. All rights reserved.
//

#import "Tile.h"

@implementation Tile
@synthesize tileId, tileState, tileNumber;

- (id) initWithId:(int)newId frame:(CGRect)aFrame{
    self = [super initWithFrame:aFrame];
    tileId = newId;
    [self setTileState:tileCovered];
    tileNumber = 0;
    return self;
}

- (int) tileId{
    return tileId;
}

- (int) tileNumber{
    return tileNumber;
}

- (void) addTileNumber{
    tileNumber ++;
}

@end
