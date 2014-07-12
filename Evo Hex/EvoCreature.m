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
        _bodyParts = [[NSMutableDictionary alloc] init];
        //For all organ types
        [_bodyParts setObject:[[NSHashTable alloc] init] forKey:@"sensing"];
        [_bodyParts setObject:[[NSHashTable alloc] init] forKey:@"moving"];
        [_bodyParts setObject:[[NSHashTable alloc] init] forKey:@"fighting"];
        [_bodyParts setObject:[[NSHashTable alloc] init] forKey:@"living"];
        
        _evolutions = [[NSHashTable alloc] init];
        _creatureID = ID;
        [self setHealth:100];
    }
    return self;
}

- (void) attachPart:(EvoBodyPart *) part
{
    [part attachToPart:_core];
    [[_bodyParts objectForKey:[part type]] addObject:part];
}

- (void) removePart:(EvoBodyPart *) part
{
    [part detachFromPart:_core];
    [[_bodyParts objectForKey:[part type]] removeObject:part];
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

- (BOOL) canDetect:(EvoObject *) target
{
	for(EvoBodyPart *part in [_bodyParts valueForKey:@"sensing"]) {
		if ([[part function] isEqualToString:@"see"]) {
            //See
        }
        else if([[part function] isEqualToString:@"smell"]) {
            //Smell
        }
        else if([[part function] isEqualToString:@"hear"]) {
            //Hear
        }
	}
    return YES;
}

- (void) attack:(EvoObject *) target
{
    //Currently attacking with all
    CGFloat attackDamage = 0;
    for(EvoBodyPart *part in [_bodyParts valueForKey:@"fighting"]) {
		if ([[part function] isEqualToString:@"bite"]) {
            attackDamage = 10; // * [part efficacy];
            NSLog(@"%@ bites for %f", [self name], attackDamage);
            [target setHealth:([target health] - attackDamage)];
        }
        else if([[part function] isEqualToString:@"strike"]) {
            attackDamage = 10;
            NSLog(@"%@ strikes for %f", [self name], attackDamage);
            [target setHealth:([target health] - attackDamage)];
        }
        else if([[part function] isEqualToString:@"grasp"]) {
            attackDamage = 10;
            NSLog(@"%@ chokes for %f", [self name], attackDamage);
            [target setHealth:([target health] - attackDamage)];
        }
        else if([[part function] isEqualToString:@"poison"]) {
            //Poison!
        }
	}
}


- (NSUInteger) hash
{
    return _creatureID;
}


@end
