//
//  EvoAIManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/14/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoCreature.h"
#import "EvoScriptManager.h"

@interface EvoAIManager : NSObject {
    NSHashTable *creatures;
}

@property NSHashTable *creatures;
@property NSUInteger numCreatures;

+ (id) AIManager;

- (void) addCreature:(EvoCreature *)creature;
- (void) update;

@end
