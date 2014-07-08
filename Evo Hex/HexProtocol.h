//
//  HexProtocol.h
//  Evo Hex
//
//  Created by Steven Buell on 6/30/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HexProtocol <NSObject>

@required
- (void) setAnchorPoint:(CGPoint)anchorPoint;
- (void) setPosition:(CGPoint)position;
- (void) setGridLoc:(CGPoint)gridLoc;
- (CGPoint) getGridLoc;

@end
