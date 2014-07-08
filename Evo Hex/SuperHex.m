//
//  SuperHex.m
//  Evo Hex
//
//  Created by Steven Buell on 6/30/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "SuperHex.h"

@implementation SuperHex

#pragma mark - Initialization
- (SuperHex *)init
{
    self = [super init];
	return self;
}

-(void) setAnchorPoint:(CGPoint)anchorPoint
{
  return;
}

-(void) setPosition:(CGPoint)position
{
  [super setPosition:position];
}

-(void) setGridLoc:(CGPoint)gridLoc
{
    _gridLoc = CGPointMake(gridLoc.x + self.position.x, gridLoc.y + self.position.y);
}

-(CGPoint) getGridLoc
{
    return _gridLoc;
}

@end
