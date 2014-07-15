//
//  EvoCreature.m
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoCreature.h"

@implementation EvoCreature

- (EvoCreature *) initWithDictionary:(NSMutableDictionary *)data
{
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"Assets/Sprites/Gorilla_Sprite.png"]];
    if (self) {
        [self setData:[data mutableCopy]];
    }
    return self;
}

/*- (CGFloat) stamina
{
    return [[[self data] valueForKey:@"stamina"] floatValue];
}
- (CGFloat) biomass
{
    return [[[self data] valueForKey:@"biomass"] floatValue];
}
- (id) target
{
    return [[self data] valueForKey:@"target"];
}
- (void) setStamina:(CGFloat) stamina
{
    [[self data] setValue:[NSNumber numberWithFloat:stamina] forKey:@"stamina"];
}
- (void) setBiomass:(CGFloat) biomass
{
    [[self data] setValue:[NSNumber numberWithFloat:biomass] forKey:@"biomass"];
}
- (void) setTarget:(id) target
{
    [[self data] setValue:target forKey:@"target"];
}*/

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

- (id)copyWithZone:(NSZone *)zone
{
    return [[EvoCreature alloc] initWithDictionary:[self data]];
}

- (NSUInteger) hash
{
    return _creatureID;
}

- (id) valueForKey:(NSString *)key
{
    return [[self data] objectForKey:key];
}

- (id) valueForKeyPath:(NSString *)keyPath
{
    return [[self data] valueForKeyPath:keyPath];
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    [[self data] setValue:value forKey:key];
}

- (void) setValue:(id)value forKeyPath:(NSString *)keyPath
{
    [[self data] setValue:value forKeyPath:keyPath];
}

- (void) addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    [[self data] addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void) removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    [[self data] removeObserver:observer forKeyPath:keyPath];
}

- (void) removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    [[self data] removeObserver:observer forKeyPath:keyPath context:context];
}


@end
