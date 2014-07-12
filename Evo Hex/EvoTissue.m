//
//  EvoTissue.m
//  Evo Hex
//
//  Created by Steven Buell on 7/8/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoTissue.h"

@implementation EvoTissue

- (EvoTissue *) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (CGFloat) getDensity
{
    return [_material density];
}

- (CGFloat) getMass
{
    return [_material density] * _volume;
}

- (NSUInteger) hash
{
    return _ID;
}

@end
