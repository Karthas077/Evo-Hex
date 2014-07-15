//
//  EvoCreatureManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/9/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoCreature.h"
#import "EvoScriptManager.h"

@interface EvoCreatureManager : NSObject {
    NSMutableDictionary *materials;
    NSMutableDictionary *tissues;
    NSMutableDictionary *bodyParts;
    NSMutableDictionary *evolutions;
    NSMutableDictionary *creatures;
}

@property NSMutableDictionary *materials;
@property NSMutableDictionary *tissues;
@property NSMutableDictionary *bodyParts;
@property NSMutableDictionary *evolutions;
@property NSMutableDictionary *creatures;
@property NSUInteger numCreatures;
@property NSUInteger numParts;

+ (id) creatureManager;

- (BOOL) addMaterial:(EvoMaterial *)material;
- (BOOL) addTissue:(EvoTissue *)tissue;
- (BOOL) addBodyPart:(EvoBodyPart *)bodyPart;
- (BOOL) addEvolution:(EvoEvolution *)evolution;
- (BOOL) addCreature:(EvoCreature *)creature;
- (EvoCreature *) spawnCreatureWithType:(NSString *)type;
- (EvoCreature *) spawnCreatureWithType:(NSString *)type challenge:(CGFloat) challenge;

@end
