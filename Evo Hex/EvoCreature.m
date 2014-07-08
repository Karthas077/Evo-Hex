//
//  EvoCreature.m
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoCreature.h"

@implementation EvoCreature

- (EvoCreature *) initWithID:(NSUInteger) ID
{
    self = [super init];
    if (self) {
        _bodyParts = [[NSHashTable alloc] init];
        _evolutions = [[NSHashTable alloc] init];
        _creatureID = ID;
        _nextID = 1;
        
    }
    return self;
}

- (void) attachPart:(EvoBodyPart *) part
{
    [part setID:_nextID];
    [part attachToCreature:self];
    [_bodyParts addObject:part];
    _nextID++;
}

- (void) removePart:(EvoBodyPart *) part
{
    [part remove];
    [_bodyParts removeObject:part];
}

- (void) evolve:(EvoEvolution *) evolution
{
    [evolution addToCreature:self];
    [_evolutions addObject:evolution];
}

- (void) devolve:(EvoEvolution *) evolution
{
    [evolution removeFromCreature];
    [_evolutions removeObject:evolution];
}


@end
