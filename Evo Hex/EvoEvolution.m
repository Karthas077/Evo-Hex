//
//  EvoEvolution.m
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoEvolution.h"
#import "EvoCreature.h"

@implementation EvoEvolution

-(EvoEvolution *) initFromFile:(NSString *)file
{
    self = [super init];
    if (self) {
        //setID
    }
    return self;
}

- (void) addToCreature:(EvoCreature *)creature
{
    
}

- (void) removeFromCreature
{
    
}

- (NSUInteger) hash
{
    return _ID;
}

@end
