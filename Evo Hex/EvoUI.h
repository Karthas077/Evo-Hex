//
//  EvoUI.h
//  Evo Hex
//
//  Created by Steven Buell on 7/2/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EvoUI : SKNode

@property SKSpriteNode *healthBar;
@property SKSpriteNode *biomassBar;
@property SKSpriteNode *staminaBar;

- (EvoUI *) initWithSize:(CGSize)size;

- (void) redraw:(CGSize)oldSize;

@end
