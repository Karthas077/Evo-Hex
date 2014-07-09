//
//  EvoCreatureManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/9/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoDataManager.h"

@interface EvoCreatureManager : NSObject

@property NSArray *materials;
@property NSArray *tissues;
@property NSArray *creatureFunctions;
@property NSArray *bodyParts;
@property NSArray *evolutions;
@property NSMutableArray *creatures;

@end
