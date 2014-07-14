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
        
        _energyBar = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(size.width/3 - 20,size.height/10)];
        [_energyBar setAnchorPoint:CGPointMake(0.5,0.5)];
        [_energyBar setAlpha:0.8];
        [_energyBar setPosition:CGPointMake(0, size.height*9/20-8)];
        [_energyBar addChild:[barBackground copy]];
        
        _nutrientsBar = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(size.width/3 - 20,size.height/10)];
        [_nutrientsBar setAnchorPoint:CGPointMake(0.5,0.5)];
        [_nutrientsBar setAlpha:0.8];
        [_nutrientsBar setPosition:CGPointMake(size.width/3, size.height*9/20-8)];
        [_nutrientsBar addChild:[barBackground copy]];
        
        [self addChild:_healthBar];
        [self addChild:_energyBar];
        [self addChild:_nutrientsBar];
    }
    return self;
}

- (void) redraw:(CGSize) oldSize
{
    CGSize size = self.scene.size;
    [_healthBar setXScale:[_healthBar xScale]*size.width/oldSize.width];
    [_healthBar setYScale:[_healthBar yScale]*size.height/oldSize.height];
    [_healthBar setPosition:CGPointMake(-size.width/3, size.height*9/20-8)];
    
    [_energyBar setXScale:[_energyBar xScale]*size.width/oldSize.width];
    [_energyBar setYScale:[_energyBar yScale]*size.height/oldSize.height];
    [_energyBar setPosition:CGPointMake(0, size.height*9/20-8)];
    
    [_nutrientsBar setXScale:[_nutrientsBar xScale]*size.width/oldSize.width];
    [_nutrientsBar setYScale:[_nutrientsBar yScale]*size.height/oldSize.height];
    [_nutrientsBar setPosition:CGPointMake(size.width/3, size.height*9/20-8)];
}

@end
