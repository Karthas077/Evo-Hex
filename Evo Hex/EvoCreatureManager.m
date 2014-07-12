//
//  EvoCreatureManager.m
//  Evo Hex
//
//  Created by Steven Buell on 7/9/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoCreatureManager.h"

@implementation EvoCreatureManager

@synthesize creatures;

#pragma mark Singleton Methods

+ (id) creatureManager
{
    static EvoCreatureManager *creatureManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        creatureManager = [[self alloc] init];
    });
    return creatureManager;
}


- (id) init
{
    self = [super init];
    if (self) {
        _numCreatures = 1;
        _numParts = 3;
    }
    return self;
}

- (EvoCreature *) spawnCreature
{
    EvoCreature *newCreature = [[EvoCreature alloc] initWithID:_numCreatures];
    _numCreatures++;
    
    EvoBodyPart *larm = [[EvoBodyPart alloc] initWithID:_numParts];
    [larm setType:@"fighting"];
    [larm setFunction:@"strike"];
    _numParts++;
    EvoBodyPart *rarm = [[EvoBodyPart alloc] initWithID:_numParts];
    [rarm setType:@"fighting"];
    [rarm setFunction:@"strike"];
    _numParts++;
    EvoBodyPart *mouth = [[EvoBodyPart alloc] initWithID:_numParts];
    [mouth setType:@"fighting"];
    [mouth setFunction:@"bite"];
    _numParts++;
    
    [newCreature attachPart:larm];
    [newCreature attachPart:rarm];
    [newCreature attachPart:mouth];
    
    
    [newCreature setName:@"Computer"];
    [newCreature setTexture:[SKTexture textureWithImageNamed:@"Bear_Sprite.png"]];
    [newCreature setScale:0.5];
    [newCreature setZPosition:10];
    
    return newCreature;
}

@end
