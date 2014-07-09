//
//  EvoMaterial.m
//  Evo Hex
//
//  Created by Steven Buell on 7/8/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoMaterial.h"

@implementation EvoMaterial

- (EvoMaterial *) initFromFile:(NSString *)file
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSUInteger) hash
{
    return _ID;
}

@end
