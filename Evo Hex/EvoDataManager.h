//
//  EvoDataManager.h
//  Evo Hex
//
//  Created by Steven Buell on 7/9/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvoScriptManager.h"
#import "EvoCreatureManager.h"

@interface EvoDataManager : NSObject {
    NSArray *activeMods;
    NSString *appSupportPath;
    NSString *gameDataPath;
}

@property (nonatomic, retain) NSArray *activeMods;
@property (nonatomic, retain) NSString *appSupportPath;
@property (nonatomic, retain) NSString *gameDataPath;


+ (id) dataManager;
- (BOOL) setupDirectories;

- (void) setModList:(NSArray *)modList;

- (BOOL) setupModules;
- (NSArray *) getModuleData:(NSString *)moduleName;

- (NSArray *) loadMaterials;
- (EvoMaterial *) parseMaterial:(NSString *)file;
- (NSArray *) loadTissues;
- (EvoTissue *) parseTissue:(NSString *)file;
- (NSArray *) loadBodyParts;
- (EvoBodyPart *) parseBodyPart:(NSString *)file;
- (NSArray *) loadEvolutions;
- (EvoEvolution *) parseEvolution:(NSString *)file;
- (NSArray *) loadCreatures;
- (EvoCreature *) parseCreature:(NSString *)file;
- (NSArray *) loadScripts;
- (EvoScript *) parseScript:(NSString *)file;
@end
