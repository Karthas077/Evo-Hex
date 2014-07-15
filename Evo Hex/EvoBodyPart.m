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

- (EvoBodyPart *) initWithID:(NSUInteger)ID
{
    self = [super init];
    if (self) {
        _attachedParts = [NSHashTable weakObjectsHashTable];
        _tissues = [[NSMutableArray alloc] init];
        _ID = ID;
        _damage = 0;
    }
    return self;
}


- (void) attachTissue:(EvoTissue *)tissue
{
    _mass += [tissue getMass];
    _volume += [tissue volume];
    [_tissues addObject:tissue];
}

- (void) removeTissue:(EvoTissue *)tissue
{
    if ([_tissues containsObject:tissue]) {
        _mass -= [tissue getMass];
        _volume -= [tissue volume];
        [_tissues removeObject:tissue];
    }
}

- (void) attachToPart:(EvoBodyPart *) part
{
    //[_creature attachPart:part];
    [_attachedParts addObject:part];
    for (EvoBodyPart *subPart in [[part attachedParts] allObjects]) {
        [_creature attachPart:subPart];
    }
    //[part setParent:self];
}

- (void) detachFromPart:(EvoBodyPart *) part
{
    [_creature removePart:part];
    
    //OtherFunctionality Here
    
    //weak hashtable so this shouldn't be needed. This will probably never even be called
    //[_attachedParts removeObject:part];
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
    for (EvoBodyPart *part in [_attachedParts allObjects]) {
        total_mass += [part mass];
    }
    CGFloat total_damage = (_mass/total_mass) * _damage;
    for (EvoBodyPart *part in [_attachedParts allObjects]) {
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
    //[_parent updatePart];
}

- (void) setVolume:(CGFloat)volume
{
    [_creature setValue:[NSNumber numberWithFloat:[[_creature valueForKey:@"volume"] floatValue] - _volume] forKeyPath:@"volume"];
    _volume = volume;
    [_creature setValue:[NSNumber numberWithFloat:[[_creature valueForKey:@"volume"] floatValue] + _volume] forKeyPath:@"volume"];
}

- (void) setMass:(CGFloat)mass
{
    [_creature setValue:[NSNumber numberWithFloat:[[_creature valueForKey:@"mass"] floatValue] - _mass] forKeyPath:@"mass"];
    _mass = mass;
    [_creature setValue:[NSNumber numberWithFloat:[[_creature valueForKey:@"mass"] floatValue] + _mass] forKeyPath:@"mass"];
}


- (NSUInteger) hash
{
    return _ID;
}

@end
