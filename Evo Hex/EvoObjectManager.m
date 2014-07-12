//
//  EvoObjectManager.m
//  Evo Hex
//
//  Created by Steven Buell on 7/11/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoObjectManager.h"

@implementation EvoObjectManager

@synthesize objects;

#pragma mark Singleton Methods

+ (id) objectManager
{
    static EvoObjectManager *objectManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectManager = [[self alloc] init];
    });
    return objectManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        objects = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL) addObject:(EvoObject *)object withID:(NSUInteger)ID
{
    [objects setObject:object forKey:[NSNumber numberWithUnsignedInteger:ID]];
    return YES;
}
- (id) getObjectWithID:(NSUInteger)ID
{
    return [objects objectForKey:[NSNumber numberWithUnsignedInteger:ID]];
}

@end
