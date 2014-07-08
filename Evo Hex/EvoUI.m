//
//  EvoUI.m
//  Evo Hex
//
//  Created by Steven Buell on 7/2/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoUI.h"

@implementation EvoUI

- (EvoUI *) initWithSize:(CGSize)size
{
  self = [super init];
  if (self) {
    SKSpriteNode *barBackground = [[SKSpriteNode alloc] initWithColor:[SKColor darkGrayColor] size:CGSizeMake(size.width/3 - 12,size.height/10 + 8)];
    [barBackground setAlpha: 0.75];
    [barBackground setAnchorPoint:CGPointMake(0.5,0.5)];
    [barBackground setZPosition:-1];
    
    _healthBar = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(size.width/3 - 20,size.height/10)];
    [_healthBar setAnchorPoint:CGPointMake(0.5,0.5)];
    [_healthBar setAlpha:0.8];
    [_healthBar setPosition:CGPointMake(-size.width/3, size.height*9/20-8)];
    [_healthBar addChild:[barBackground copy]];
    
    _manaBar = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(size.width/3 - 20,size.height/10)];
    [_manaBar setAnchorPoint:CGPointMake(0.5,0.5)];
    [_manaBar setAlpha:0.8];
    [_manaBar setPosition:CGPointMake(0, size.height*9/20-8)];
    [_manaBar addChild:[barBackground copy]];
    
    _fatigueBar = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(0,size.height/10)];
    [_fatigueBar setAnchorPoint:CGPointMake(0.5,0.5)];
    [_fatigueBar setAlpha:0.8];
    [_fatigueBar setPosition:CGPointMake(size.width/3, size.height*9/20-8)];
    [_fatigueBar addChild:[barBackground copy]];
    
    [self addChild:_healthBar];
    [self addChild:_manaBar];
    [self addChild:_fatigueBar];
  }
  return self;
}

- (void) redraw:(CGSize) oldSize
{
    CGSize size = self.scene.size;
    [_healthBar setXScale:[_healthBar xScale]*size.width/oldSize.width];
    [_healthBar setYScale:[_healthBar yScale]*size.height/oldSize.height];
    [_healthBar setPosition:CGPointMake(-size.width/3, size.height*9/20-8)];
    
    [_manaBar setXScale:[_manaBar xScale]*size.width/oldSize.width];
    [_manaBar setYScale:[_manaBar yScale]*size.height/oldSize.height];
    [_manaBar setPosition:CGPointMake(0, size.height*9/20-8)];
    
    [_fatigueBar setXScale:[_fatigueBar xScale]*size.width/oldSize.width];
    [_fatigueBar setYScale:[_fatigueBar yScale]*size.height/oldSize.height];
    [_fatigueBar setPosition:CGPointMake(size.width/3, size.height*9/20-8)];
}

@end
