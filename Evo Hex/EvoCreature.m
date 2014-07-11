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
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"Gorilla_Sprite.png"]];
    if (self) {
        _bodyParts = [[NSHashTable alloc] init];
        _evolutions = [[NSHashTable alloc] init];
        _creatureID = ID;
        _health = 100;
    }
    return self;
}

- (void) attachPart:(EvoBodyPart *) part
{
    [part attachToPart:_core];
    [_bodyParts addObject:part];
}

- (void) removePart:(EvoBodyPart *) part
{
    [part detachFromPart:_core];
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

- (NSUInteger) hash
{
    return _creatureID;
}


@end
