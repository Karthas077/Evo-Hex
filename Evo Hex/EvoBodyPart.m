//
//  EvoBodyPart.m
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoBodyPart.h"
#import "EvoCreature.h"

@implementation EvoBodyPart

- (EvoBodyPart *) initFromFile:(NSString *) file
{
    self = [super init];
    if (self) {
        _bodyParts = [NSHashTable weakObjectsHashTable];
        _damage = 0;
    }
    return self;
}

- (void) attachToCreature:(EvoCreature *)creature
{
    _creature = creature;
    [_creature setMass:[_creature mass]+_mass];
    [_creature setVolume:[_creature volume]+_volume];
}

- (void) remove
{
    for (EvoBodyPart *part in [_bodyParts allObjects]) {
        [part remove];
    }
    
    [_creature setMass:[_creature mass]-_mass];
    [_creature setVolume:[_creature volume]-_volume];
    
    //weak property so this shouldn't be needed
    //_creature = nil;
}

- (void) attachPart:(EvoBodyPart *) part
{
    [_bodyParts addObject:part];
    [_creature attachPart:part];
    for (EvoBodyPart *subPart in [[part bodyParts] allObjects]) {
        [_bodyParts addObject:subPart];
        [_creature attachPart:subPart];
    }
    [part setParent:self];
}

- (void) removePart:(EvoBodyPart *) part
{
    [_creature removePart:part];
    
    //OtherFunctionality Here
    
    //weak hashtable so this shouldn't be needed. This will probably never even be called
    //[_bodyParts removeObject:part];
}

- (void) updatePart
{
    CGFloat total_damage = [self getCumulativeDamage];
    if (total_damage < 0.25) {
        //Fine
        _isFunctional = YES;
    }
    else if (total_damage < 0.5) {
        //Minor
        _isFunctional = YES;
    }
    else if(total_damage < 0.75) {
        //Inhibbited
        _isFunctional = YES;
    }
    else if(total_damage < 1.0) {
        //Broken
        _isFunctional = NO;
    }
}

- (CGFloat) getCumulativeDamage
{
    CGFloat total_mass = _mass;
    for (EvoBodyPart *part in [_bodyParts allObjects]) {
        total_mass += [part mass];
    }
    CGFloat total_damage = (_mass/total_mass) * _damage;
    for (EvoBodyPart *part in [_bodyParts allObjects]) {
        total_damage += ([part mass]/total_mass) * [part damage];
    }
    return total_damage;
}

-(void) setDamage:(CGFloat)damage
{
    _damage = damage;
    if (_damage >= 1.0) {
        [_creature removePart:self];
    }
    [_parent updatePart];
}

- (void) setVolume:(CGFloat)volume
{
    [_creature setVolume:[_creature volume]-_volume];
    _volume = volume;
    [_creature setVolume:[_creature volume]+_volume];
}

- (void) setMass:(CGFloat)mass
{
    [_creature setMass:[_creature mass]-_mass];
    _mass = mass;
    [_creature setMass:[_creature mass]+_mass];
}


- (NSUInteger) hash
{
    if (_creature) {
        return ([_creature creatureID] << sizeof(NSUInteger)*4)+_ID;
    }
    return 0;
}

@end
