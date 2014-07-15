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

@property CGFloat matTempDamage; //Damage per degree
@property CGFloat functionalTemp;
@property CGFloat tempRange;

@property NSDictionary *data;


@property Boolean functional;
@property Boolean connective;
@property Boolean structural;

//Circulatory System
@property CGFloat fluidPressure; //Rate of blood/fluid loss
@property EvoTissue *contains;

//Respiratory System

//Nervous System
@property Boolean cognitive; //Ganglions etc.
@property CGFloat painCoefficient; //Damage to pain ratio

//Endocrine System

//Lymphatic System

//Digestive System

//Muscular System
@property CGFloat strengthVolumeRatio;

//Skeletal System (bones cartilage ligaments tendons)

//Integumentary System (skin hair fat nails)
@property Boolean staminaStore;
@property CGFloat staminaMassRatio;

- (EvoTissue *) init;
- (CGFloat) getDensity;
- (CGFloat) getMass;

@end
