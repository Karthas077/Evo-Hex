//
//  EvoEvolution.h
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EvoCreature;

@interface EvoEvolution : NSObject

@property NSUInteger ID;

-(EvoEvolution *) initFromFile:(NSString *) file;
-(void) addToCreature:(EvoCreature *) creature;
-(void) removeFromCreature;

@end
