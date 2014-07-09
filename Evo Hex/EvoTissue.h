//
//  EvoTissue.h
//  Evo Hex
//
//  Created by Steven Buell on 7/8/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoMaterial.h"

@interface EvoTissue : NSObject

@property NSString *name;
@property NSUInteger ID;
@property CGFloat volume;
@property EvoMaterial *material;
@property CGFloat damage;
@property CGFloat healingRate;
@property CGFloat regenLimit; //Minimum damage value after healing
@property CGFloat regenLimitFactor; //% recovery

@property NSDictionary *data;


@property Boolean connective;
@property Boolean functional;
@property Boolean structural;

//Cardiovascular System
@property Boolean respirative;
@property Boolean vascular;
@property CGFloat fluidPressure; //Rate of blood/fluid loss
@property EvoTissue *contains;

//Nervous System
@property Boolean nervous; //Enables connected functional parts
@property Boolean cognitive; //Ganglions etc.
@property CGFloat painCoefficient; //Damage to pain ratio

//Digestive System
@property Boolean digestive;
@property Boolean energyStore;
@property CGFloat energyMassRatio;

//Muscular System
@property Boolean muscular;
@property CGFloat strengthVolumeRatio;

//Skeletal System


//Integumentary System



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

@property Boolean insulation;
@property Boolean pattern;
@property NSString *tissueShape;
@property EvoTissue *parent;
@property NSString *tissueMatState;

- (EvoTissue *) initFromFile:(NSString *) file;
- (CGFloat) getDensity;
- (CGFloat) getMass;

@end
