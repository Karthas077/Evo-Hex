//
//  EvoCreature.h
//  Evo Hex
//
//  Created by Steven Buell on 7/7/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EvoObject.h"
#import "EvoBodyPart.h"
#import "EvoEvolution.h"

@interface EvoCreature : EvoObject

@property NSString *type;
@property NSUInteger creatureID;
@property Hex *hex;
@property EvoBodyPart *core;
@property NSMutableDictionary *bodyParts;
@property NSHashTable *evolutions;

/*
//FOR SCRIPT TESTING
@property CGFloat healRate;
@property CGFloat stamina;
@property CGFloat staminaRate;
@property CGFloat biomass;
@property CGFloat attackPower;
@property CGFloat noiseLevel;
@property CGFloat visibility;
*/

-(EvoCreature *) initWithDictionary:(NSMutableDictionary *) data;

-(void) attachPart:(EvoBodyPart *) part;
-(void) removePart:(EvoBodyPart *) part;
-(void) evolve:(EvoEvolution *) evolution;
-(void) devolve:(EvoEvolution *) evolution;

//Functions:
//Senses -
//Hearing
//Sight
//Smell
//Taste
//Touch
//Infrared
//Bioelectric Field
//
//Actions -
//Locomotion (Walking Running Swimming Climbing Jumping Flying)
//Attacks (Bite Strike Grapple Spray)
//Deception (Hiding/Camouflage, Mimicry, Inflation, etc.)
//
//Biological Functions -
//Eat
//Breathe
//Defication
//Reproduction

- (BOOL) canDetect:(EvoCreature *)target;

/*
- (CGFloat) stamina;
- (CGFloat) biomass;
- (id) target;
- (void) setStamina:(CGFloat) stamina;
- (void) setBiomass:(CGFloat) biomass;
- (void) setTarget:(id) target;*/

@end
