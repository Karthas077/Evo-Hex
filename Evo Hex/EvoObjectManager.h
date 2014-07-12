//
//  EvoObjectManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/11/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoCreature.h"

@interface EvoObjectManager : NSObject {
    NSMutableDictionary *objects;
}

@property (nonatomic, retain) NSMutableDictionary *objects;


+ (id) objectManager;

- (BOOL) addObject:(EvoObject *)object withID:(NSUInteger)ID;
- (id) getObjectWithID:(NSUInteger)ID;

@end
