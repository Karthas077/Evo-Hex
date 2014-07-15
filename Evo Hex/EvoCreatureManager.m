//
//  EvoCreatureManager.m
//  Evo Hex
//
//  Created by Steven Buell on 7/9/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoCreatureManager.h"

@implementation EvoCreatureManager

@synthesize materials;
@synthesize tissues;
@synthesize bodyParts;
@synthesize evolutions;
@synthesize creatures;

#pragma mark Singleton Methods

+ (id) creatureManager
{
    static EvoCreatureManager *creatureManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        creatureManager = [[self alloc] init];
    });
    return creatureManager;
}


- (id) init
{
    self = [super init];
    if (self) {
        materials = [[NSMutableDictionary alloc] init];
        tissues = [[NSMutableDictionary alloc] init];
        bodyParts = [[NSMutableDictionary alloc] init];
        evolutions = [[NSMutableDictionary alloc] init];
        creatures = [[NSMutableDictionary alloc] init];
        _numCreatures = 1;
        _numParts = 3;
    }
    return self;
}

- (BOOL) addMaterial:(EvoMaterial *)material
{
    if ([materials objectForKey:[material name]]==nil) {
        NSLog(@"Initializing %@ template", [material name]);
        [creatures setObject:material forKey:[material name]];
        return YES;
    }
    NSLog(@"Unable to initialze %@ template: Material is already defined.", [material name]);
    return NO;
}

- (BOOL) addTissue:(EvoTissue *)tissue
{
    if ([tissues objectForKey:[tissue name]]==nil) {
        NSLog(@"Initializing %@ template", [tissue name]);
        [tissues setObject:tissue forKey:[tissue name]];
        return YES;
    }
    NSLog(@"Unable to initialze %@ template: Tissue is already defined.", [tissue name]);
    return NO;
}

- (BOOL) addBodyPart:(EvoBodyPart *)bodyPart
{
    if ([bodyParts objectForKey:[bodyPart name]]==nil) {
        NSLog(@"Initializing %@ template", [bodyPart name]);
        [bodyParts setObject:bodyPart forKey:[bodyPart name]];
        return YES;
    }
    NSLog(@"Unable to initialze %@ template: Bodypart is already defined.", [bodyPart name]);
    return NO;
}

- (BOOL) addEvolution:(EvoEvolution *)evolution
{
    if ([evolutions objectForKey:[evolution name]]==nil) {
        NSLog(@"Initializing %@", [evolution name]);
        [evolutions setObject:evolution forKey:[evolution name]];
        return YES;
    }
    NSLog(@"Unable to initialze %@: Evolution is already defined.", [evolution name]);
    return NO;
}

- (BOOL) addCreature:(EvoCreature *)creature
{
    if ([creatures objectForKey:[creature type]]==nil) {
        NSLog(@"Initializing %@ template", [creature type]);
        //NSLog(@"Data:\n%@", [creature data]);
        [creatures setObject:creature forKey:[creature type]];
        return YES;
    }
    NSLog(@"Unable to initialze %@ template: Creature is already defined.", [creature name]);
    return NO;
}

- (EvoCreature *) spawnCreatureWithType:(NSString *) type
{
    EvoCreature *newCreature = [[creatures valueForKey:type] copy];
    [newCreature setCreatureID:_numCreatures];
    _numCreatures++;
    
    [newCreature setName:@"Computer"];
    if ([type isEqualToString:@"primate"]) {
        [newCreature setTexture:[SKTexture textureWithImageNamed:@"Assets/Sprites/Gorilla_Sprite.png"]];
    }
    else {
        [newCreature setTexture:[SKTexture textureWithImageNamed:@"Assets/Sprites/Bear_Sprite.png"]];
    }
    [newCreature setScale:0.4];
    [newCreature setZPosition:9];
    
    return newCreature;
}

- (EvoCreature *) spawnCreatureWithType:(NSString *)type challenge:(CGFloat)challenge
{
    EvoCreature *newCreature = [self spawnCreatureWithType:type];
    [newCreature setValue:[NSNumber numberWithFloat:[[newCreature valueForKey:@"health"] floatValue]*challenge] forKey:@"health"];
    [newCreature setValue:[NSNumber numberWithFloat:[[newCreature valueForKey:@"maxHealth"] floatValue]*challenge] forKey:@"maxHealth"];
    [newCreature setValue:[NSNumber numberWithFloat:[[newCreature valueForKey:@"attackPower"] floatValue]*challenge] forKey:@"attackPower"];
    [newCreature setValue:[NSNumber numberWithFloat:[[newCreature valueForKey:@"biomass"] floatValue]*challenge] forKey:@"biomass"];
    
    [newCreature setXScale:[newCreature xScale]*((challenge/2)+0.5)];
    [newCreature setYScale:[newCreature yScale]*((challenge/2)+0.5)];
    
    return newCreature;
}

@end
