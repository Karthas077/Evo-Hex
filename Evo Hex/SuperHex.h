//
//  SuperHex.h
//  Evo Hex
//
//  Created by Steven Buell on 6/30/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HexProtocol.h"

@interface SuperHex : SKNode <HexProtocol>

@property (nonatomic) CGPoint gridLoc;

- (void) setGridLoc:(CGPoint) pos;

@end