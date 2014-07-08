//
//  EvoCreature.h
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EvoBodyPart.h"
#import "EvoEvolution.h"

@interface EvoCreature : SKSpriteNode

@property NSString *name;
@property NSUInteger creatureID;
@property NSUInteger nextID;
@property NSHashTable *bodyParts;
@property NSHashTable *evolutions;

@property CGFloat mass;
@property CGFloat volume;

-(EvoCreature *) initWithID:(NSUInteger) ID;

-(void) attachPart:(EvoBodyPart *) part;
-(void) removePart:(EvoBodyPart *) part;
-(void) evolve:(EvoEvolution *) evolution;
-(void) devolve:(EvoEvolution *) evolution;

@end
