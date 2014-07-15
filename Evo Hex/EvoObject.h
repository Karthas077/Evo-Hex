//
//  EvoObject.h
//  Evo Hex
//
//  Created by Steven Buell on 7/10/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Hex.h"

typedef NS_ENUM(NSInteger, SenseType)
{
    Light, //Frequency and intensity
    Vibrations_Air, //Intensity
    Vibrations_Ground, //Intensity
    Chemicals_Gas, //ppm
    Chemicals_Liquid, //ppm
    Chemicals_Solid, //ppm
    ElectricField, //Strength
    MagneticField //Strength
};

/*static NSString * const senses[] =
{@"electromagnetic",
    @"mechanical",
    @"mechanical",
    @"chemical",
    @"chemical",
    @"chemical",
    @"electricField",
    @"magneticField"};*/

@interface EvoObject : SKSpriteNode

@property NSMutableDictionary *data;

- (EvoObject *) initWithTexture:(SKTexture *)texture;
/*
- (CGFloat) health;
- (CGFloat) volume;
- (CGFloat) mass;
- (void) setHealth:(CGFloat) health;
- (void) setVolume:(CGFloat) health;
- (void) setMass:(CGFloat) health;*/

@end
