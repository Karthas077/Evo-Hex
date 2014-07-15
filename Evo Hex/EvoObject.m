//
//  EvoObject.m
//  Evo Hex
//
//  Created by Steven Buell on 7/10/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoObject.h"

@implementation EvoObject

- (EvoObject *) initWithTexture:(SKTexture *)texture
{
    self = [super initWithTexture:texture];
    if (self) {
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}
/*
- (CGFloat) health
{
    return [[_data valueForKey:@"health"] floatValue];
}
- (CGFloat) volume
{
    return [[_data valueForKey:@"volume"] floatValue];
}
- (CGFloat) mass
{
    return [[_data valueForKey:@"mass"] floatValue];
}
- (void) setHealth:(CGFloat) health
{
    [_data setValue:[NSNumber numberWithFloat:health] forKey:@"health"];
}
- (void) setVolume:(CGFloat) volume
{
    [_data setValue:[NSNumber numberWithFloat:volume] forKey:@"volume"];
}
- (void) setMass:(CGFloat) mass
{
    [_data setValue:[NSNumber numberWithFloat:mass] forKey:@"mass"];
}*/

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

@end
