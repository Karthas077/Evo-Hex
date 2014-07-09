//
//  EvoDataManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/9/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoCreature.h"

@interface EvoDataManager : NSObject {
    NSArray *activeMods;
    NSString *appSupportPath;
    NSString *materialsPath;
    NSString *tissuesPath;
    NSString *bodyPartsPath;
    NSString *functionsPath;
    NSString *creaturesPath;
    NSString *evolutionsPath;
}

@property (nonatomic, retain) NSArray *activeMods;
@property (nonatomic, retain) NSString *appSupportPath;
@property (nonatomic, retain) NSString *materialsPath;
@property (nonatomic, retain) NSString *tissuesPath;
@property (nonatomic, retain) NSString *bodyPartsPath;
@property (nonatomic, retain) NSString *functionsPath;
@property (nonatomic, retain) NSString *creaturesPath;
@property (nonatomic, retain) NSString *evolutionsPath;

+ (id) dataManager;
- (BOOL) setupDirectories;

- (void) setModList:(NSArray *)modList;

- (NSArray *) loadMaterials;
- (EvoMaterial *) parseMaterial:(NSString *)file;
- (NSArray *) loadTissues;
- (EvoTissue *) parseTissue:(NSString *)file;
- (NSArray *) loadBodyParts;
- (EvoBodyPart *) parseBodyPart:(NSString *)file;
- (NSArray *) loadFunctions;
- (EvoCreatureFunction *) parseCreatureFunction:(NSString *)file;
- (NSArray *) loadCreatures;
- (EvoCreature *) parseCreature:(NSString *)file;
- (NSArray *) loadEvolutions;
- (EvoEvolution *) parseEvolution:(NSString *)file;

@end
