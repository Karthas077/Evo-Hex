//
//  EvoAIManager.m
//  Evo Hex
//
//  Created by Steven Buell on 7/14/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoAIManager.h"

@implementation EvoAIManager

@synthesize creatures;
@synthesize numCreatures;

+ (id) AIManager
{
    static EvoAIManager *AIManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AIManager = [[self alloc] init];
    });
    return AIManager;
}

- (id) init
{
    self = [super init];
    if (self) {
        creatures = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void) addCreature:(EvoCreature *)creature
{
    [creatures addObject:creature];
}

- (void) update
{
    for (EvoCreature *creature in [creatures allObjects]) {
        [[EvoScriptManager scriptManager] startScriptNamed:@"attack" withSource:creature];
        [[EvoScriptManager scriptManager] startScriptNamed:@"heal" withSource:creature];
        
        
        
        //[[EvoScriptManager scriptManager] startScriptNamed:@"wander" withSource:creature];
    }
}

@end
